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
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local systemCircuits = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("circuito",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			local raceLaps = vRP.prompt(source,"Total de Voltas:","")
			if raceLaps == "" or parseInt(raceLaps) <= 0 then
				return
			end

			local identity = vRP.userIdentity(user_id)
			if identity then
				TriggerClientEvent("circuits:makeCircuits",source,raceLaps,identity["name"].." "..identity["name2"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTRACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.inputRaces(newCircuit)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if systemCircuits[tostring(user_id)] == nil then
			systemCircuits[tostring(user_id)] = {}
		end

		systemCircuits[tostring(user_id)] = newCircuit
		TriggerClientEvent("circuits:updateCircuits",-1,systemCircuits)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("circuits:updateCircuits",source,systemCircuits)
end)