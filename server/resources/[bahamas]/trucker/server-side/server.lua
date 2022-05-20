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
Tunnel.bindInterface("trucker",cRP)
vGARAGE = Tunnel.getInterface("trucker")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local deliveryPackage = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkExist()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if deliveryPackage[user_id] then
			if vRP.userPremium(user_id) then
				if deliveryPackage[user_id] >= 2 then
					TriggerClientEvent("Notify",source,"amarelo","Atingiu o limite diário.",5000)
					return true
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Atingiu o limite diário.",5000)
				return true
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if deliveryPackage[user_id] == nil then
			deliveryPackage[user_id] = 0
		end

		vRP.generateItem(user_id,"plasticbottle",math.random(8,12),true)
		vRP.generateItem(user_id,"glassbottle",math.random(8,12),true)
		vRP.generateItem(user_id,"elastic",math.random(8,12),true)
		vRP.generateItem(user_id,"metalcan",math.random(8,12),true)
		vRP.generateItem(user_id,"battery",math.random(8,12),true)
		vRP.generateItem(user_id,"fabric",math.random(4,6),true)

		deliveryPackage[user_id] = deliveryPackage[user_id] + 1
	end
end