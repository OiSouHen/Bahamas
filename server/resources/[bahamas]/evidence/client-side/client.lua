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
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVIDENCELIST
-----------------------------------------------------------------------------------------------------------------------------------------
local evidenceList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v["x"] << 8) | v["y"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVIDENCE:EVIDENCEREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("evidence:evidenceRemove")
AddEventHandler("evidence:evidenceRemove",function(id,gridZone)
	if evidenceList[gridZone] then
		if evidenceList[gridZone][tostring(id)] then
			evidenceList[gridZone][tostring(id)] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVIDENCE:EVIDENCEINSERT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("evidence:evidenceInsert")
AddEventHandler("evidence:evidenceInsert",function(id,status,gridZone)
	if evidenceList[gridZone] == nil then
		evidenceList[gridZone] = {}
	end

	evidenceList[gridZone][tostring(id)] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVIDENCE:EVIDENCELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("evidence:evidenceList")
AddEventHandler("evidence:evidenceList",function(status)
	evidenceList = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_FLASHLIGHT") and IsPlayerFreeAiming(PlayerId()) then
			local coords = GetEntityCoords(ped)
			local gridZone = getGridzone(coords["x"],coords["y"])

			if evidenceList[gridZone] then
				for k,v in pairs(evidenceList[gridZone]) do
					local distance = #(coords - vector3(v[1]["x"],v[1]["y"],v[1]["z"]))
					if distance <= 5 then
						timeDistance = 1
						DrawMarker(28,v[1]["x"],v[1]["y"],v[1]["z"] + 0.05,0.0,0.0,0.0,180.0,0.0,0.0,0.045,0.045,0.045,v[3][1],v[3][2],v[3][3],200,0,0,0,0)

						if distance <= 1.2 and IsControlJustPressed(1,38) then
							TriggerServerEvent("evidence:pickupEvidence",k,gridZone)
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPOSITIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getPostions()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local gridZone = getGridzone(coords["x"],coords["y"])
	local _,cdz = GetGroundZFor_3dCoord(coords["x"],coords["y"],coords["z"])

	return vector3(coords["x"],coords["y"],cdz),gridZone
end