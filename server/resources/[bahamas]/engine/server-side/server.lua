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
Tunnel.bindInterface("engine",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehFuels = {}
local vehBrakes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentFuel(price)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.paymentFull(user_id,price) then
			return true
		else
			TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
			return false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.vehicleFuel(vehicle)
	if vehFuels[vehicle] == nil then
		vehFuels[vehicle] = 50
	end

	return vehFuels[vehicle]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:tryFuel")
AddEventHandler("engine:tryFuel",function(vehicle,fuel,playerAround)
	vehFuels[vehicle] = fuel

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("engine:syncFuel",v,vehicle,fuel)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.vehicleBrakes(vehicle)
	if vehBrakes[vehicle] == nil then
		vehBrakes[vehicle] = { 0.55,0.35,0.45 }
	end

	return vehBrakes[vehicle]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYBRAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:tryBrakes")
AddEventHandler("engine:tryBrakes",function(vehicle,brakeStatus,playerAround)
	vehBrakes[vehicle] = brakeStatus

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("engine:syncBrake",v,vehicle,brakeStatus)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTENGINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:insertEngines")
AddEventHandler("engine:insertEngines",function(vehicle,vehFuel,vehBrake)
	if vehBrake == "" then
		vehBrakes[vehicle] = { 0.90,0.55,0.75 }
	else
		vehBrakes[vehicle] = json.decode(vehBrake)

		if vehBrakes[vehicle][1] > 0.90 then
			vehBrakes[vehicle][1] = 0.90
		end

		if vehBrakes[vehicle][2] > 0.55 then
			vehBrakes[vehicle][2] = 0.55
		end

		if vehBrakes[vehicle][3] > 0.75 then
			vehBrakes[vehicle][3] = 0.75
		end
	end

	vehFuels[vehicle] = vehFuel
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:applyBrakes")
AddEventHandler("engine:applyBrakes",function(nameItem,vehicle,vehBrake,playerAround)
	if vehBrakes[vehicle] then
		if nameItem == "graphite01" then
			vehBrakes[vehicle][1] = vehBrakes[vehicle][1] + (vehBrake * 0.0090) + 0.0
		elseif nameItem == "graphite02" then
			vehBrakes[vehicle][2] = vehBrakes[vehicle][2] + (vehBrake * 0.0055) + 0.0
		elseif nameItem == "graphite03" then
			vehBrakes[vehicle][3] = vehBrakes[vehicle][3] + (vehBrake * 0.0075) + 0.0
		end

		if vehBrakes[vehicle][1] >= 0.90 then
			vehBrakes[vehicle][1] = 0.90
		end

		if vehBrakes[vehicle][2] >= 0.55 then
			vehBrakes[vehicle][2] = 0.55
		end

		if vehBrakes[vehicle][3] >= 0.75 then
			vehBrakes[vehicle][3] = 0.75
		end

		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("engine:syncBrake",v,vehicle,vehBrakes[vehicle])
			end)
		end
	end
end)