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
Tunnel.bindInterface("player",cRP)
vSERVER = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaAttachs = {
	["WEAPON_PISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_HEAVYPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_PISTOL_MK2"] = {
		"COMPONENT_AT_PI_RAIL",
		"COMPONENT_AT_PI_FLSH_02",
		"COMPONENT_AT_PI_COMP"
	},
	["WEAPON_COMBATPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_APPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_MICROSMG"] = {
		"COMPONENT_AT_PI_FLSH",
		"COMPONENT_AT_SCOPE_MACRO"
	},
	["WEAPON_SMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02",
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTSMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_SUPP_02"
	},
	["WEAPON_COMBATPDW"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_AR_AFGRIP",
		"COMPONENT_AT_SCOPE_SMALL"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		"COMPONENT_AT_AR_FLSH"
	},
	["WEAPON_CARBINERIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_ASSAULTRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_MACHINEPISTOL"] = {
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		"COMPONENT_AT_AR_AFGRIP_02",
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_PISTOL50"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		"COMPONENT_AT_PI_FLSH_03",
		"COMPONENT_AT_PI_RAIL_02",
		"COMPONENT_AT_PI_COMP_02"
	},
	["WEAPON_SMG_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_BULLPUPRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_SMALL",
		"COMPONENT_AT_AR_SUPP"
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_SPECIALCARBINE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("attachs",function(source,args)
	local ped = PlayerPedId()
	for k,v in pairs(weaAttachs) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			for k2,v2 in pairs(v) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCOMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
local blockCommands = false
RegisterNetEvent("player:blockCommands")
AddEventHandler("player:blockCommands",function(status)
	blockCommands = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
function blocks()
	if exports["player"]:handCuff() then
		return false
	end

	return blockCommands
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCOMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("blockCommands",blocks)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local salaryTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= salaryTimers then
			salaryTimers = GetGameTimer() + (30 * 60000)
			vSERVER.receiveSalary()
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AWAYSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
local awayTimers = GetGameTimer()
local awaySystem = { 0.0,0.0,1800 }

CreateThread(function()
	while true do
		if GetGameTimer() >= awayTimers then
			awayTimers = GetGameTimer() + 10000

			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			if coords["x"] == awaySystem[1] and coords["y"] == awaySystem[2] then
				if awaySystem[3] > 0 then
					awaySystem[3] = awaySystem[3] - 10

					if awaySystem[3] == 60 or awaySystem[3] == 30 then
						TriggerEvent("Notify","amarelo","Mova-se e evite ser desconectado.",3000)
					end
				else
					TriggerServerEvent("player:kickSystem","Desconectado, muito tempo ausente.")
				end
			else
				awaySystem[1] = coords["x"]
				awaySystem[2] = coords["y"]
				awaySystem[3] = 1800
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATSHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
			local veh = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(veh,0) == ped then
				if not GetIsTaskActive(ped,164) and GetIsTaskActive(ped,165) then
					SetPedIntoVehicle(ped,veh,0)
					SetPedConfigFlag(ped,184,true)
					SetVehicleCloseDoorDeferedAction(veh,0)
				end
			end
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
local energetic = 0
RegisterNetEvent("setEnergetic")
AddEventHandler("setEnergetic",function(timers,number)
	energetic = energetic + timers
	SetRunSprintMultiplierForPlayer(PlayerId(),number)
end)

CreateThread(function()
	while true do
		if energetic > 0 then
			RestorePlayerStamina(PlayerId(),1.0)
		end

		Wait(1000)
	end
end)

CreateThread(function()
	while true do
		if energetic > 0 then
			energetic = energetic - 1

			if energetic <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
				energetic = 0
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETECSTASY
-----------------------------------------------------------------------------------------------------------------------------------------
local ecstasy = 0
RegisterNetEvent("setEcstasy")
AddEventHandler("setEcstasy",function()
	ecstasy = ecstasy + 10

	if not GetScreenEffectIsActive("MinigameTransitionIn") then
		StartScreenEffect("MinigameTransitionIn",0,true)
	end
end)

CreateThread(function()
	while true do
		if ecstasy > 0 then
			ecstasy = ecstasy - 1
			ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)

			if ecstasy <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				ecstasy = 0

				TriggerServerEvent("upgradeStress",100)
				if GetScreenEffectIsActive("MinigameTransitionIn") then
					StopScreenEffect("MinigameTransitionIn")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMETH
-----------------------------------------------------------------------------------------------------------------------------------------
local methanfetamine = 0
RegisterNetEvent("setMeth")
AddEventHandler("setMeth",function()
	methanfetamine = methanfetamine + 30

	if not GetScreenEffectIsActive("DMT_flight") then
		StartScreenEffect("DMT_flight",0,true)
	end
end)

CreateThread(function()
	while true do
		if methanfetamine > 0 then
			methanfetamine = methanfetamine - 1

			if methanfetamine <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				methanfetamine = 0

				if GetScreenEffectIsActive("DMT_flight") then
					StopScreenEffect("DMT_flight")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
local cocaine = 0
RegisterNetEvent("setCocaine")
AddEventHandler("setCocaine",function()
	cocaine = cocaine + 30

	if not GetScreenEffectIsActive("MinigameTransitionIn") then
		StartScreenEffect("MinigameTransitionIn",0,true)
	end
end)

CreateThread(function()
	while true do
		if cocaine > 0 then
			cocaine = cocaine - 1

			if cocaine <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				cocaine = 0

				if GetScreenEffectIsActive("MinigameTransitionIn") then
					StopScreenEffect("MinigameTransitionIn")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANEFFECTDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cleanEffectDrugs")
AddEventHandler("cleanEffectDrugs",function()
	if GetScreenEffectIsActive("MinigameTransitionIn") then
		StopScreenEffect("MinigameTransitionIn")
	end

	if GetScreenEffectIsActive("DMT_flight") then
		StopScreenEffect("DMT_flight")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local drunkTime = 0
RegisterNetEvent("setDrunkTime")
AddEventHandler("setDrunkTime",function(timers)
	drunkTime = drunkTime + timers

	TriggerEvent("vrp:blockDrunk",true)
	RequestAnimSet("move_m@drunk@verydrunk")
	while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
		Wait(1)
	end

	SetPedMovementClipset(PlayerPedId(),"move_m@drunk@verydrunk",0.25)
end)

CreateThread(function()
	while true do
		if drunkTime > 0 then
			drunkTime = drunkTime - 1

			if drunkTime <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				ResetPedMovementClipset(PlayerPedId(),0.25)
				TriggerEvent("vrp:blockDrunk",false)
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCHOODOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncHoodOptions")
AddEventHandler("player:syncHoodOptions",function(vehIndex,options)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if options == "open" then
				SetVehicleDoorOpen(v,4,0,0)
			elseif options == "close" then
				SetVehicleDoorShut(v,4,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deleteVehicle")
AddEventHandler("player:deleteVehicle",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) and GetVehicleNumberPlateText(v) == vehPlate then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deleteObject")
AddEventHandler("player:deleteObject",function(entIndex)
	if NetworkDoesNetworkIdExist(entIndex) then
		local v = NetToEnt(entIndex)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORSOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoorsOptions")
AddEventHandler("player:syncDoorsOptions",function(vehIndex,options)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if options == "open" then
				SetVehicleDoorOpen(v,5,0,0)
			elseif options == "close" then
				SetVehicleDoorShut(v,5,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCWINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncWins")
AddEventHandler("player:syncWins",function(vehIndex,status)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if status == "1" then
				RollUpWindow(v,0)
				RollUpWindow(v,1)
				RollUpWindow(v,2)
				RollUpWindow(v,3)
			else
				RollDownWindow(v,0)
				RollDownWindow(v,1)
				RollDownWindow(v,2)
				RollDownWindow(v,3)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoors")
AddEventHandler("player:syncDoors",function(vehIndex,door)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) and GetVehicleDoorsLockedForPlayer(v,PlayerId()) ~= 1 then
			if door == "1" then
				if GetVehicleDoorAngleRatio(v,0) == 0 then
					SetVehicleDoorOpen(v,0,0,0)
				else
					SetVehicleDoorShut(v,0,0)
				end
			elseif door == "2" then
				if GetVehicleDoorAngleRatio(v,1) == 0 then
					SetVehicleDoorOpen(v,1,0,0)
				else
					SetVehicleDoorShut(v,1,0)
				end
			elseif door == "3" then
				if GetVehicleDoorAngleRatio(v,2) == 0 then
					SetVehicleDoorOpen(v,2,0,0)
				else
					SetVehicleDoorShut(v,2,0)
				end
			elseif door == "4" then
				if GetVehicleDoorAngleRatio(v,3) == 0 then
					SetVehicleDoorOpen(v,3,0,0)
				else
					SetVehicleDoorShut(v,3,0)
				end
			elseif door == "5" then
				if GetVehicleDoorAngleRatio(v,5) == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			elseif door == "6" then
				if GetVehicleDoorAngleRatio(v,4) == 0 then
					SetVehicleDoorOpen(v,4,0,0)
				else
					SetVehicleDoorShut(v,4,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fps",function(source,args)
	if args[1] == "on" then
		SetTimecycleModifier("cinema")
	else
		ClearTimecycleModifier()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:seatPlayer")
AddEventHandler("player:seatPlayer",function(vehIndex)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)

		if vehIndex == "0" then
			if IsVehicleSeatFree(vehicle,-1) then
				SetPedIntoVehicle(ped,vehicle,-1)
			end
		else
			if IsVehicleSeatFree(vehicle,parseInt(vehIndex - 1)) then
				SetPedIntoVehicle(ped,vehicle,parseInt(vehIndex - 1))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
local handcuff = false
function cRP.toggleHandcuff()
	if not handcuff then
		handcuff = true
		TriggerEvent("radio:outServers")
		exports["smartphone"]:closeSmartphone()
	else
		handcuff = false
		vRP.stopAnim(false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeHandcuff()
	if handcuff then
		handcuff = false
		vRP.stopAnim(false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getHandcuff()
	return handcuff
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function handcuffs()
	return handcuff
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
exports("handCuff",handcuffs)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetHandcuff")
AddEventHandler("resetHandcuff",function()
	if handcuff then
		handcuff = false
		vRP.stopAnim(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVEMENTCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.movementClip(dict)
	RequestAnimSet(dict)
	while not HasAnimSetLoaded(dict) do
		Wait(1)
	end

	SetPedMovementClipset(PlayerPedId(),dict,0.25)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if handcuff then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,21,true)
			DisableControlAction(1,55,true)
			DisableControlAction(1,102,true)
			DisableControlAction(1,179,true)
			DisableControlAction(1,203,true)
			DisableControlAction(1,76,true)
			DisableControlAction(1,23,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,243,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,263,true)
			DisablePlayerFiring(ped,true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYROPE
-----------------------------------------------------------------------------------------------------------------------------------------
local startRope = false
RegisterNetEvent("player:applyRope")
AddEventHandler("player:applyRope",function(status)
	startRope = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if handcuff and GetEntityHealth(ped) > 101 and not startRope then
			if not IsEntityPlayingAnim(ped,"mp_arresting","idle",3) then
				RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded("mp_arresting") do
					Wait(1)
				end

				TaskPlayAnim(ped,"mp_arresting","idle",3.0,3.0,-1,49,0,0,0,0)
				timeDistance = 1
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
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

local sandyShores = PolyZone:Create({
	vector2(-375.38,2910.14),
	vector2(307.66,3664.47),
	vector2(2329.64,4128.52),
	vector2(2349.93,4578.50),
	vector2(1680.57,4462.48),
	vector2(1570.01,4961.27),
	vector2(1967.55,5203.67),
	vector2(2387.14,5273.98),
	vector2(2735.26,4392.21),
	vector2(2512.33,3711.16),
	vector2(1681.79,3387.82),
	vector2(258.85,2920.16)
},{ name="sandy" })

local paletoBay = PolyZone:Create({
	vector2(-529.40,5755.14),
	vector2(-234.39,5978.46),
	vector2(278.16,6381.84),
	vector2(672.67,6434.39),
	vector2(699.56,6877.77),
	vector2(256.59,7058.49),
	vector2(17.64,7054.53),
	vector2(-489.45,6449.50),
	vector2(-717.59,6030.94)
},{ name="paleto" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local coolTimers = 0
local residual = false
local policeService = false
local sprayTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedArmed(ped,6) and GetGameTimer() >= sprayTimers then
			timeDistance = 1

			if IsPedShooting(ped) then
				sprayTimers = GetGameTimer() + 60000
				residual = true
				coolTimers = 3

				local coords = GetEntityCoords(ped)
				if (losSantos:isPointInside(coords) or sandyShores:isPointInside(coords) or paletoBay:isPointInside(coords)) and not policeService then
					TriggerServerEvent("evidence:dropEvidence","blue")
					vSERVER.shotsFired()
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDISABLECTRL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if coolTimers > 0 then
			timeDistance = 1
			DisableControlAction(1,36,true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if coolTimers > 0 then
			coolTimers = coolTimers - 1
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHAKESHOTTING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) and IsPedArmed(ped,6) then
			timeDistance = 1

			local selectWeapon = GetSelectedPedWeapon(ped)
			if (selectWeapon == GetHashKey("WEAPON_MACHINEPISTOL") or selectWeapon == GetHashKey("WEAPON_MICROSMG") or selectWeapon == GetHashKey("WEAPON_MINISMG") or selectWeapon == GetHashKey("WEAPON_APPISTOL")) then
				DisablePlayerFiring(ped,true)
				DisableControlAction(1,24,true)
				DisableControlAction(1,25,true)
				DisableControlAction(1,68,true)
				DisableControlAction(1,69,true)
				DisableControlAction(1,70,true)
				DisableControlAction(1,91,true)
				DisableControlAction(1,257,true)
			end

			if IsPedShooting(ped) then
				ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.10)
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:updateService")
AddEventHandler("police:updateService",function(status)
	policeService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYGSR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:applyGsr")
AddEventHandler("player:applyGsr",function()
	residual = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GSRCHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.gsrCheck()
	return residual
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSOAP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkSoap()
	local ped = PlayerPedId()
	if IsEntityInWater(ped) and residual then
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANRESIDUAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.cleanResidual()
	residual = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false
function cRP.toggleCarry(source)
	uCarry = source
	iCarry = not iCarry

	local ped = PlayerPedId()
	if iCarry and uCarry then
		AttachEntityToEntity(ped,GetPlayerPed(GetPlayerFromServerId(uCarry)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped,false,false)
			sCarry = false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeVehicle()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if iCarry then
			iCarry = false
			DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
		end

		TaskLeaveVehicle(ped,GetVehiclePedIsUsing(ped),4160)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.putVehicle(vehIndex)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			local vehSeats = 5
			local ped = PlayerPedId()

			repeat
				vehSeats = vehSeats - 1

				if IsVehicleSeatFree(v,vehSeats) then
					ClearPedTasks(ped)
					ClearPedSecondaryTask(ped)
					SetPedIntoVehicle(ped,v,vehSeats)

					if iCarry then
						iCarry = false
						DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
					end

					vehSeats = true
				end
			until vehSeats == true or vehSeats == 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrunk = false
local playerInvisible = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PLAYERINVISIBLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:playerInvisible")
AddEventHandler("player:playerInvisible",function(status)
	playerInvisible = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrunk")
AddEventHandler("player:enterTrunk",function(entity)
	if not inTrunk then
		local vehicle = entity[3]
		local vehPlate = entity[1]
		if GetVehicleDoorLockStatus(vehicle) == 1 then
			local trunk = GetEntityBoneIndexByName(vehicle,"boot")
			if trunk ~= -1 then
				if GetVehicleDoorAngleRatio(vehicle,5) < 0.9 then
					local ped = PlayerPedId()
					local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,0.0)
					local coordsEnt = GetWorldPositionOfEntityBone(vehicle,trunk)
					local distance = #(coords - coordsEnt)
					if distance <= 2.0 then
						playerInvisible = true
						blockCommands = true
						SetEntityVisible(ped,false,false)
						AttachEntityToEntity(ped,vehicle,-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
						inTrunk = true
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	if inTrunk then
		local ped = PlayerPedId()
		local vehicle = GetEntityAttachedTo(ped)
		if DoesEntityExist(vehicle) then
			inTrunk = false
			DetachEntity(ped,false,false)
			SetEntityVisible(ped,true,false)
			blockCommands = false
			playerInvisible = false
			SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.25,-0.25),1,0,0,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999

		if inTrunk then
			local ped = PlayerPedId()
			local vehicle = GetEntityAttachedTo(ped)
			if DoesEntityExist(vehicle) then
				timeDistance = 1

				DisablePlayerFiring(ped,true)

				if IsEntityVisible(ped) then
					playerInvisible = true
					SetEntityVisible(ped,false,false)
				end

				if IsControlJustPressed(1,38) then
					inTrunk = false
					DetachEntity(ped,false,false)
					SetEntityVisible(ped,true,false)
					blockCommands = false
					playerInvisible = false
					SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.25,-0.25),1,0,0,0)
				end
			else
				inTrunk = false
				DetachEntity(ped,false,false)
				SetEntityVisible(ped,true,false)
				blockCommands = false
				playerInvisible = false
				SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.25,-0.25),1,0,0,0)
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRUISER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cr",function(source,args)
	if exports["chat"]:statusChat() then
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local veh = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(veh,-1) == ped and not IsEntityInAir(veh) then
				local speed = GetEntitySpeed(veh) * 3.6

				if speed >= 10 then
					if args[1] == nil then
						SetEntityMaxSpeed(veh,GetVehicleEstimatedMaxSpeed(veh))
						TriggerEvent("Notify","amarelo","Controle de cruzeiro desativado.",3000)
					else
						if parseInt(args[1]) > 10 then
							SetEntityMaxSpeed(veh,0.28 * args[1])
							TriggerEvent("Notify","verde","Controle de cruzeiro ativado.",3000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(name,args)
	if name == "CEventNetworkEntityDamage" then
		if (GetEntityHealth(args[1]) <= 101 and PlayerPedId() == args[2] and IsPedAPlayer(args[1])) then
			local index = NetworkGetPlayerIndexFromPed(args[1])
			local source = GetPlayerServerId(index)
			TriggerServerEvent("player:deathLogs",source)
		end
	end
end)