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
Tunnel.bindInterface("works",cRP)
vSERVER = Tunnel.getInterface("works")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local works = {}
local inCollect = 1
local inSeconds = 0
local inDelivery = 1
local inService = false
local blipCollect = nil
local blipDelivery = nil
local lastService = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(works) do
				local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
				if distance <= 2 then
					timeDistance = 1

					if not inService then
						DrawText3D(v["coords"][1],v["coords"][2],v["coords"][3],"~g~E~w~   "..string.upper(k))
					else
						DrawText3D(v["coords"][1],v["coords"][2],v["coords"][3],"~g~E~w~   FINALIZAR")
					end

					if IsControlJustPressed(1,38) and inSeconds <= 0 then
						inSeconds = 3

						if not inService then
							if vSERVER.checkPermission(k) then
								inService = k

								if v["deliveryCoords"] ~= nil then
									if lastService ~= k then
										if v["routeDelivery"] then
											inCollect = 1
										else
											inDelivery = math.random(#works[k]["deliveryCoords"])
										end
									end

									makeDeliveryMarked(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3])
								end

								if v["collectCoords"] ~= nil then
									if lastService ~= k then
										if v["routeCollect"] then
											inCollect = 1
										else
											inCollect = math.random(#works[k]["collectCoords"])
										end
									end

									makeCollectMarked(v["collectCoords"][inCollect][1],v["collectCoords"][inCollect][2],v["collectCoords"][inCollect][3])
								end

								TriggerEvent("Notify","amarelo","Serviço de <b>"..k.."</b> foi iniciado.",5000)
							end
						else
							if inService == k then
								lastService = k
								inService = false
								vSERVER.finishService(k)
								TriggerEvent("Notify","amarelo","Serviço de <b>"..k.."</b> foi finalizado.",5000)

								if DoesBlipExist(blipCollect) then
									RemoveBlip(blipCollect)
									blipCollect = nil
								end

								if DoesBlipExist(blipDelivery) then
									RemoveBlip(blipDelivery)
									blipDelivery = nil
								end
							else
								TriggerEvent("Notify","amarelo","Dirija-se até o emprego de <b>"..inService.."</b> e finalize o mesmo.",5000)
							end
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD CONTENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if inService then
			local ped = PlayerPedId()
			if (works[inService]["usingVehicle"] and IsPedInAnyVehicle(ped)) or (not works[inService]["usingVehicle"] and not IsPedInAnyVehicle(ped)) then
				local coords = GetEntityCoords(ped)

				if works[inService]["collectCoords"] ~= nil then
					local distance = #(coords - vector3(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3]))
					if distance <= works[inService]["collectShowDistance"] then
						timeDistance = 1

						if works[inService]["routeCollect"] then
							DrawText3D(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3],"~g~E~w~   CONTINUAR")
						else
							DrawText3D(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3],"~g~E~w~   COLETAR")
						end

						if distance <= works[inService]["collectButtonDistance"] and inSeconds <= 0 and IsControlJustPressed(1,38) then
							inSeconds = 3

							if works[inService]["collectAnim"] ~= nil then
								TriggerEvent("cancelando",true)
								TriggerEvent("player:blockCommands",true)
								TriggerEvent("Progress",works[inService]["collectDuration"] + 500)
								SetEntityHeading(ped,works[inService]["collectCoords"][inCollect][4])
								SetEntityCoords(ped,works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3] - 1,1,0,0,0)
								vRP.playAnim(works[inService]["collectAnim"][1],{works[inService]["collectAnim"][2],works[inService]["collectAnim"][3]},works[inService]["collectAnim"][4])

								Wait(works[inService]["collectDuration"])

								TriggerEvent("player:blockCommands",false)
								TriggerEvent("cancelando",false)
								vRP.removeObjects()
							end

							if works[inService]["routeCollect"] then
								if works[inService]["collectVehicle"] ~= nil then
									if GetEntityModel(GetPlayersLastVehicle()) == works[inService]["collectVehicle"] then
										if vSERVER.collectConsume(inService) then
											if inCollect >= #works[inService]["collectCoords"] then
												inCollect = 1
											else
												inCollect = inCollect + 1
											end

											makeCollectMarked(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3])
										end
									else
										TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>"..inService.."</b>.",3000)
									end
								else
									if vSERVER.collectConsume(inService) then
										if inCollect >= #works[inService]["collectCoords"] then
											inCollect = 1
										else
											inCollect = inCollect + 1
										end

										makeCollectMarked(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3])
									end
								end
							else
								if works[inService]["collectVehicle"] ~= nil then
									if GetEntityModel(GetPlayersLastVehicle()) == works[inService]["collectVehicle"] then
										if vSERVER.collectConsume(inService) then
											inCollect = math.random(#works[inService]["collectCoords"])
											makeCollectMarked(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3])
										end
									else
										TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>"..inService.."</b>.",3000)
									end
								else
									if vSERVER.collectConsume(inService) then
										inCollect = math.random(#works[inService]["collectCoords"])

										makeCollectMarked(works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3])
									end
								end
							end
						end
					end
				end

				if works[inService]["deliveryCoords"] ~= nil then
					local distance = #(coords - vector3(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3]))
					if distance <= 30 then
						timeDistance = 1

						if works[inService]["routeDelivery"] then
							DrawText3D(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3],"~g~E~w~   CONTINUAR")
						else
							DrawText3D(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3],"~g~E~w~   COLETAR")
						end

						if distance <= 1 and inSeconds <= 0 and IsControlJustPressed(1,38) then
							inSeconds = 3

							if works[inService]["routeDelivery"] then
								if works[inService]["deliveryVehicle"] ~= nil then
									if GetEntityModel(GetPlayersLastVehicle()) == works[inService]["deliveryVehicle"] then
										if vSERVER.deliveryConsume(inService) then
											if inDelivery >= #works[inService]["deliveryCoords"] then
												inDelivery = 1
											else
												inDelivery = inDelivery + 1
											end

											makeDeliveryMarked(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3])
										end
									else
										TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>"..inService.."</b>.",3000)
									end
								else
									if vSERVER.deliveryConsume(inService) then
										if inDelivery >= #works[inService]["deliveryCoords"] then
											inDelivery = 1
										else
											inDelivery = inDelivery + 1
										end

										makeDeliveryMarked(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3])
									end
								end
							else
								if works[inService]["deliveryVehicle"] ~= nil then
									if GetEntityModel(GetPlayersLastVehicle()) == works[inService]["deliveryVehicle"] then
										if vSERVER.deliveryConsume(inService) then
											inDelivery = math.random(#works[inService]["deliveryCoords"])
											makeDeliveryMarked(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3])
										end
									else
										TriggerEvent("Notify","amarelo","Precisa utilizar o veículo do <b>"..inService.."</b>.",3000)
									end
								else
									if vSERVER.deliveryConsume(inService) then
										inDelivery = math.random(#works[inService]["deliveryCoords"])
										makeDeliveryMarked(works[inService]["deliveryCoords"][inDelivery][1],works[inService]["deliveryCoords"][inDelivery][2],works[inService]["deliveryCoords"][inDelivery][3])
									end
								end
							end
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if inSeconds > 0 then
			inSeconds = inSeconds - 1
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateWorks(status)
	works = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKECOLLECTMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function makeCollectMarked(x,y,z)
	if DoesBlipExist(blipCollect) then
		RemoveBlip(blipCollect)
		blipCollect = nil
	end

	if inService then
		blipCollect = AddBlipForCoord(x,y,z)
		SetBlipSprite(blipCollect,12)
		SetBlipColour(blipCollect,2)
		SetBlipScale(blipCollect,0.9)
		SetBlipRoute(blipCollect,true)
		SetBlipAsShortRange(blipCollect,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Coletar")
		EndTextCommandSetBlipName(blipCollect)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEDELIVERYMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function makeDeliveryMarked(x,y,z)
	if DoesBlipExist(blipDelivery) then
		RemoveBlip(blipDelivery)
		blipDelivery = nil
	end

	if inService then
		blipDelivery = AddBlipForCoord(x,y,z)
		SetBlipSprite(blipDelivery,12)
		SetBlipColour(blipDelivery,5)
		SetBlipScale(blipDelivery,0.9)
		SetBlipRoute(blipDelivery,true)
		SetBlipAsShortRange(blipDelivery,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Entregar")
		EndTextCommandSetBlipName(blipDelivery)
	end
end