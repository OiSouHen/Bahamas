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
Tunnel.bindInterface("races",cRP)
vSERVER = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Laps = 1
local Races = {}
local Selected = 0
local savePoints = 0
local racePoints = 0
local Checkpoints = 0
local CheckBlip = nil
local Progress = false
local ExplodeTimers = 0
local ExplodeRace = false
local inativeRaces = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local waitPacket = 500
		if not inativeRaces then
			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)
				local veh = GetVehiclePedIsUsing(ped)

				if Progress then
					waitPacket = 4
					racePoints = (GetGameTimer() - savePoints)

					SendNUIMessage({ laps = Laps, maxlaps = Races[Selected]["laps"], checkpoint = Checkpoints, maxcheckpoint = #Races[Selected]["coords"], points = racePoints, explosive = ((ExplodeTimers - GetGameTimer()) / 1000) })

					if GetPedInVehicleSeat(veh,-1) ~= ped then
						leaveRace()
					end

					local distance = #(coords - vector3(Races[Selected]["coords"][Checkpoints][1],Races[Selected]["coords"][Checkpoints][2],Races[Selected]["coords"][Checkpoints][3]))
					if distance <= 200 then
						DrawMarker(1,Races[Selected]["coords"][Checkpoints][1],Races[Selected]["coords"][Checkpoints][2],Races[Selected]["coords"][Checkpoints][3] - 3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
						DrawMarker(21,Races[Selected]["coords"][Checkpoints][1],Races[Selected]["coords"][Checkpoints][2],Races[Selected]["coords"][Checkpoints][3] + 1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,42,137,255,100,0,0,0,1)

						if distance <= 10 then
							if Checkpoints >= #Races[Selected]["coords"] then
								if Laps >= Races[Selected]["laps"] then
									PlaySoundFrontend(-1,"CHECKPOINT_UNDER_THE_BRIDGE","HUD_MINI_GAME_SOUNDSET",false)
									vSERVER.finishRace(Selected,racePoints,vRP.vehicleName())
									SendNUIMessage({ show = false })
									ExplodeRace = false
									ExplodeTimers = 0
									Progress = false
									Checkpoints = 0
									savePoints = 0
									Selected = 0
									cleanBlips()
									Laps = 1
								else
									Laps = Laps + 1
									Checkpoints = 1
									makeBlips()
								end
							else
								Checkpoints = Checkpoints + 1
								makeBlips()
							end
						end
					end
				else
					for k,v in pairs(Races) do
						local distance = #(coords - vector3(v["init"][1],v["init"][2],v["init"][3]))
						if distance <= 50 then
							waitPacket = 4
							DrawMarker(23,v["init"][1],v["init"][2],v["init"][3] - 0.36,0.0,0.0,0.0,0.0,0.0,0.0,10.0,10.0,0.0,42,137,255,100,0,0,0,0)

							if IsControlJustPressed(1,38) and distance <= 5 then
								if GetPedInVehicleSeat(veh,-1) == ped then
									local raceStatus,raceExplosive = vSERVER.checkTicket(k)
									if raceStatus then
										SendNUIMessage({ show = true })
										savePoints = GetGameTimer()
										Selected = parseInt(k)
										Checkpoints = 1
										racePoints = 0
										Laps = 1

										makeBlips()

										if raceExplosive ~= nil then
											ExplodeTimers = GetGameTimer() + (v["explode"] * 1000)
											ExplodeRace = true
										end

										Progress = true
									end
								end
							end
						end
					end
				end
			else
				if Progress then
					leaveRace()
				end
			end
		end

		Wait(waitPacket)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if ExplodeRace then
			if GetGameTimer() >= ExplodeTimers then
				leaveRace()
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATERACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateRaces(status)
	Races = status

	for _,v in pairs(Races) do
		local blip = AddBlipForRadius(v["init"][1],v["init"][2],v["init"][3],10.0)
		SetBlipAlpha(blip,200)
		SetBlipColour(blip,59)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlips()
	if DoesBlipExist(CheckBlip) then
		RemoveBlip(CheckBlip)
		CheckBlip = nil
	end

	CheckBlip = AddBlipForCoord(Races[Selected]["coords"][Checkpoints][1],Races[Selected]["coords"][Checkpoints][2],Races[Selected]["coords"][Checkpoints][3])
	SetBlipSprite(CheckBlip,1)
	SetBlipAsShortRange(CheckBlip,true)
	SetBlipScale(CheckBlip,0.5)
	SetBlipColour(CheckBlip,3)
	SetBlipRoute(CheckBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Checkpoint")
	EndTextCommandSetBlipName(CheckBlip)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function cleanBlips()
	if DoesBlipExist(CheckBlip) then
		RemoveBlip(CheckBlip)
		CheckBlip = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVERACE
-----------------------------------------------------------------------------------------------------------------------------------------
function leaveRace()
	SendNUIMessage({ show = false })
	Progress = false
	Checkpoints = 0
	Selected = 0
	cleanBlips()
	Laps = 1

	if ExplodeRace then
		Wait(3000)

		local vehicle = GetPlayersLastVehicle()
		local coords = GetEntityCoords(vehicle)
		AddExplosion(coords,2,1.0,true,true,true)

		ExplodeRace = false
		vSERVER.exitRace()
		ExplodeTimers = 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:DEFUSEBOMB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:defuseBombs")
AddEventHandler("races:defuseBombs",function(status)
	SendNUIMessage({ show = false })
	ExplodeRace = false
	vSERVER.exitRace()
	ExplodeTimers = 0
	Progress = false
	Checkpoints = 0
	Selected = 0
	cleanBlips()
	Laps = 1
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:INATIVERACES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:insertList")
AddEventHandler("races:insertList",function(status)
	inativeRaces = status
end)