-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local wantedTimer = 0
local wantedStatus = false
local wanted = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:WANTEDTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:wantedTimer")
AddEventHandler("vrp:wantedTimer",function(timeUpdate)
	SendNUIMessage({ wantedTime = timeUpdate })
	wantedTimer = timeUpdate
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:WANTEDUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:wantedUpdate")
AddEventHandler("vrp:wantedUpdate",function(statusUpdate)
	wantedStatus = statusUpdate
	SendNUIMessage({ wanted = wantedStatus })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if wantedStatus then
			if GetGameTimer() >= wanted then
				wantedTimer = wantedTimer - 1
				wanted = GetGameTimer() + 1000
				SendNUIMessage({ wantedTime = wantedTimer })

				if wantedTimer <= 0 then
					vRPS.wantedReset()
					wantedStatus = false
					SendNUIMessage({ wanted = wantedStatus })
				end
			end
		end

		Wait(500)
	end
end)