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
Tunnel.bindInterface("circuits",cRP)
vSERVER = Tunnel.getInterface("circuits")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inLaps = 1
local inTimers = 0
local inSelected = 0
local inCheckpoint = 0
local inProgress = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKECIRCUITS
-----------------------------------------------------------------------------------------------------------------------------------------
local myCircuit = {}
local circuitInit = false
local makeCircuits = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local systemCircuits = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCIRCUITS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			if inProgress then
				timeDistance = 1

				dwText("~b~Checkpoints:~w~ "..inCheckpoint.." / "..#systemCircuits[inSelected]["coords"],0.65)
				dwText("~b~Total de Voltas:~w~ "..inLaps.." / "..systemCircuits[inSelected]["laps"],0.68)
				dwText("~b~Tempo Percorrido:~w~ "..inTimers,0.71)
				dwText("~b~Autor do Circuito:~w~ "..systemCircuits[inSelected]["author"],0.74)

				local distance = #(coords - vector3(systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2],systemCircuits[inSelected]["coords"][inCheckpoint][3]))
				if distance <= 200 then
					if inCheckpoint >= #systemCircuits[inSelected]["coords"] then
						if inLaps >= systemCircuits[inSelected]["laps"] then
							DrawMarker(4,systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2],systemCircuits[inSelected]["coords"][inCheckpoint][3] + 2,0,0,0,0,180.0,130.0,8.0,5.0,5.0,42,137,255,100,0,0,0,1)
						else
							DrawMarker(1,systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2],systemCircuits[inSelected]["coords"][inCheckpoint][3] - 1,0,0,0,0,0,0,25.0,25.0,8.0,255,255,255,25,0,0,0,0)
							DrawMarker(21,systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2],systemCircuits[inSelected]["coords"][inCheckpoint][3] + 2.5,0,0,0,0,180.0,130.0,8.0,5.0,5.0,42,137,255,100,0,0,0,1)
						end
					else
						DrawMarker(1,systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2],systemCircuits[inSelected]["coords"][inCheckpoint][3] - 1,0,0,0,0,0,0,25.0,25.0,8.0,255,255,255,25,0,0,0,0)
						DrawMarker(21,systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2],systemCircuits[inSelected]["coords"][inCheckpoint][3] + 2.5,0,0,0,0,180.0,130.0,8.0,5.0,5.0,42,137,255,100,0,0,0,1)
					end

					if distance <= 15 then
						if inCheckpoint >= #systemCircuits[inSelected]["coords"] then
							if inLaps >= systemCircuits[inSelected]["laps"] then
								PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
								inProgress = false
							else
								inCheckpoint = 1
								inLaps = inLaps + 1
								SetNewWaypoint(systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2])
							end
						else
							inCheckpoint = inCheckpoint + 1
							SetNewWaypoint(systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2])
						end
					end
				end
			else
				for k,v in pairs(systemCircuits) do
					local distance = #(coords - vector3(v["init"][1],v["init"][2],v["init"][3]))
					if distance <= 50 then
						timeDistance = 1
						DrawMarker(23,v["init"][1],v["init"][2],v["init"][3] + 0.25,0.0,0.0,0.0,0.0,0.0,0.0,10.0,10.0,0.0,42,137,255,100,0,0,0,0)

						if IsControlJustPressed(1,38) and distance <= 5 then
							inSelected = tostring(k)
							inProgress = true
							inCheckpoint = 1
							inTimers = 0
							inLaps = 1

							SetNewWaypoint(systemCircuits[inSelected]["coords"][inCheckpoint][1],systemCircuits[inSelected]["coords"][inCheckpoint][2])
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if inProgress then
			timeDistance = 1
			inTimers = inTimers + 1
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CIRCUITS:STARTMAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("circuits:makeCircuits")
AddEventHandler("circuits:makeCircuits",function(laps,name)
	myCircuit = {}
	myCircuit["laps"] = parseInt(laps)
	myCircuit["author"] = name
	myCircuit["coords"] = {}
	myCircuit["init"] = {}

	makeCircuits = true
	circuitInit = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CIRCUITS:STARTMAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("circuits:updateCircuits")
AddEventHandler("circuits:updateCircuits",function(status)
	systemCircuits = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v.x << 8) | v.y
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRHEADMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if makeCircuits then
			timeDistance = 1

			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)
				local grid = vector2(gridChunk(coords.x),gridChunk(coords.y))
				local _,cdz = GetGroundZFor_3dCoord(coords.x,coords.y,coords.z)

				if circuitInit then
					dwText("~b~N~w~   LOCAL DE INICIO DA CORRIDA",0.71)
				else
					dwText("~b~N~w~   MARCAR CHECKPOINT",0.71)
					dwText("~g~M~w~   FINALIZAR CORRIDA",0.74)
				end

				if IsControlJustPressed(1,306) then
					if circuitInit then
						circuitInit = false
						myCircuit["init"] = { coords.x,coords.y,cdz }
						TriggerEvent("Notify","verde","Inicio marcado.",3000)
					else
						table.insert(myCircuit["coords"],{ coords.x,coords.y,cdz })
						TriggerEvent("Notify","amarelo","Checkpoint marcado.",3000)
					end

					PlaySoundFrontend(-1,"Beep_Red","DLC_HEIST_HACKING_SNAKE_SOUNDS",false)
				elseif IsControlJustPressed(1,301) then
					if #myCircuit["coords"] > 0 then
						table.insert(myCircuit["coords"],{ coords.x,coords.y,cdz })
						PlaySoundFrontend(-1,"OOB_Cancel","GTAO_FM_Events_Soundset",false)
						TriggerEvent("Notify","verde","Circuito finalizado.",3000)
						vSERVER.inputRaces(myCircuit)
						makeCircuits = false
					else
						TriggerEvent("Notify","amarelo","É obrigatório ter no mínimo <b>1 Checkpoint</b>.",3000)
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.40,0.40)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.025,height)
end