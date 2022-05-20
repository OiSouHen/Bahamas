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
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Hours"] = 18
GlobalState["Minutes"] = 0
GlobalState["Weather"] = "CLEAR"
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		GlobalState["Minutes"] = GlobalState["Minutes"] + 1
		
		if GlobalState["Minutes"] >= 60 then
			GlobalState["Hours"] = GlobalState["Hours"] + 1
			GlobalState["Minutes"] = 0
			
			if GlobalState["Hours"] >= 24 then
				GlobalState["Hours"] = 0
			end
		end
		
		Wait(10000)
		
		TriggerClientEvent("hud:syncTimers",-1,{ GlobalState["Hours"],GlobalState["Minutes"],GlobalState["Weather"] })
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
				GlobalState["Hours"] = parseInt(args[1])
				GlobalState["Minutes"] = parseInt(args[2])
				GlobalState["Weather"] = args[3]
				
				TriggerClientEvent("hud:syncTimers",-1,{ GlobalState["Hours"],GlobalState["Minutes"],GlobalState["Weather"] })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("hud:syncTimers",source,{ GlobalState["Hours"],GlobalState["Minutes"],GlobalState["Weather"] })
end)