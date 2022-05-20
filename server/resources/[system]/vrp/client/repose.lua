-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSEVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local reposeTimer = 0
local reposeStatus = false
local repose = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:REPOSETIMER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:reposeTimer")
AddEventHandler("vrp:reposeTimer",function(timeUpdate)
	SendNUIMessage({ reposeTime = timeUpdate })
	reposeTimer = timeUpdate
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:REPOSEUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:reposeUpdate")
AddEventHandler("vrp:reposeUpdate",function(statusUpdate)
	reposeStatus = statusUpdate
	SendNUIMessage({ repose = reposeStatus })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADREPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if reposeStatus then
			if GetGameTimer() >= repose then
				reposeTimer = reposeTimer - 1
				repose = GetGameTimer() + 1000
				SendNUIMessage({ reposeTime = reposeTimer })

				if reposeTimer <= 0 then
					vRPS.reposeReset()
					reposeStatus = false
					SendNUIMessage({ repose = reposeStatus })
				end
			end
		end

		Wait(500)
	end
end)