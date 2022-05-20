-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT = Tunnel.getInterface("chat")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MESSAGEENTERED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chat:messageEntered")
AddEventHandler("chat:messageEntered",function(message)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(user_id)
		if identity then
			TriggerClientEvent("chatME",source,"^0"..identity["name"].." "..identity["name2"]..": "..message)

			local players = vRPC.nearestPlayers(source,10)
			for _,v in pairs(players) do
				TriggerClientEvent("chatME",v[2],"^0"..identity["name"].." "..identity["name2"]..": "..message)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDFALLBACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("__cfx_internal:commandFallback")
AddEventHandler("__cfx_internal:commandFallback",function(command)
	if not command then
		return
	end

	CancelEvent()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSCHAT
-----------------------------------------------------------------------------------------------------------------------------------------
function statusChat(source)
	return vCLIENT.statusChat(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("statusChat",statusChat)