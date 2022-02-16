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
Tunnel.bindInterface("luckywheel",cRP)
vSERVER = Tunnel.getInterface("luckywheel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local spawAtm = nil
local luckyWheel = nil
local spawnVehicle = nil
local enterCasino = false
local wheelActived = false
local wheelPosition = { 1111.05,229.85,-49.64 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYROLL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:myRoll")
AddEventHandler("luckywheel:myRoll", function()
	if enterCasino then
		wheelActived = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCASINO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(1107.92,218.34,-49.44))
			if distance <= 25 then
				if not enterCasino then
					enterCasino = true

					local vehHash = GetHashKey("skyliner34")
					local atmHash = GetHashKey("prop_atm_01")
					local luckyHash = GetHashKey("vw_prop_vw_luckywheel_02a")

					RequestModel(vehHash)
					while not HasModelLoaded(vehHash) do
						Citizen.Wait(10)
					end

					RequestModel(atmHash)
					while not HasModelLoaded(atmHash) do
						Citizen.Wait(10)
					end

					RequestModel(luckyHash)
					while not HasModelLoaded(luckyHash) do
						Citizen.Wait(10)
					end

					luckyWheel = CreateObject(luckyHash,wheelPosition[1],wheelPosition[2],wheelPosition[3] - 0.75,false,false,false)
					SetEntityHeading(luckyWheel,0.0)
					SetModelAsNoLongerNeeded(luckyHash)

					spawAtm = CreateObject(atmHash,1099.61,206.59,-50.45,0.0,false,false,false)
					SetEntityHeading(spawAtm,161.50)
					SetModelAsNoLongerNeeded(atmHash)

					spawnVehicle = CreateVehicle(vehHash,1100.04,219.87,-47.75,200.0,false,false)
					SetVehicleNumberPlateText(spawnVehicle,"CASSINOO")
					SetVehicleOnGroundProperly(spawnVehicle)
					FreezeEntityPosition(spawnVehicle,true)
					SetEntityInvincible(spawnVehicle,true)
					SetVehicleDoorsLocked(spawnVehicle,2)
					SetVehicleColours(spawnVehicle,29,1)
				end
			else
				if enterCasino then
					DeleteEntity(luckyWheel)
					luckyWheel = nil

					DeleteEntity(spawnVehicle)
					spawnVehicle = nil

					DeleteEntity(spawAtm)
					spawAtm = nil

					enterCasino = false
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROLL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:startRoll")
AddEventHandler("luckywheel:startRoll",function(wheelResult)
	if enterCasino then
		if DoesEntityExist(luckyWheel) then
			SetEntityRotation(luckyWheel,0.0,0.0,0.0,1,true)
		end

		local rollingRatio = 1
		local rollingSpeed = 1.0
		local rollingAngle = (wheelResult - 1) * 18
		local wheelAngles = rollingAngle + (360 * 8)
		local middleResult = (wheelAngles / 2)

		repeat
			Citizen.Wait(0)

			local xRot = GetEntityRotation(luckyWheel,1)
			if wheelAngles > middleResult then
				rollingRatio = rollingRatio + 1
			else
				rollingRatio = rollingRatio - 1
			end

			rollingSpeed = rollingRatio / 200
			local yRot = xRot["y"] - rollingSpeed
			wheelAngles = wheelAngles - rollingSpeed
			SetEntityRotation(luckyWheel,0.0,yRot,0.0,1,true)
		until rollingRatio <= 0

		if wheelActived then
			TriggerServerEvent("luckywheel:paymentWheel")
			wheelActived = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETROLL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:targetRoll")
AddEventHandler("luckywheel:targetRoll", function()
	if enterCasino then
		if vSERVER.checkRolling() then
			local ped = PlayerPedId()
			local aHash = "anim_casino_a@amb@casino@games@lucky7wheel@female"
			RequestAnimDict(aHash)
			while not HasAnimDictLoaded(aHash) do
				Citizen.Wait(1)
			end

			local inMoviment = true
			local movePosition = vector3(1110.1,229.06,-49.64)
			TaskGoStraightToCoord(ped,movePosition["x"],movePosition["y"],movePosition["z"],1.0,-1,0.0,0.0)

			while inMoviment do
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)

				if coords["x"] >= (movePosition["x"] - 0.01) and coords["x"] <= (movePosition["x"] + 0.01) and coords["y"] >= (movePosition["y"] - 0.01) and coords["y"] <= (movePosition["y"] + 0.01) then
					inMoviment = false
				end

				Citizen.Wait(0)
			end

			SetEntityHeading(ped,35.0)
			TriggerServerEvent("luckywheel:startRolling")
			TaskPlayAnim(ped,aHash,"armraisedidle_to_spinningidle_high",8.0,-8.0,-1,0,0,false,false,false)

			Citizen.Wait(2000)

			ClearPedTasks(ped)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999

		if enterCasino and spawnVehicle ~= nil then
			local vehHeading = GetEntityHeading(spawnVehicle)
			SetEntityHeading(spawnVehicle,vehHeading - 0.1)
			timeDistance = 5
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(resource)
	if resource == GetCurrentResourceName() then
		DeleteEntity(spawnVehicle)
		DeleteEntity(luckyWheel)
		DeleteEntity(spawAtm)
	end
end)