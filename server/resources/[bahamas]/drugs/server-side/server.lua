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
Tunnel.bindInterface("drugs",cRP)
vCLIENT = Tunnel.getInterface("drugs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local amount = {}
local hasList = {}
local lastTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemList = {
	{ item = "lean", priceMin = 100, priceMax = 150, randMin = 2, randMax = 4 },
	{ item = "ecstasy", priceMin = 100, priceMax = 150, randMin = 2, randMax = 4 },
	{ item = "cocaine", priceMin = 100, priceMax = 150, randMin = 2, randMax = 4 },
	{ item = "meth", priceMin = 100, priceMax = 150, randMin = 2, randMax = 4 },
	{ item = "joint", priceMin = 100, priceMax = 150, randMin = 2, randMax = 4 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Drugs") then
			TriggerClientEvent("Notify",source,"aviso","Sistema indisponível.",5000)
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkAmount()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(itemList) do
			local rand = math.random(v["randMin"],v["randMax"])
			local consultItem = vRP.getInventoryItemAmount(user_id,v["item"])
			if consultItem[1] >= parseInt(rand) then
				amount[user_id] = { v["item"],rand,math.random(v["priceMin"],v["priceMax"]) }

				if math.random(100) >= 75 then
					local ped = GetPlayerPed(source)
					local coords = GetEntityCoords(ped)

					local policeResult = vRP.numPermission("Police")
					for k,v in pairs(policeResult) do
						async(function()
							TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Venda de Drogas", x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 5 })
						end)
					end
				end

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
		if vRP.tryGetInventoryItem(user_id,amount[user_id][1],amount[user_id][2],true) then
			vRP.upgradeStress(user_id,2)
			TriggerClientEvent("player:applyGsr",source)
			local value = amount[user_id][3] * amount[user_id][2]

			vRP.generateItem(user_id,"dollarsz",parseInt(value),true)

			if math.random(100) >= 75 then
				if vRP.tryGetInventoryItem(user_id,"oxy",1,true) then
					vRP.generateItem(user_id,"dollarsz",math.random(125,175),true)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local robberys = {
	{ item = "notepad", min = 1, max = 5 },
	{ item = "mouse", min = 1, max = 1 },
	{ item = "silverring", min = 1, max = 1 },
	{ item = "goldring", min = 1, max = 1 },
	{ item = "watch", min = 1, max = 2 },
	{ item = "ominitrix", min = 1, max = 1 },
	{ item = "bracelet", min = 1, max = 1 },
	{ item = "spray01", min = 1, max = 2 },
	{ item = "spray02", min = 1, max = 2 },
	{ item = "spray03", min = 1, max = 2 },
	{ item = "spray04", min = 1, max = 2 },
	{ item = "dices", min = 1, max = 2 },
	{ item = "dish", min = 1, max = 3 },
	{ item = "sneakers", min = 1, max = 2 },
	{ item = "rimel", min = 1, max = 3 },
	{ item = "blender", min = 1, max = 1 },
	{ item = "switch", min = 1, max = 3 },
	{ item = "brush", min = 1, max = 2 },
	{ item = "domino", min = 1, max = 3 },
	{ item = "floppy", min = 1, max = 4 },
	{ item = "deck", min = 1, max = 2 },
	{ item = "pliers", min = 1, max = 2 },
	{ item = "slipper", min = 1, max = 1 },
	{ item = "soap", min = 1, max = 1 },
	{ item = "dollarsz", min = 425, max = 525 },
	{ item = "card01", min = 1, max = 1 },
	{ item = "card02", min = 1, max = 1 },
	{ item = "card03", min = 1, max = 1 },
	{ item = "card04", min = 1, max = 1 },
	{ item = "card05", min = 1, max = 1 }
}

function cRP.paymentRobbery()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local rand = math.random(#robberys)
		local value = math.random(robberys[rand]["min"],robberys[rand]["max"])

		vRP.generateItem(user_id,robberys[rand]["item"],value,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.insertPedlist(pedId,callPolice,sellDrugs)
	hasList[pedId] = true
	TriggerClientEvent("drugs:insertList",-1,pedId)

	if GetGameTimer() >= lastTimers then
		lastTimers = GetGameTimer() + (30 * 60000)
		TriggerClientEvent("drugs:clearList",-1)
	end

	if callPolice then
		if math.random(100) >= 50 then
			local source = source
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local textNotify = "Venda de Drogas"

			if not sellDrugs then
				textNotify = "Assalto em Andamento"
			end

			local policeResult = vRP.numPermission("Police")
			for k,v in pairs(policeResult) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = textNotify, x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 5 })
				end)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("drugs:updateList",source,hasList)
end)