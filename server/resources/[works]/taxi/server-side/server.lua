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
Tunnel.bindInterface("taxi",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentService()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = math.random(275,325)
		vRP.generateItem(user_id,"dollars",value,true)

		if vRP.userPremium(user_id) then
			vRP.generateItem(user_id,"dollars",value * 0.1,true)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initService(status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if status then
			vRP.insertPermission(source,"Taxi")
		else
			vRP.removePermission(source,"Taxi")
		end
	end

	return true
end