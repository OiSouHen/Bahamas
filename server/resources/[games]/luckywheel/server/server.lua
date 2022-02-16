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
Tunnel.bindInterface("luckywheel",cRP)
vCLIENT = Tunnel.getInterface("luckywheel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local wheelBonus = {}
local wheelActive = 0
local wheelPlayers = {}
local wheelPayments = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROLLING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkRolling()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and wheelActive == 0 then
		local identity = vRP.userIdentity(user_id)
		local userSteam = identity["steam"]

		if wheelPlayers[userSteam] == nil then
			wheelPlayers[userSteam] = 0
		end

		if wheelBonus[userSteam] then
			wheelActive = parseInt(user_id)
			wheelBonus[userSteam] = nil
			return true
		end

		if vRP.userPremium(user_id) then
			if wheelPlayers[userSteam] >= 2 then
				TriggerClientEvent("Notify",source,"amarelo","Atingiu o limite diário.",5000)
				return false
			end
		else
			if wheelPlayers[userSteam] >= 1 then
				TriggerClientEvent("Notify",source,"amarelo","Atingiu o limite diário.",5000)
				return false
			end
		end

		if vRP.tryGetInventoryItem(user_id,"dollars",5000,true) then
			wheelPlayers[userSteam] = wheelPlayers[userSteam] + 1
			wheelActive = parseInt(user_id)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROLLING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("luckywheel:startRolling")
AddEventHandler("luckywheel:startRolling",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local randResult = math.random(134)

		if randResult <= 10 then
			wheelPayments[user_id] = 1
		elseif randResult >= 11 and randResult <= 20 then
			wheelPayments[user_id] = 2
		elseif randResult >= 21 and randResult <= 24 then
			wheelPayments[user_id] = 3
		elseif randResult >= 25 and randResult <= 30 then
			wheelPayments[user_id] = 4
		elseif randResult >= 31 and randResult <= 40 then
			wheelPayments[user_id] = 5
		elseif randResult >= 41 and randResult <= 48 then
			wheelPayments[user_id] = 6
		elseif randResult >= 49 and randResult <= 52 then
			wheelPayments[user_id] = 7
		elseif randResult >= 53 and randResult <= 57 then
			wheelPayments[user_id] = 8
		elseif randResult >= 58 and randResult <= 68 then
			wheelPayments[user_id] = 9
		elseif randResult >= 69 and randResult <= 79 then
			wheelPayments[user_id] = 10
		elseif randResult >= 80 and randResult <= 84 then
			wheelPayments[user_id] = 11
		elseif randResult >= 85 and randResult <= 88 then
			wheelPayments[user_id] = 12
		elseif randResult >= 89 and randResult <= 100 then
			wheelPayments[user_id] = 13
		elseif randResult >= 101 and randResult <= 105 then
			wheelPayments[user_id] = 14
		elseif randResult >= 106 and randResult <= 109 then
			wheelPayments[user_id] = 15
		elseif randResult >= 110 and randResult <= 115 then
			wheelPayments[user_id] = 16
		elseif randResult >= 116 and randResult <= 129 then
			wheelPayments[user_id] = 17
		elseif randResult >= 130 and randResult <= 134 then
			wheelPayments[user_id] = 18
		elseif randResult == 135 then
			wheelPayments[user_id] = 19
		elseif randResult == 136 then
			wheelPayments[user_id] = 20
		end

		TriggerClientEvent("luckywheel:myRoll",source)
		TriggerClientEvent("luckywheel:startRoll",-1,wheelPayments[user_id])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROLLING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("luckywheel:paymentWheel")
AddEventHandler("luckywheel:paymentWheel",function()
	wheelActive = 0

	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and wheelPayments[user_id] then
		if wheelPayments[user_id] == 2 then
			vRP.giveInventoryItem(user_id,"dollars",2500,true)
		elseif wheelPayments[user_id] == 3 then
			vRP.giveInventoryItem(user_id,"dollars",15000,true)
		elseif wheelPayments[user_id] == 11 then
			vRP.giveInventoryItem(user_id,"chips",15000,true)
		elseif wheelPayments[user_id] == 4 then
			vRP.giveInventoryItem(user_id,"chips",10000,true)
		elseif wheelPayments[user_id] == 14 then
			vRP.giveInventoryItem(user_id,"dollars",10000,true)
		elseif wheelPayments[user_id] == 5 then
			local identity = vRP.userIdentity(user_id)
			wheelBonus[identity["steam"]] = true
		elseif wheelPayments[user_id] == 6 then
			vRP.giveInventoryItem(user_id,"dollars",5000,true)
		elseif wheelPayments[user_id] == 7 then
			vRP.giveInventoryItem(user_id,"dollars",20000,true)
		elseif wheelPayments[user_id] == 8 then
			vRP.giveInventoryItem(user_id,"chips",12500,true)
		elseif wheelPayments[user_id] == 10 then
			vRP.giveInventoryItem(user_id,"dollars",7500,true)
		elseif wheelPayments[user_id] == 12 then
			local identity = vRP.userIdentity(user_id)
			vRP.execute("accounts/infosUpdategems",{ steam = identity["steam"], gems = 10 })
		elseif wheelPayments[user_id] == 15 then
			vRP.giveInventoryItem(user_id,"dollars",22500,true)
		elseif wheelPayments[user_id] == 16 then
			vRP.giveInventoryItem(user_id,"chips",17500,true)
		elseif wheelPayments[user_id] == 18 then
			vRP.giveInventoryItem(user_id,"dollars",12500,true)
		elseif wheelPayments[user_id] == 19 then
			local vehName = "skyliner34"
			local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
			if vehicle[1] then
				if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
					vRP.execute("vehicles/rentalVehiclesUpdate",{ user_id = parseInt(user_id), vehicle = vehName, days = 15, rental = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..vehicleName(vehName).."</b> atualizado.",5000)
				else
					vRP.execute("vehicles/rentalVehiclesDays",{ user_id = parseInt(user_id), vehicle = vehName, days = 15 })
					TriggerClientEvent("Notify",source,"verde","Ganhou <b>7 Dias</b> de aluguel no veículo <b>"..vehicleName(vehName).."</b>.",5000)
				end
			else
				vRP.execute("vehicles/rentalVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false), rental = parseInt(os.time()), rendays = 7 })
				TriggerClientEvent("Notify",source,"verde","Ganhou <b>7 Dias</b> de aluguel do veículo <b>"..vehicleName(vehName).."</b>.",5000)
			end
		elseif wheelPayments[user_id] == 20 then
			vRP.giveInventoryItem(user_id,"dollars",25000,true)
		end

		wheelPayments[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if parseInt(wheelActive) == user_id then
		wheelActive = 0
	end

	if wheelPayments[user_id] then
		wheelPayments[user_id] = nil
	end
end)