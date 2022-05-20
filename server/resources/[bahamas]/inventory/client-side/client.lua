-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("inventory",cRP)
vSERVER = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local dropList = {}
local useWeapon = ""
local weaponActive = false
local putWeaponHands = false
local storeWeaponHands = false
local timeReload = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
local blockButtons = false
RegisterNetEvent("inventory:blockButtons")
AddEventHandler("inventory:blockButtons",function(status)
	blockButtons = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
function blockInvents()
	return blockButtons
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if blockButtons then
			timeDistance = 1
			DisableControlAction(1,75,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKINVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("blockInvents",blockInvents)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v["x"] << 8) | v["y"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropFunctions()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,0.0)

	local gridZone = getGridzone(coords["x"],coords["y"])
	local _,cdz = GetGroundZFor_3dCoord(coords["x"],coords["y"],coords["z"])

	return coords["x"],coords["y"],cdz,gridZone
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data,cb)
	TriggerEvent("inventory:Close")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("useItem",function(data,cb)
	vSERVER.useItem(data["slot"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	vSERVER.invUpdate(data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Update")
AddEventHandler("inventory:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLEARWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:clearWeapons")
AddEventHandler("inventory:clearWeapons",function()
	if useWeapon ~= "" then
		useWeapon = ""
		weaponActive = false
		RemoveAllPedWeapons(PlayerPedId(),true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:verifyWeapon")
AddEventHandler("inventory:verifyWeapon",function(nameItem,splitName)
	local equipeNow = false
	local ped = PlayerPedId()
	local weaponAmmo = GetAmmoInPedWeapon(ped,useWeapon)

	if useWeapon == splitName then
		vSERVER.preventWeapon(useWeapon,weaponAmmo)
		weaponActive = false
		equipeNow = true
		useWeapon = ""
	end

	if not vSERVER.checkExistWeapon(nameItem,weaponAmmo,equipeNow) then
		if HasPedGotWeapon(ped,GetHashKey(splitName),false) then
			RemoveAllPedWeapons(ped,true)
		end
	end
	
	RemoveAllPedWeapons(ped,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:PREVENTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:preventWeapon")
AddEventHandler("inventory:preventWeapon",function(storeWeapons)
	local ped = PlayerPedId()
	if GetSelectedPedWeapon(ped) ~= GetHashKey("WEAPON_UNARMED") then
		local weaponAmmo = GetAmmoInPedWeapon(ped,useWeapon)

		vSERVER.preventWeapon(useWeapon,weaponAmmo)

		weaponActive = false
		useWeapon = ""

		if storeWeapons then
			RemoveAllPedWeapons(ped,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.enterVehicle()
	local ped = PlayerPedId()
	if GetVehiclePedIsTryingToEnter(ped) > 0 then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("moc",function(source,args)
	if GetEntityHealth(PlayerPedId()) > 101 and not blockButtons then
		if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not IsPlayerFreeAiming(PlayerId()) then
			SetNuiFocus(true,true)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ action = "showMenu" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("moc","Abrir a mochila","keyboard","oem_3")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.plateVehicle()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			FreezeEntityPosition(vehicle,true)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEAPPLY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.plateApply(plate)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)

		SetVehicleNumberPlateText(vehicle,plate)
		FreezeEntityPosition(vehicle,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairVehicle")
AddEventHandler("inventory:repairVehicle",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if GetVehicleNumberPlateText(v) == vehPlate then
				local vehTyres = {}
				local fuel = GetVehicleFuelLevel(v)

				for i = 0,7 do
					local tyre_state = 2
					if IsVehicleTyreBurst(v,i,true) then
						tyre_state = 1
					elseif IsVehicleTyreBurst(v,i,false) then
						tyre_state = 0
					end

					vehTyres[i] = tyre_state
				end

				SetVehicleFixed(v)
				SetVehicleFuelLevel(v,fuel)

				for k,vs in pairs(vehTyres) do
					if vs < 2 then
						SetVehicleTyreBurst(v,k,(vs == 1),1000.0)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairAdmin")
AddEventHandler("inventory:repairAdmin",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if GetVehicleNumberPlateText(v) == vehPlate then
				local fuel = GetVehicleFuelLevel(v)

				SetVehicleFixed(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRTIRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairTires")
AddEventHandler("inventory:repairTires",function(vehIndex)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			for i = 0,7 do
				SetVehicleTyreFixed(v,i)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARACHUTECOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.parachuteColors()
	local ped = PlayerPedId()
	GiveWeaponToPed(ped,"GADGET_PARACHUTE",1,false,true)
	SetPedParachuteTintIndex(ped,math.random(7))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKFOUNTAIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkFountain()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler"),true) or DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler_dark"),true) then
		return true,"fountain"
	end

	if IsEntityInWater(ped) then
		return true,"floor"
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHINGANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.fishingAnim()
	local ped = PlayerPedId()
	if IsEntityPlayingAnim(ped,"amb@world_human_stand_fishing@idle_a","idle_c",3) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkWeapon()
	local ped = PlayerPedId()
	if (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) and not IsPedSwimming(ped) then
		if GetSelectedPedWeapon(ped) ~= GetHashKey("WEAPON_UNARMED") then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.putWeaponHands(weaponName,weaponAmmo)
	if not putWeaponHands then
		if weaponAmmo > 0 then
			weaponActive = true
		end

		putWeaponHands = true
		TriggerEvent("cancelando",true)

		local ped = PlayerPedId()
		if HasPedGotWeapon(ped,GetHashKey("GADGET_PARACHUTE"),false) then
			RemoveAllPedWeapons(ped,true)
			GiveWeaponToPed(ped,"GADGET_PARACHUTE",1,false,true)
			SetPedParachuteTintIndex(ped,math.random(7))
		else
			RemoveAllPedWeapons(ped,true)
		end

		if not IsPedInAnyVehicle(ped) then
			loadAnimDict("rcmjosh4")

			TaskPlayAnim(ped,"rcmjosh4","josh_leadout_cop2",3.0,2.0,-1,48,10,0,0,0)

			Wait(200)

			GiveWeaponToPed(ped,weaponName,weaponAmmo,false,true)

			Wait(300)

			ClearPedTasks(ped)
		else
			GiveWeaponToPed(ped,weaponName,weaponAmmo,true,true)
		end

		TriggerEvent("cancelando",false)
		useWeapon = weaponName
		putWeaponHands = false

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeWeaponHands()
	if not storeWeaponHands then
		storeWeaponHands = true
		TriggerEvent("cancelando",true)

		local ped = PlayerPedId()
		local lastWeapon = useWeapon
		local weaponAmmo = GetAmmoInPedWeapon(ped,useWeapon)

		if not IsPedInAnyVehicle(ped) then
			loadAnimDict("weapons@pistol@")

			TaskPlayAnim(ped,"weapons@pistol@","aim_2_holster",3.0,2.0,-1,48,10,0,0,0)

			Wait(450)

			ClearPedTasks(ped)
		end

		if HasPedGotWeapon(ped,GetHashKey("GADGET_PARACHUTE"),false) then
			RemoveAllPedWeapons(ped,true)
			GiveWeaponToPed(ped,"GADGET_PARACHUTE",1,false,true)
			SetPedParachuteTintIndex(ped,math.random(7))
		else
			RemoveAllPedWeapons(ped,true)
		end

		weaponActive = false
		useWeapon = ""

		storeWeaponHands = false
		TriggerEvent("cancelando",false)

		return true,weaponAmmo,lastWeapon
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONAMMOS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponAmmos = {
	["WEAPON_PISTOL_AMMO"] = {
		"WEAPON_PISTOL",
		"WEAPON_PISTOL_MK2",
		"WEAPON_PISTOL50",
		"WEAPON_REVOLVER",
		"WEAPON_COMBATPISTOL",
		"WEAPON_APPISTOL",
		"WEAPON_HEAVYPISTOL",
		"WEAPON_SNSPISTOL",
		"WEAPON_SNSPISTOL_MK2",
		"WEAPON_VINTAGEPISTOL"
	},
	["WEAPON_SMG_AMMO"] = {
		"WEAPON_COMPACTRIFLE",
		"WEAPON_MICROSMG",
		"WEAPON_MINISMG",
		"WEAPON_SMG",
		"WEAPON_SMG_MK2",
		"WEAPON_ASSAULTSMG",
		"WEAPON_GUSENBERG",
		"WEAPON_MACHINEPISTOL"
	},
	["WEAPON_RIFLE_AMMO"] = {
		"WEAPON_CARBINERIFLE",
		"WEAPON_CARBINERIFLE_MK2",
		"WEAPON_BULLPUPRIFLE",
		"WEAPON_BULLPUPRIFLE_MK2",
		"WEAPON_ADVANCEDRIFLE",
		"WEAPON_ASSAULTRIFLE",
		"WEAPON_ASSAULTRIFLE_MK2",
		"WEAPON_SPECIALCARBINE",
		"WEAPON_SPECIALCARBINE_MK2"
	},
	["WEAPON_SHOTGUN_AMMO"] = {
		"WEAPON_PUMPSHOTGUN",
		"WEAPON_PUMPSHOTGUN_MK2",
		"WEAPON_SAWNOFFSHOTGUN"
	},
	["WEAPON_MUSKET_AMMO"] = {
		"WEAPON_SNIPERRIFLE",
		"WEAPON_MUSKET"
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		"WEAPON_PETROLCAN"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGECHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.rechargeCheck(ammoType)
	local weaponHash = nil
	local ped = PlayerPedId()
	local weaponStatus = false

	if weaponAmmos[ammoType] then
		local weaponAmmo = GetAmmoInPedWeapon(ped,useWeapon)

		for k,v in pairs(weaponAmmos[ammoType]) do
			if useWeapon == v then
				weaponHash = GetHashKey(useWeapon)
				weaponStatus = true
				break
			end
		end
	end

	return weaponStatus,weaponHash,weaponAmmo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.rechargeWeapon(weaponHash,ammoAmount)
	AddAmmoToPed(PlayerPedId(),weaponHash,ammoAmount)
	weaponActive = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOREWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if weaponActive and useWeapon ~= "" then
			timeDistance = 100
			local ped = PlayerPedId()
			local weaponAmmo = GetAmmoInPedWeapon(ped,useWeapon)

			if GetGameTimer() >= timeReload and IsPedReloading(ped) then
				vSERVER.preventWeapon(useWeapon,weaponAmmo)
				timeReload = GetGameTimer() + 10000
			end

			if weaponAmmo <= 0 or (useWeapon == "WEAPON_PETROLCAN" and weaponAmmo <= 135 and IsPedShooting(ped)) or IsPedSwimming(ped) then
				vSERVER.preventWeapon(useWeapon,weaponAmmo)
				RemoveAllPedWeapons(ped,true)
				weaponActive = false
				useWeapon = ""
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADRENALINECDS
-----------------------------------------------------------------------------------------------------------------------------------------
local adrenalineCds = {
	{ 1978.98,5171.98,47.63 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADRENALINEDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.adrenalineDistance()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for k,v in pairs(adrenalineCds) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 5 then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
local fireTimers = nil
local firecracker = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if fireTimers ~= nil then
			if GetGameTimer() >= fireTimers then
				fireTimers = nil
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkCracker()
	if fireTimers ~= nil then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Firecracker")
AddEventHandler("inventory:Firecracker",function()
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
			Wait(1)
		end
	end

	local mHash = GetHashKey("ind_prop_firework_03")

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	if HasModelLoaded(mHash) then
		local explosives = 25
		local ped = PlayerPedId()
		fireTimers = GetGameTimer() + (5 * 60000)
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.6,0.0)
		firecracker = CreateObject(mHash,coords["x"],coords["y"],coords["z"],true,true,false)

		PlaceObjectOnGroundProperly(firecracker)
		FreezeEntityPosition(firecracker,true)
		SetEntityAsNoLongerNeeded(firecracker)
		SetModelAsNoLongerNeeded(mHash)

		Wait(10000)

		repeat
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local explode = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst",coords["x"],coords["y"],coords["z"],0.0,0.0,0.0,2.5,false,false,false,false)
			explosives = explosives - 1

			Wait(2000)
		until explosives <= 0

		TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(firecracker))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWATER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkWater()
	return IsPedSwimming(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false
RegisterNetEvent("toggleCarry")
AddEventHandler("toggleCarry",function(source)
	uCarry = source
	iCarry = not iCarry

	local ped = PlayerPedId()
	if iCarry and uCarry then
		Citizen.InvokeNative(0x6B9BBD38AB0796DF,ped,GetPlayerPed(GetPlayerFromServerId(uCarry)),4103,11816,0.48,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped,false,false)
			sCarry = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIMDIC
-----------------------------------------------------------------------------------------------------------------------------------------
function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
local stockTimers = 0
local stockVehicle = nil

local losSantos = PolyZone:Create({
	vector2(-2153.08,-3131.33),
	vector2(-1581.58,-2092.38),
	vector2(-3271.05,275.85),
	vector2(-3460.83,967.42),
	vector2(-3202.39,1555.39),
	vector2(-1642.50,993.32),
	vector2(312.95,1054.66),
	vector2(1313.70,341.94),
	vector2(1739.01,-1280.58),
	vector2(1427.42,-3440.38),
	vector2(-737.90,-3773.97)
},{ name="santos" })

function cRP.checkStockade(vehNet)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if losSantos:isPointInside(coords) then
		if not IsPedInAnyVehicle(ped) then
			local vehicle = vRP.nearVehicle(10)
			if NetworkGetNetworkIdFromEntity(vehicle) == vehNet then
				if DoesEntityExist(vehicle) and GetEntityModel(vehicle) == GetHashKey("stockade") then
					local coordsVeh = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-3.5,0.0)
					local distance = #(coords - coordsVeh)
					if distance <= 1.5 then
						stockTimers = 30
						stockVehicle = vehicle

						return NetworkGetNetworkIdFromEntity(vehicle)
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPLODESTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if stockTimers > 0 then
			stockTimers = stockTimers - 1

			if stockTimers <= 0 then
				local coordsVeh = GetOffsetFromEntityInWorldCoords(stockVehicle,0.0,-4.5,0.0)
				local _,cdz = GetGroundZFor_3dCoord(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"])
				local gridZone = getGridzone(coordsVeh["x"],coordsVeh["y"])

				SetVehicleDoorBroken(stockVehicle,2,false)
				SetVehicleDoorBroken(stockVehicle,3,false)
				vSERVER.dropStockade(coordsVeh["x"],coordsVeh["y"],cdz,gridZone)
				AddExplosion(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"],"EXPLOSION_TANKER",2.0,true,false,2.0)
				ApplyForceToEntity(stockVehicle,0,coordsVeh["x"],coordsVeh["y"],coordsVeh["z"],0.0,0.0,0.0,1,false,true,true,true,true)

				stockVehicle = nil
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DROPREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:dropRemove")
AddEventHandler("inventory:dropRemove",function(gridZone,numberSelect)
	if dropList[gridZone] then
		if dropList[gridZone][numberSelect] then
			dropList[gridZone][numberSelect] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DROPINSERT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:dropInsert")
AddEventHandler("inventory:dropInsert",function(gridZone,numberSelect,dropTable)
	if dropList[gridZone] == nil then
		dropList[gridZone] = {}
	end

	dropList[gridZone][numberSelect] = dropTable
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DROPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:dropList")
AddEventHandler("inventory:dropList",function(dropTable)
	dropList = dropTable
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropItem",function(data,cb)
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,0.0)

	local gridZone = getGridzone(coords["x"],coords["y"])
	local _,cdz = GetGroundZFor_3dCoord(coords["x"],coords["y"],coords["z"])

	vSERVER.dropItem(data["item"],data["slot"],data["amount"],coords["x"],coords["y"],cdz,gridZone)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDROPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local gridZone = getGridzone(coords["x"],coords["y"])

		if dropList[gridZone] then
			for k,v in pairs(dropList[gridZone]) do
				local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
				if distance <= 50 then
					timeDistance = 1
					DrawMarker(23,v["coords"][1],v["coords"][2],v["coords"][3] + 0.05,0.0,0.0,0.0,0.0,180.0,0.0,0.15,0.15,0.0,255,255,255,50,0,0,0,0)
					DrawMarker(21,v["coords"][1],v["coords"][2],v["coords"][3] + 0.25,0.0,0.0,0.0,0.0,180.0,0.0,0.20,0.20,0.20,42,137,255,125,0,0,0,1)
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBackpack",function(data,cb)
	local dropItems = {}
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local gridZone = getGridzone(coords["x"],coords["y"])
	local _,cdz = GetGroundZFor_3dCoord(coords["x"],coords["y"],coords["z"])

	if dropList[gridZone] then
		for k,v in pairs(dropList[gridZone]) do
			local distance = #(vector3(coords["x"],coords["y"],cdz) - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
			if distance <= 0.9 then
				v["id"] = k
				table.insert(dropItems,v)
			end
		end
	end

	local inventario,invPeso,invMaxpeso = vSERVER.requestBackpack()
	if inventario then
		cb({ inventario = inventario, drop = dropItems, invPeso = invPeso, invMaxpeso = invMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pickupItem",function(data,cb)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local gridZone = getGridzone(coords["x"],coords["y"])

	vSERVER.itemPickup(data["id"],data["amount"],data["target"],gridZone)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEELCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.wheelChair(vehPlate)
	local ped = PlayerPedId()
	local vehName = "wheelchair"
	local mHash = GetHashKey(vehName)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	local heading = GetEntityHeading(ped)
	local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.75,0.0)
	local nveh = CreateVehicle(mHash,coords["x"],coords["y"],coords["z"],heading,true,true)

	SetVehicleOnGroundProperly(nveh)
	SetVehicleNumberPlateText(nveh,vehPlate)
	SetEntityAsMissionEntity(nveh,true,true)
	SetModelAsNoLongerNeeded(mHash)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEELTREADS
-----------------------------------------------------------------------------------------------------------------------------------------
local wheelChair = false
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(vehicle)
			if model == -1178021069 then
				if not IsEntityPlayingAnim(ped,"missfinale_c2leadinoutfin_c_int","_leadin_loop2_lester",3) then
					vRP.playAnim(true,{"missfinale_c2leadinoutfin_c_int","_leadin_loop2_lester"},true)
					wheelChair = true
				end
			end
		else
			if wheelChair then
				vRP.removeObjects("one")
				wheelChair = false
			end
		end

		Wait(1000)
	end
end)