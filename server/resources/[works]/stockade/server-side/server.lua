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
cRP = {}
Tunnel.bindInterface("stockade",cRP)
vCLIENT = Tunnel.getInterface("stockade")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local stockadeNet = 0
local stockadeTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkStockade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policeResult = vRP.numPermission("Police")
		if parseInt(#policeResult) <= 8 or GetGameTimer() < stockadeTimer then
			TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			return false
		end

		local consultItem = vRP.getInventoryItemAmount(user_id,"card05")
		if consultItem[1] <= 0 then
			return false
		end

		if vRP.checkBroken(consultItem[2]) then
			TriggerClientEvent("Notify",source,"vermelho","Item quebrado.",5000)
			return false
		end

		if vRP.tryGetInventoryItem(user_id,consultItem[2],1,true,false) then
			stockadeTimer = GetGameTimer() + (120 * 60000)
			TriggerClientEvent("player:applyGsr",source)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOCKADEINSERT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stockadeInsert(vehNet)
	stockadeNet = parseInt(vehNet)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("stockade:explodeVehicle")
AddEventHandler("stockade:explodeVehicle",function()
	stockadeNet = 0
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOCKADENET
-----------------------------------------------------------------------------------------------------------------------------------------
function stockadeNet()
	return stockadeNet
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("stockadeNet",stockadeNet)