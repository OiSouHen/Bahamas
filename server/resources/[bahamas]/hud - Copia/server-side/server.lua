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
Tunnel.bindInterface("hud",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local clockHours = 18
local clockMinutes = 0
local weatherSync = "CLEAR"
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		clockMinutes = clockMinutes + 1

		if clockMinutes >= 60 then
			clockHours = clockHours + 1
			clockMinutes = 0

			if clockHours >= 24 then
				clockHours = 0
			end
		end

		Citizen.Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("timeset",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.hasGroup(user_id,"Admin") then
				clockHours = parseInt(args[1])
				clockMinutes = parseInt(args[2])
				weatherSync = args[3]
				TriggerClientEvent("hud:syncTimers",-1,{ clockMinutes,clockHours,weatherSync })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("hud:syncTimers",source,{ clockMinutes,clockHours,weatherSync })
end)