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
Tunnel.bindInterface("checkin",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentCheckin()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			vRP.upgradeHunger(user_id,20)
			vRP.upgradeThirst(user_id,20)
			vRP.reposeTimer(user_id,30)
			return true
		end

		local amountValue = 1000
		local amountPerms = vRP.numPermission("Paramedic")

		if vRP.getHealth(source) <= 101 then
			amountValue = amountValue + 1000
		end

		if parseInt(#amountPerms) >= 1 then
			amountValue = amountValue + 500

			if vRP.request(source,"Paramédicos em serviço, prosseguir o tratamento por <b>$"..parseFormat(amountValue).."</b> dólares?",30) then
				if vRP.paymentFull(user_id,amountValue) then
					vRP.upgradeHunger(user_id,20)
					vRP.upgradeThirst(user_id,20)
					vRP.reposeTimer(user_id,15)
					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
				end
			end
		else
			if vRP.request(source,"Prosseguir o tratamento por <b>$"..parseFormat(amountValue).."</b> dólares?",30) then
				if vRP.paymentFull(user_id,amountValue) then
					vRP.upgradeHunger(user_id,20)
					vRP.upgradeThirst(user_id,20)
					vRP.reposeTimer(user_id,15)
					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
				end
			end
		end
	end

	return false
end