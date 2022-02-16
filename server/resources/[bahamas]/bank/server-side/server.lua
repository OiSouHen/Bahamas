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
Tunnel.bindInterface("bank",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKDEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankDeposit(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = parseInt(amount)

		if parseInt(value) > 0 then
			if vRP.tryGetInventoryItem(user_id,"dollars",value,true) then
				vRP.addBank(user_id,value)
			else
				TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankWithdraw(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
			return false
		end

		local value = parseInt(amount)
		if (vRP.inventoryWeight(user_id) + (itemWeight("dollars") * value)) <= vRP.getBackpack(user_id) then
			if not vRP.withdrawCash(user_id,value) then
				TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end
end