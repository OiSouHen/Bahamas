-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("hud",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local voice = 2
local hardness = {}
local showHud = false
local talking = false
local clientStress = 0
local showMovie = false
local radioDisplay = ""
local pauseBreak = false
local clientHunger = 100
local clientThirst = 100
local homeInterior = false
local playerActive = false
local flexDirection = "Norte"
local updateFoods = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local beltLock = 0
local beltSpeed = 0
local beltVelocity = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIVINABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local divingMask = nil
local divingTank = nil
local clientOxigen = 100
local divingTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Mumble = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected",function()
	if not Mumble then
		SendNUIMessage({ mumble = false })
		Mumble = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected",function()
	if Mumble then
		SendNUIMessage({ mumble = true })
		Mumble = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:playerActive")
AddEventHandler("vrp:playerActive",function(user_id)
	playerActive = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if playerActive then
			if divingMask ~= nil then
				if GetGameTimer() >= divingTimers then
					divingTimers = GetGameTimer() + 30000
					clientOxigen = clientOxigen - 1
					vRPS.clientOxigen()

					if clientOxigen <= 0 then
						ApplyDamageToPed(PlayerPedId(),50,false)
					end
				end
			end
		end

		Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOODS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if playerActive then
			local ped = PlayerPedId()
			if GetGameTimer() >= updateFoods and GetEntityHealth(ped) > 101 then
				updateFoods = GetGameTimer() + 90000
				clientThirst = clientThirst - 1
				clientHunger = clientHunger - 1
				vRPS.clientFoods()
			end
		end

		Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOCKVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeDate = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if GetGameTimer() >= timeDate then
			timeDate = GetGameTimer() + 10000
			GlobalState["Minutes"] = GlobalState["Minutes"] + 1

			if GlobalState["Minutes"] >= 60 then
				GlobalState["Hours"] = GlobalState["Hours"] + 1
				GlobalState["Minutes"] = 0

				if GlobalState["Hours"] >= 24 then
					GlobalState["Hours"] = 0
				end
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if homeInterior then
			SetWeatherTypeNow("CLEAR")
			SetWeatherTypePersist("CLEAR")
			SetWeatherTypeNowPersist("CLEAR")
			NetworkOverrideClockTime(00,00,00)
		else
			SetWeatherTypeNow(GlobalState["Weather"])
			SetWeatherTypePersist(GlobalState["Weather"])
			SetWeatherTypeNowPersist(GlobalState["Weather"])
			NetworkOverrideClockTime(GlobalState["Hours"],GlobalState["Minutes"],00)
		end
		
		if beltLock >= 1 then
			DisableControlAction(1,75,true)
		end

		Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERTALKING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:userTalking",function(status)
	talking = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(progressTimer)
	SendNUIMessage({ progress = true, progressTimer = progressTimer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHUD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if playerActive then
			if IsPauseMenuActive() then
				SendNUIMessage({ hud = false })
				pauseBreak = true
			else
				if showHud then
					if pauseBreak then
						SendNUIMessage({ hud = true })
						pauseBreak = false
						updateDisplayHud()
					else
						updateDisplayHud()

						local ped = PlayerPedId()
						if IsPedInAnyVehicle(ped) then
							timeDistance = 500
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDISPLAYHUD
-----------------------------------------------------------------------------------------------------------------------------------------
function updateDisplayHud()
	local ped = PlayerPedId()
	local armour = GetPedArmour(ped)
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	local health = GetEntityHealth(ped) - 100
	local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords["x"],coords["y"],coords["z"]))

	if heading >= 315 or heading < 45 then
		flexDirection = "Norte"
	elseif heading >= 45 and heading < 135 then
		flexDirection = "Oeste"
	elseif heading >= 135 and heading < 225 then
		flexDirection = "Sul"
	elseif heading >= 225 and heading < 315 then
		flexDirection = "Leste"
	end

	if IsPedInAnyVehicle(ped) then
		if not IsMinimapRendering() then
			DisplayRadar(true)
		end

		local vehicle = GetVehiclePedIsUsing(ped)
		local fuel = GetVehicleFuelLevel(vehicle)
		local plate = GetVehicleNumberPlateText(vehicle)
		local speed = GetEntitySpeed(vehicle) * 3.6

		local showBelt = true
		if GetVehicleClass(vehicle) == 8 and (GetVehicleClass(vehicle) >= 13 and GetVehicleClass(vehicle) <= 16) and GetVehicleClass(vehicle) == 21 then
			showBelt = false
		end

		SendNUIMessage({ vehicle = true, talking = talking, health = health, armour = armour, thirst = clientThirst, hunger = clientHunger, stress = clientStress, street = streetName, direction = flexDirection, radio = radioDisplay, voice = voice, oxigen = clientOxigen, suit = divingMask, fuel = fuel, speed = speed, showbelt = showBelt, seatbelt = beltLock, hardness = (hardness[plate] or 0) })
	else
		if IsMinimapRendering() then
			DisplayRadar(false)
		end

		SendNUIMessage({ vehicle = false, talking = talking, health = health, armour = armour, thirst = clientThirst, hunger = clientHunger, stress = clientStress, street = streetName, direction = flexDirection, radio = radioDisplay, voice = voice, oxigen = clientOxigen, suit = divingMask })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function(source,args)
	if exports["chat"]:statusChat() then
		showHud = not showHud

		updateDisplayHud()
		SendNUIMessage({ hud = showHud })

		if IsMinimapRendering() and not showHud then
			DisplayRadar(false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("movie",function(source,args)
	if exports["chat"]:statusChat() then
		showMovie = not showMovie

		updateDisplayHud()
		SendNUIMessage({ movie = showMovie })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:TOGGLEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
	showHood = not showHood

	if showHood then
		SetPedComponentVariation(PlayerPedId(),1,69,0,1)
	else
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end

	SendNUIMessage({ hood = showHood })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HARDNESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:plateHardness")
AddEventHandler("hud:plateHardness",function(vehPlate,status)
	hardness[vehPlate] = parseInt(status)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ALLHARDNESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:allHardness")
AddEventHandler("hud:allHardness",function(vehHardness)
	hardness = vehHardness
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:removeHood")
AddEventHandler("hud:removeHood",function()
	if showHood then
		showHood = false
		SendNUIMessage({ hood = showHood })
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusHunger")
AddEventHandler("statusHunger",function(number)
	clientHunger = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSTHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusThirst")
AddEventHandler("statusThirst",function(number)
	clientThirst = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSSTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusStress")
AddEventHandler("statusStress",function(number)
	clientStress = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusOxigen")
AddEventHandler("statusOxigen",function(number)
	clientOxigen = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:rechargeOxigen")
AddEventHandler("hud:rechargeOxigen",function()
	TriggerEvent("Notify","verde","Reabastecimento concluído.",3000)
	vRPS.rechargeOxigen()
	clientOxigen = 100
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hudActived")
AddEventHandler("hudActived",function(status)
	showHud = status

	updateDisplayHud()

	SendNUIMessage({ hud = showHud })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode",function(status)
	voice = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIODISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RadioDisplay")
AddEventHandler("hud:RadioDisplay",function(number)
	if parseInt(number) <= 0 then
		radioDisplay = ""
	else
		radioDisplay = parseInt(number).."Mhz <s>:</s>"
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOWARDPED
-----------------------------------------------------------------------------------------------------------------------------------------
function fowardPed(ped)
	local heading = GetEntityHeading(ped) + 90.0
	if heading < 0.0 then
		heading = 360.0 + heading
	end

	heading = heading * 0.0174533

	return { x = math.cos(heading) * 2.0, y = math.sin(heading) * 2.0 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBELT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if playerActive then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				if not IsPedOnAnyBike(ped) and not IsPedInAnyHeli(ped) and not IsPedInAnyPlane(ped) then
					timeDistance = 1

					local vehicle = GetVehiclePedIsUsing(ped)
					local speed = GetEntitySpeed(vehicle) * 3.6
					if speed ~= beltSpeed then
						local plate = GetVehicleNumberPlateText(vehicle)

						if ((beltSpeed - speed) >= 50 and beltLock == 0) or ((beltSpeed - speed) >= 75 and beltLock == 1 and hardness[plate] == nil and GetPedInVehicleSeat(vehicle,-1) == ped) then
							local fowardVeh = fowardPed(ped)
							local coords = GetEntityCoords(ped)
							SetEntityCoords(ped,coords["x"] + fowardVeh["x"],coords["y"] + fowardVeh["y"],coords["z"] + 1,1,0,0,0)
							SetEntityVelocity(ped,beltVelocity["x"],beltVelocity["y"],beltVelocity["z"])
							ApplyDamageToPed(ped,50,false)

							Wait(1)

							SetPedToRagdoll(ped,5000,5000,0,0,0,0)
						end

						beltVelocity = GetEntityVelocity(vehicle)
						beltSpeed = speed
					end
				end
			else
				if beltSpeed ~= 0 then
					beltSpeed = 0
				end

				if beltLock == 1 then
					beltLock = 0
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seatbelt",function(source,args)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if not IsPedOnAnyBike(ped) then
			if beltLock == 1 then
				TriggerEvent("sounds:source","unbelt",0.5)
				beltLock = 0
			else
				TriggerEvent("sounds:source","belt",0.5)
				beltLock = 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("seatbelt","Colocar/Retirar o cinto.","keyboard","g")
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SYNCTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:syncTimers")
AddEventHandler("hud:syncTimers",function(timer)
	GlobalState["Hours"] = parseInt(timer[1])
	GlobalState["Minutes"] = parseInt(timer[2])
	GlobalState["Weather"] = timer[3]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:HOURS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:Hours")
AddEventHandler("homes:Hours",function(status)
	homeInterior = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHREDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local foodTimers = GetGameTimer()

	while true do
		if playerActive then
			if GetGameTimer() >= foodTimers then
				foodTimers = GetGameTimer() + 10000

				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)
				if health > 101 then
					if clientHunger >= 10 and clientHunger <= 20 then
						SetEntityHealth(ped,health - 1)
						TriggerEvent("Notify","hunger","Sofrendo com a fome.",3000)
					elseif clientHunger <= 9 then
						SetEntityHealth(ped,health - 2)
						TriggerEvent("Notify","hunger","Sofrendo com a fome.",3000)
					end

					if clientThirst >= 10 and clientThirst <= 20 then
						SetEntityHealth(ped,health - 1)
						TriggerEvent("Notify","thirst","Sofrendo com a sede.",3000)
					elseif clientThirst <= 9 then
						SetEntityHealth(ped,health - 2)
						TriggerEvent("Notify","thirst","Sofrendo com a sede.",3000)
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHAKESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if playerActive then
			local ped = PlayerPedId()
			local health = GetEntityHealth(ped)

			if health > 101 then
				if clientStress >= 99 then
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.75)
				elseif clientStress >= 80 and clientStress <= 98 then
					timeDistance = 9990
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.50)
				elseif clientStress >= 60 and clientStress <= 79 then
					timeDistance = 7500
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.25)
				elseif clientStress >= 40 and clientStress <= 59 then
					timeDistance = 9990
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVESCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:removeScuba")
AddEventHandler("hud:removeScuba",function()
	local ped = PlayerPedId()
	if DoesEntityExist(divingMask) or DoesEntityExist(divingTank) then
		if DoesEntityExist(divingMask) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingMask))
			divingMask = nil
		end

		if DoesEntityExist(divingTank) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingTank))
			divingTank = nil
		end

		SetEnableScuba(ped,false)
		SetPedMaxTimeUnderwater(ped,10.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SETDIVING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:setDiving")
AddEventHandler("hud:setDiving",function()
	local ped = PlayerPedId()

	if DoesEntityExist(divingMask) or DoesEntityExist(divingTank) then
		if DoesEntityExist(divingMask) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingMask))
			divingMask = nil
		end

		if DoesEntityExist(divingTank) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingTank))
			divingTank = nil
		end

		SetEnableScuba(ped,false)
		SetPedMaxTimeUnderwater(ped,10.0)
	else
		local maskModel = GetHashKey("p_s_scuba_mask_s")
		local tankModel = GetHashKey("p_s_scuba_tank_s")

		RequestModel(tankModel)
		while not HasModelLoaded(tankModel) do
			Wait(1)
		end

		RequestModel(maskModel)
		while not HasModelLoaded(maskModel) do
			Wait(1)
		end

		if HasModelLoaded(tankModel) then
			divingTank = CreateObject(tankModel,1.0,1.0,1.0,true,true,false)
			AttachEntityToEntity(divingTank,ped,GetPedBoneIndex(ped,24818),-0.28,-0.24,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
			SetEntityAsMissionEntity(divingTank,true,true)
			SetModelAsNoLongerNeeded(divingTank)
		end

		if HasModelLoaded(maskModel) then
			divingMask = CreateObject(maskModel,1.0,1.0,1.0,true,true,false)
			AttachEntityToEntity(divingMask,ped,GetPedBoneIndex(ped,12844),0.0,0.0,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
			SetEntityAsMissionEntity(divingMask,true,true)
			SetModelAsNoLongerNeeded(divingMask)
		end

		SetEnableScuba(ped,true)
		SetPedMaxTimeUnderwater(ped,2000.0)
	end
end)