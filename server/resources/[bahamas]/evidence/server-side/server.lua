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
Tunnel.bindInterface("evidence",cRP)
vCLIENT = Tunnel.getInterface("evidence")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local evidenceList = {}
local evidenceNumber = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("evidence:dropEvidence")
AddEventHandler("evidence:dropEvidence",function(evidenceType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local evidenceItem = 1
		local evidenceColor = {}

		if evidenceType == "yellow" then
			evidenceItem = 1
			evidenceColor = { 244,197,50 }
		elseif evidenceType == "red" then
			evidenceItem = 2
			evidenceColor = { 241,96,96 }
		elseif evidenceType == "green" then
			evidenceItem = 3
			evidenceColor = { 140,212,91 }
		elseif evidenceType == "blue" then
			evidenceItem = 4
			evidenceColor = { 70,140,245 }
		end

		evidenceNumber = evidenceNumber + 1
		local identity = vRP.userIdentity(user_id)
		if identity then
			local userCoords,gridZone = vCLIENT.getPostions(source)

			if evidenceList[gridZone] == nil then
				evidenceList[gridZone] = {}
			end

			evidenceList[gridZone][tostring(evidenceNumber)] = { userCoords,tostring("evidence0"..evidenceItem.."-"..os.time().."-"..identity["serial"]),evidenceColor }
			TriggerClientEvent("evidence:evidenceInsert",-1,evidenceNumber,evidenceList[gridZone][tostring(evidenceNumber)],gridZone)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("evidence:removeEvidence")
AddEventHandler("evidence:removeEvidence",function(evidenceId,gridZone)
	if evidenceList[gridZone] then
		evidenceList[gridZone][tostring(evidenceId)] = nil
		TriggerClientEvent("evidence:evidenceRemove",-1,evidenceId,gridZone)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("evidence:pickupEvidence")
AddEventHandler("evidence:pickupEvidence",function(evidenceId,gridZone)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if evidenceList[gridZone] then
			if evidenceList[gridZone][tostring(evidenceId)] then
				vRP.giveInventoryItem(user_id,evidenceList[gridZone][tostring(evidenceId)][2],1,true)
				evidenceList[gridZone][tostring(evidenceId)] = nil
				TriggerClientEvent("evidence:evidenceRemove",-1,evidenceId,gridZone)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("evidence",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(1140.07,-1567.01,35.38))

			if distance <= 1.0 then
				if vRP.hasGroup(user_id,"Emergency") then
					local userSerial = vRP.userSerial(args[1])
					if userSerial then
						local identity = vRP.userIdentity(userSerial)
						if identity then
							TriggerClientEvent("Notify",source,"amarelo","Evidência de <b>"..identity["name2"].."</b>.",5000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("evidence:evidenceList",source,evidenceList)
end)