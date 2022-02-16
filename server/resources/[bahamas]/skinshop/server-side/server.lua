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
Tunnel.bindInterface("skinshop",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkShares()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
			return false
		end

		if vRP.wantedReturn(user_id) or vRP.reposeReturn(user_id) then
			return false
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateClothes(clothes)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Clothings", value = clothes })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] then
			if vRP.hasGroup(user_id,"Suporte") then
				local otherPlayer = vRP.userSource(args[1])
				if otherPlayer then
					vRPC.applySkin(otherPlayer,GetHashKey(args[2]))
					vRP.updateSelectSkin(parseInt(args[1]),GetHashKey(args[2]))
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVEPROPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:removeProps")
AddEventHandler("skinshop:removeProps",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local otherPlayer = vRPC.nearestPlayer(source,1.1)
		if otherPlayer then
			if vRP.hasPermission(user_id,"Police") then
				if mode == "mask" then
					TriggerClientEvent("skinshop:setMask",otherPlayer)
				elseif mode == "hat" then
					TriggerClientEvent("skinshop:setHat",otherPlayer)
				end
			end
		end
	end
end)