-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeDeath = 1200
local treatment = false
local deathStatus = false
local invencibleCount = 0
local playerActive = false
local emergencyButton = false
local updateTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:playerActive")
AddEventHandler("vrp:playerActive",function(user_id)
	playerActive = true

	SetDiscordAppId(750573899548196932)
	SetDiscordRichPresenceAsset("logobahamas")
	SetDiscordRichPresenceAssetSmall("logobahamas")
	SetRichPresence(user_id.." - Bahamas")
	SetDiscordRichPresenceAssetText("Bahamas")
	SetDiscordRichPresenceAssetSmallText("Bahamas")

	SetEntityInvincible(PlayerPedId(),true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if playerActive then
			if GetGameTimer() >= updateTimers then
				local ped = PlayerPedId()
				updateTimers = GetGameTimer() + 10000
				vRPS.userUpdate(GetPedArmour(ped),GetEntityHealth(ped),GetEntityCoords(ped))

				if invencibleCount < 3 then
					invencibleCount = invencibleCount + 1

					if invencibleCount >= 3 then
						SetEntityInvincible(ped,false)
						TriggerEvent("paramedic:playerActive")
					end
				end
			end
		end

		Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999

		if playerActive then
			local ped = PlayerPedId()
			if GetEntityHealth(ped) <= 101 then
				if not deathStatus then
					timeDeath = 1200
					deathStatus = true
					emergencyButton = false

					SendNUIMessage({ death = true })

					TriggerEvent("inventory:preventWeapon",false)

					local coords = GetEntityCoords(ped)
					NetworkResurrectLocalPlayer(coords,true,true,false)

					SetEntityHealth(ped,101)
					SetEntityInvincible(ped,true)

					TriggerEvent("hud:removeHood")
					TriggerEvent("hud:removeScuba")
					TriggerEvent("radio:outServers")
					TriggerEvent("pma-voice:toggleMute")
					TriggerServerEvent("inventory:Cancel")
					exports["smartphone"]:closeSmartphone()
				else
					timeDistance = 1
					SetEntityHealth(ped,101)

					if timeDeath <= 0 then
						timeDeath = 1200
						deathStatus = false

						ClearPedTasks(ped)
						ClearPedBloodDamage(ped)
						SetEntityHealth(ped,200)
						SetEntityInvincible(ped,false)

						TriggerEvent("resetHandcuff")
						TriggerEvent("resetBleeding")
						TriggerEvent("resetDiagnostic")
						TriggerServerEvent("vRP:endGame")
						TriggerEvent("pma-voice:toggleMute")
						TriggerEvent("inventory:clearWeapons")

						DoScreenFadeOut(0)
						SetEntityCoordsNoOffset(ped,-1041.25,-2744.99,21.35,false,false,false,true)
						SendNUIMessage({ death = false })

						Wait(1000)

						DoScreenFadeIn(1000)
					else
						SendNUIMessage({ deathtext = "NOCAUTEADO, AGUARDE <color>"..timeDeath.." SEGUNDOS</color>" })

						if not IsEntityPlayingAnim(ped,"dead","dead_a",3) and not IsPedInAnyVehicle(ped) then
							tvRP.playAnim(false,{"dead","dead_a"},true)
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
		SetPlayerHealthRechargeLimit(PlayerId(),0)

		if GetEntityMaxHealth(PlayerPedId()) ~= 200 then
			SetEntityMaxHealth(PlayerPedId(),200)
			SetPedMaxHealth(PlayerPedId(),200)
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.checkDeath()
	if deathStatus and timeDeath <= 0 then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVEPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.revivePlayer(health)
	SetEntityHealth(PlayerPedId(),health)
	SetEntityInvincible(PlayerPedId(),false)

	if deathStatus then
		timeDeath = 1200
		deathStatus = false

		ClearPedTasks(PlayerPedId())

		TriggerEvent("resetBleeding")
		SendNUIMessage({ death = false })
		TriggerEvent("pma-voice:toggleMute")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.startTreatment()
	if not treatment then
		TriggerEvent("player:blockCommands",true)
		TriggerEvent("resetDiagnostic")
		TriggerEvent("resetBleeding")
		treatment = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local treatmentTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= treatmentTimers then
			treatmentTimers = GetGameTimer() + 1000

			if treatment then
				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)

				if health < 200 then
					SetEntityHealth(ped,health + 1)
				else
					treatment = false
					TriggerEvent("player:blockCommands",false)
					TriggerEvent("Notify","amarelo","Tratamento concluido.",5000)
				end
			end
		end

		Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMEDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local deathTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= deathTimers then
			deathTimers = GetGameTimer() + 1000

			if deathStatus then
				if timeDeath > 0 then
					timeDeath = timeDeath - 1
				end
			end
		end

		Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if deathStatus then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,69,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)