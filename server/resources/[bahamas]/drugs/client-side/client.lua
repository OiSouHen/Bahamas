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
Tunnel.bindInterface("drugs",cRP)
vSERVER = Tunnel.getInterface("drugs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local hasList = {}
local hasTimer = 0
local hasStart = false
local cdsStart = { -1196.55,-916.04,13.35 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if hasStart then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 then
				local coords = GetEntityCoords(ped)
				local _,hasPed = FindFirstPed()

				repeat
					if DoesEntityExist(hasPed) then
						if not IsPedDeadOrDying(hasPed) and GetPedArmour(hasPed) <= 0 and not IsPedAPlayer(hasPed) and not IsPedInAnyVehicle(hasPed) and GetPedType(hasPed) ~= 28 then
							local hasCoords = GetEntityCoords(hasPed)
							local distance = #(coords - hasCoords)

							if distance <= 1.5 and not hasList[PedToNet(hasPed)] then
								timeDistance = 1
								DrawText3D(hasCoords["x"],hasCoords["y"],hasCoords["z"],"~g~E~w~  OFERECER")

								if IsControlJustPressed(1,38) and vSERVER.checkAmount() then
									if math.random(100) <= 90 then
										SetEntityAsMissionEntity(hasPed,true,true)

										while not NetworkHasControlOfEntity(hasPed) and DoesEntityExist(hasPed) do
											NetworkRequestControlOfEntity(hasPed)
											Wait(100)
										end

										PlayAmbientSpeech1(hasPed,"GENERIC_HI","SPEECH_PARAMS_STANDARD")
										vSERVER.insertPedlist(PedToNet(hasPed),false,true)
										TaskSetBlockingOfNonTemporaryEvents(hasPed,true)
										SetBlockingOfNonTemporaryEvents(hasPed,true)
										SetPedDropsWeaponsWhenDead(hasPed,false)
										TaskTurnPedToFaceEntity(hasPed,ped,3.0)
										SetPedSuffersCriticalHits(hasPed,false)
										SetPedAsNoLongerNeeded(hasPed)
										hasTimer = 15

										while hasTimer >= 0 do
											if not IsPedDeadOrDying(hasPed) and GetEntityHealth(ped) > 101 then
												local coords = GetEntityCoords(ped)
												local hasCoords = GetEntityCoords(hasPed)
												local distance = #(coords - hasCoords)
												if distance <= 2.5 then
													DrawText3D(hasCoords["x"],hasCoords["y"],hasCoords["z"],"~w~AGUARDE  ~g~"..hasTimer.."~w~  SEGUNDOS")

													if hasTimer <= 0 then
														PlayAmbientSpeech1(hasPed,"GENERIC_THANKS","SPEECH_PARAMS_STANDARD")
														TaskWanderStandard(hasPed,10.0,10)
														vSERVER.paymentMethod()
														hasTimer = -1
														break
													end
												else
													PlayAmbientSpeech1(hasPed,"GENERIC_NO","SPEECH_PARAMS_STANDARD")
													TaskWanderStandard(hasPed,10.0,10)
													hasTimer = -1
													break
												end
											else
												hasTimer = -1
												break
											end

											Wait(1)
										end
									else
										PlayAmbientSpeech1(hasPed,"GENERIC_NO","SPEECH_PARAMS_STANDARD")
										vSERVER.insertPedlist(PedToNet(hasPed),true,true)
										TaskWanderStandard(hasPed,10.0,10)
										TaskReactAndFleePed(hasPed,ped)
										SetPedKeepTask(hasPed,true)

										if math.random(100) >= 90 then
											Wait(1000)

											GiveWeaponToPed(hasPed,GetHashKey("WEAPON_MICROSMG"),250,true,true)
											TaskShootAtEntity(hasPed,ped,25000,GetHashKey("FIRING_PATTERN_FULL_AUTO"))

											SetTimeout(25000,function()
												ClearPedTasks(hasPed)
												TaskWanderStandard(hasPed,10.0,10)
												TaskReactAndFleePed(hasPed,ped)
												SetPedKeepTask(hasPed,true)
											end)
										end
									end
								end
							end
						end
					end

					searching,hasPed = FindNextPed(_)
				until not searching EndFindPed(_)
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUGS:TOGGLESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drugs:toggleService")
AddEventHandler("drugs:toggleService",function()
	if vSERVER.checkPermission() then
		if hasStart then
			hasStart = false
			TriggerEvent("Notify","amarelo","Vendas finalizadas.",5000)
		else
			hasStart = true
			TriggerEvent("Notify","verde","Vendas ativadas.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUGS:INSERTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drugs:insertList")
AddEventHandler("drugs:insertList",function(pedId)
	hasList[pedId] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUGS:UPDATELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drugs:updateList")
AddEventHandler("drugs:updateList",function(pedTable)
	hasList = pedTable
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUGS:CLEARLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drugs:clearList")
AddEventHandler("drugs:clearList",function()
	hasList = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if hasTimer > 0 then
			hasTimer = hasTimer - 1
		end

		Wait(1000)
	end
end)
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
-- THREADACTIONROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local actionRobbery = false
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()

		if not actionRobbery then
			if not IsPedInAnyVehicle(ped) and IsPedArmed(ped,6) then
				local aim,target = GetEntityPlayerIsFreeAimingAt(PlayerId())

				if aim and not IsPedAPlayer(target) and GetPedArmour(target) <= 0 and GetPedType(target) ~= 28 then
					if IsPedInAnyVehicle(target) then
						timeDistance = 1

						local coords = GetEntityCoords(ped)
						local vehicle = GetVehiclePedIsUsing(target)
						local speed = GetEntitySpeed(vehicle) * 2.236936
						local plate = GetVehicleNumberPlateText(vehicle)
						local distance = #(coords - GetEntityCoords(vehicle))
						local modelName = vRP.vehicleModel(GetEntityModel(vehicle))

						if distance <= 10 and IsPedFacingPed(target,ped,180.0) and speed <= 5 and not hasList[PedToNet(target)] then
							actionRobbery = true

							SetVehicleForwardSpeed(vehicle,0)
							TaskLeaveVehicle(target,vehicle,256)
							SetEntityAsMissionEntity(target,true,true)

							while IsPedInAnyVehicle(target) do
								Wait(1)
							end

							Wait(250)

							while not NetworkHasControlOfEntity(target) and DoesEntityExist(target) do
								NetworkRequestControlOfEntity(target)
								Wait(100)
							end

							TaskSetBlockingOfNonTemporaryEvents(target,true)
							SetBlockingOfNonTemporaryEvents(target,true)
							SetPedDropsWeaponsWhenDead(target,false)
							TaskTurnPedToFaceEntity(target,ped,3.0)
							SetPedSuffersCriticalHits(target,false)
							SetPedAsNoLongerNeeded(target)
							ClearPedTasks(target)

							RequestAnimDict("random@arrests@busted")
							while not HasAnimDictLoaded("random@arrests@busted") do
								Wait(1)
							end

							TaskPlayAnim(target,"random@arrests@busted","idle_a",3.0,3.0,-1,49,0,0,0,0)

							local timeAim = 0
							while IsPlayerFreeAiming(PlayerId()) do
								timeAim = timeAim + 1

								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local distance = #(coords - GetEntityCoords(target))
								if timeAim >= 1000 or IsEntityDead(target) or distance > 10 then
									break
								end

								Wait(1)
							end

							if timeAim >= 1000 then
								RequestAnimDict("mp_common")
								while not HasAnimDictLoaded("mp_common") do
									Wait(1)
								end

								TaskPlayAnim(target,"mp_common","givetake1_a",3.0,3.0,-1,48,0,0,0,0)
								TriggerServerEvent("plateRobberys",plate,modelName)
							end

							ClearPedTasks(target)
							TaskWanderStandard(target,10.0,10)
							TaskReactAndFleePed(target,ped)
							SetPedKeepTask(target,true)

							if math.random(100) >= 75 then
								Wait(1000)

								GiveWeaponToPed(target,GetHashKey("WEAPON_MICROSMG"),250,true,true)
								TaskShootAtEntity(target,ped,25000,GetHashKey("FIRING_PATTERN_FULL_AUTO"))

								SetTimeout(25000,function()
									ClearPedTasks(target)
									TaskWanderStandard(target,10.0,10)
									TaskReactAndFleePed(target,ped)
									SetPedKeepTask(target,true)
								end)
							end
						end
					else
						timeDistance = 1

						local coords = GetEntityCoords(ped)
						local distance = #(coords - GetEntityCoords(target))

						if distance < 5 and IsPedFacingPed(target,ped,180.0) and not hasList[PedToNet(target)] then
							actionRobbery = true

							if math.random(100) >= 90 then
								vSERVER.insertPedlist(PedToNet(target),true,false)
							else
								vSERVER.insertPedlist(PedToNet(target),true,false)
							end

							SetEntityAsMissionEntity(target,true,true)

							while not NetworkHasControlOfEntity(target) and DoesEntityExist(target) do
								NetworkRequestControlOfEntity(target)
								Wait(100)
							end

							RequestAnimDict("random@arrests@busted")
							while not HasAnimDictLoaded("random@arrests@busted") do
								Wait(1)
							end

							TaskPlayAnim(target,"random@arrests@busted","idle_a",3.0,3.0,-1,49,0,0,0,0)

							TaskSetBlockingOfNonTemporaryEvents(target,true)
							SetBlockingOfNonTemporaryEvents(target,true)
							SetPedDropsWeaponsWhenDead(target,false)
							TaskTurnPedToFaceEntity(target,ped,3.0)
							SetPedSuffersCriticalHits(target,false)
							SetPedAsNoLongerNeeded(target)

							local timeAim = 0
							while IsPlayerFreeAiming(PlayerId()) do
								timeAim = timeAim + 1

								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local distance = #(coords - GetEntityCoords(target))
								if timeAim >= 1000 or distance > 5 then
									break
								end

								Wait(1)
							end

							if timeAim >= 1000 then
								RequestAnimDict("mp_common")
								while not HasAnimDictLoaded("mp_common") do
									Wait(1)
								end

								TaskPlayAnim(target,"mp_common","givetake1_a",3.0,3.0,-1,48,0,0,0,0)
								vSERVER.paymentRobbery()
							end

							ClearPedTasks(target)
							TaskWanderStandard(target,10.0,10)
							TaskReactAndFleePed(target,ped)
							SetPedKeepTask(target,true)

							if math.random(100) >= 75 then
								Wait(1000)

								GiveWeaponToPed(target,GetHashKey("WEAPON_MICROSMG"),255,true,true)
								TaskShootAtEntity(target,ped,25000,GetHashKey("FIRING_PATTERN_FULL_AUTO"))

								SetTimeout(25000,function()
									ClearPedTasks(target)
									TaskWanderStandard(target,10.0,10)
									TaskReactAndFleePed(target,ped)
									SetPedKeepTask(target,true)
								end)
							end
						end
					end

					actionRobbery = false
				end
			end
		end

		Wait(timeDistance)
	end
end)