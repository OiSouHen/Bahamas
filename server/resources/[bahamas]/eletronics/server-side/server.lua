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
Tunnel.bindInterface("eletronics",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local atmTimers = GetGameTimer() + (math.random(20,30) * 60000)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkSystems()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policeResult = vRP.numPermission("Police")
		if parseInt(#policeResult) <= 15 or GetGameTimer() < atmTimers then
			TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			return false
		else
			local consultItem = vRP.getInventoryItemAmount(user_id,"floppy")
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Necessário possuir um <b>Disquete</b>.",5000)
				return false
			end

			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			atmTimers = GetGameTimer() + (math.random(20,30) * 60000)
			TriggerClientEvent("player:applyGsr",source)

			for k,v in pairs(policeResult) do
				async(function()
					vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
					TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Caixa Eletrônico", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
				end)
			end

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentSystems()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if GetGameTimer() < atmTimers then
			vRP.wantedTimer(user_id,20)
			vRP.generateItem(user_id,"dollarsz",math.random(25,45))
		end
	end
end