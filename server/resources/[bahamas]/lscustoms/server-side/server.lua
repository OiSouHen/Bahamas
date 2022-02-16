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
Tunnel.bindInterface("lscustoms",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission(hasPerm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
			return false
		end

		if vRP.wantedReturn(user_id) then
			return false
		end

		if not hasPerm then
			return true
		else
			if vRP.hasPermission(user_id,hasPerm) then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:attemptPurchase")
AddEventHandler("lscustoms:attemptPurchase",function(type,mod)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if type == "engines" or type == "brakes" or type == "transmission" or type == "suspension" or type == "shield" then
			if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		else
			if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type])) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:updateVehicle")
AddEventHandler("lscustoms:updateVehicle",function(mods,vehPlate,vehName)
	local plateUser = vRP.userPlate(vehPlate)
	if plateUser then
		vRP.execute("entitydata/setData",{ dkey = "custom:"..plateUser..":"..vehName, value = json.encode(mods) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHEDIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vehedit",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Suporte") then
			TriggerClientEvent("lscustoms:openAdmin",source)
		end
	end
end)