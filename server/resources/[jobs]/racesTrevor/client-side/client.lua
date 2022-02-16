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
Tunnel.bindInterface("racesTrevor",cRP)
vSERVER = Tunnel.getInterface("racesTrevor")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Races = {}
local Selected = 1
local racePoint = 0
local savePoints = 0
local Checkpoint = 0
local CheckBlip = nil
local Progress = false
local ExplodeTimers = 0
local inativeRaces = false
local initRaces = { 1661.45,3239.0,40.61 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if not inativeRaces then
			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)
				local vehicle = GetVehiclePedIsUsing(ped)

				if Progress then
					timeDistance = 1
					racePoint = (GetGameTimer() - savePoints)

					SendNUIMessage({ checkpoint = Checkpoint, maxcheckpoint = #Races[Selected]["coords"], points = racePoint, explosive = ((ExplodeTimers - GetGameTimer()) / 1000) })

					local distance = #(coords - vector3(Races[Selected]["coords"][Checkpoint][1],Races[Selected]["coords"][Checkpoint][2],Races[Selected]["coords"][Checkpoint][3]))
					if distance <= 200 then
						DrawMarker(1,Races[Selected]["coords"][Checkpoint][1],Races[Selected]["coords"][Checkpoint][2],Races[Selected]["coords"][Checkpoint][3] - 3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
						DrawMarker(21,Races[Selected]["coords"][Checkpoint][1],Races[Selected]["coords"][Checkpoint][2],Races[Selected]["coords"][Checkpoint][3] + 1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,42,137,255,100,0,0,0,1)

						if distance <= 10 then
							if Checkpoint >= #Races[Selected]["coords"] then
								PlaySoundFrontend(-1,"CHECKPOINT_UNDER_THE_BRIDGE","HUD_MINI_GAME_SOUNDSET",false)
								SendNUIMessage({ show = false })
								vSERVER.finishRace(Selected)
								ExplodeTimers = 0
								Progress = false
								Checkpoint = 0
								savePoints = 0
								Selected = 0
								cleanBlips()
							else
								Checkpoint = Checkpoint + 1
								makeBlips()
							end
						end
					end

					if (GetPedInVehicleSeat(vehicle,-1) ~= ped or GetGameTimer() >= ExplodeTimers) and Progress then
						leaveRace()
					end
				else
					local distance = #(coords - vector3(initRaces[1],initRaces[2],initRaces[3]))
					if distance <= 100 then
						timeDistance = 1
						DrawMarker(23,initRaces[1],initRaces[2],initRaces[3] - 0.95,0.0,0.0,0.0,0.10,-0.50,0.0,25.0,25.0,0.0,42,137,255,100,0,0,0,0)

						if IsControlJustPressed(1,38) and distance <= 12.5 then
							if GetPedInVehicleSeat(vehicle,-1) == ped then
								local raceStatus,raceActual = vSERVER.checkTicket()
								if raceStatus then
									ExplodeTimers = GetGameTimer() + (Races[raceActual]["explode"] * 1000)
									SendNUIMessage({ show = true })
									savePoints = GetGameTimer()
									Selected = raceActual
									Progress = true
									Checkpoint = 1
									racePoint = 0

									makeBlips()
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

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATERACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateRaces(status)
	Races = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlips()
	if DoesBlipExist(CheckBlip) then
		RemoveBlip(CheckBlip)
		CheckBlip = nil
	end

	CheckBlip = AddBlipForCoord(Races[Selected]["coords"][Checkpoint][1],Races[Selected]["coords"][Checkpoint][2],Races[Selected]["coords"][Checkpoint][3])
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
	Checkpoint = 0
	Selected = 0
	cleanBlips()

	Citizen.Wait(3000)

	local vehicle = GetPlayersLastVehicle()
	local coords = GetEntityCoords(vehicle)
	AddExplosion(coords,2,1.0,true,true,true)

	vSERVER.exitRace()
	ExplodeTimers = 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACESTREVOR:DEFUSEBOMBS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("racesTrevor:defuseBombs")
AddEventHandler("racesTrevor:defuseBombs",function(status)
	SendNUIMessage({ show = false })
	vSERVER.exitRace()
	ExplodeTimers = 0
	Progress = false
	Checkpoint = 0
	Selected = 0
	cleanBlips()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACESTREVOR:INATIVERACES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:insertList")
AddEventHandler("races:insertList",function(status)
	inativeRaces = status
end)