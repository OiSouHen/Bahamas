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
Tunnel.bindInterface("blipsystem",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
local userBlips = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:UPDATEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("blipsystem:updateBlips")
AddEventHandler("blipsystem:updateBlips",function(userTable)
	userList = userTable

	for k,v in pairs(userList) do
		if DoesBlipExist(userBlips[k]) then
			SetBlipCoords(userBlips[k],v[1]["x"],v[1]["y"],v[1]["z"])
		else
			userBlips[k] = AddBlipForCoord(v[1]["x"],v[1]["y"],v[1]["z"])
			SetBlipSprite(userBlips[k],1)
			SetBlipAsShortRange(userBlips[k],true)
			SetBlipScale(userBlips[k],0.5)
			SetBlipColour(userBlips[k],v[3])
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v[2])
			EndTextCommandSetBlipName(userBlips[k])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("blipsystem:cleanBlips")
AddEventHandler("blipsystem:cleanBlips",function()
	for k,v in pairs(userBlips) do
		RemoveBlip(userBlips[k])
	end

	userBlips = {}
	userList = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("blipsystem:removeBlips")
AddEventHandler("blipsystem:removeBlips",function(source)
	if DoesBlipExist(userBlips[source]) then
		RemoveBlip(userBlips[source])
		userBlips[source] = nil
		userList[source] = nil
	end
end)