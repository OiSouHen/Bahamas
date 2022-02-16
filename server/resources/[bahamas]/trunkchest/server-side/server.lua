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
Tunnel.bindInterface("trunkchest",cRP)
vCLIENT = Tunnel.getInterface("trunkchest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehChest = {}
local vehNames = {}
local vehWeight = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,3)
		if vehicle then
			local plateUserId = vRP.userPlate(vehPlate)
			if plateUserId then
				if vRPC.inVehicle(source) then
					vehWeight[user_id] = 7
					vehChest[user_id] = "vehGloves:"..parseInt(plateUserId)..":"..vehName
				else
					vehWeight[user_id] = parseInt(vehicleChest(vehName))
					vehChest[user_id] = "vehChest:"..parseInt(plateUserId)..":"..vehName
				end

				vehNames[user_id] = vehName

				local myInventory = {}
				local inventory = vRP.userInventory(user_id)
				for k,v in pairs(inventory) do
					v["amount"] = parseInt(v["amount"])
					v["name"] = itemName(v["item"])
					v["peso"] = itemWeight(v["item"])
					v["index"] = itemIndex(v["item"])
					v["max"] = itemMaxAmount(v["item"])
					v["type"] = itemType(v["item"])
					v["desc"] = itemDescription(v["item"])
					v["economy"] = itemEconomy(v["item"])
					v["key"] = v["item"]
					v["slot"] = k
		
					local splitName = splitString(v["item"],"-")
					if splitName[2] ~= nil then
						v["durability"] = parseInt(os.time() - splitName[2])
						v["days"] = itemDurability(v["item"])
						v["serial"] = splitName[3]
					else
						v["durability"] = 0
						v["days"] = 1
					end

					myInventory[k] = v
				end

				local myChest = {}
				local result = vRP.getSrvdata(vehChest[user_id])
				for k,v in pairs(result) do
					v["amount"] = parseInt(v["amount"])
					v["name"] = itemName(v["item"])
					v["peso"] = itemWeight(v["item"])
					v["index"] = itemIndex(v["item"])
					v["max"] = itemMaxAmount(v["item"])
					v["type"] = itemType(v["item"])
					v["desc"] = itemDescription(v["item"])
					v["economy"] = itemEconomy(v["item"])
					v["key"] = v["item"]
					v["slot"] = k
		
					local splitName = splitString(v["item"],"-")
					if splitName[2] ~= nil then
						v["durability"] = parseInt(os.time() - splitName[2])
						v["days"] = itemDurability(v["item"])
						v["serial"] = splitName[3]
					else
						v["durability"] = 0
						v["days"] = 1
					end

					myChest[k] = v
				end

				return myInventory,myChest,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id])
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOSTORE
-----------------------------------------------------------------------------------------------------------------------------------------
local noStore = {
	["meatA"] = true,
	["meatB"] = true,
	["meatC"] = true,
	["meatS"] = true,
	["energetic"] = true,
	["water"] = true,
	["dirtywater"] = true,
	["coffee"] = true,
	["cola"] = true,
	["tacos"] = true,
	["fries"] = true,
	["soda"] = true,
	["hamburger"] = true,
	["hamburger2"] = true,
	["hamburger3"] = true,
	["hamburger4"] = true,
	["hamburger5"] = true,
	["hotdog"] = true,
	["donut"] = true,
	["dollars"] = true,
	["dollarsz"] = true,
	["chocolate"] = true,
	["sandwich"] = true,
	["absolut"] = true,
	["chandon"] = true,
	["dewars"] = true,
	["hennessy"] = true,
	["orange"] = true,
	["strawberry"] = true,
	["grape"] = true,
	["tange"] = true,
	["banana"] = true,
	["passion"] = true,
	["tomato"] = true,
	["orangejuice"] = true,
	["tangejuice"] = true,
	["grapejuice"] = true,
	["strawberryjuice"] = true,
	["bananajuice"] = true,
	["passionjuice"] = true,
	["oxy"] = true,
	["credential"] = true,
	["chip"] = true,
	["premium01"] = true,
	["premium02"] = true,
	["premium03"] = true,
	["premium04"] = true,
	["premiumplate"] = true,
	["newgarage"] = true,
	["newchars"] = true,
	["newprops"] = true,
	["namechange"] = true,
	["homecont01"] = true,
	["homecont02"] = true,
	["homecont03"] = true,
	["homecont04"] = true,
	["homecont05"] = true,
	["homecont06"] = true,
	["homecont07"] = true,
	["homecont08"] = true,
	["homecont09"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHS
-----------------------------------------------------------------------------------------------------------------------------------------
local storeVehs = {
	["ratloader"] = {
		["woodlog"] = true
	},
	["stockade"] = {
		["pouch"] = true
	},
	["trash"] = {
		["glassbottle"] = true,
		["plasticbottle"] = true,
		["elastic"] = true,
		["metalcan"] = true,
		["battery"] = true
	},
	["taco"] = {
		["orange"] = true,
		["strawberry"] = true,
		["grape"] = true,
		["tange"] = true,
		["banana"] = true,
		["passion"] = true,
		["tomato"] = true,
		["orangejuice"] = true,
		["tangejuice"] = true,
		["grapejuice"] = true,
		["strawberryjuice"] = true,
		["bananajuice"] = true,
		["passionjuice"] = true
	},
	["mule3"] = {
		["meatA"] = true,
		["meatB"] = true,
		["meatC"] = true,
		["meatS"] = true,
		["animalpelt"] = true,
		["WEAPON_MUSKET"] = true,
		["WEAPON_SNIPERRIFLE"] = true,
		["WEAPON_MUSKET_AMMO"] = true,
		["switchblade"] = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateChest(slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.updateChest(user_id,vehChest[user_id],slot,target,amount) then
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeItem(nameItem,slot,amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehName = vehNames[user_id]

		if storeVehs[vehName] then
			if not storeVehs[vehName][nameItem] then
				TriggerClientEvent("trunkchest:Update",source,"requestChest")
				TriggerClientEvent("Notify",source,"amarelo","Armazenamento proibido.",5000)
				return
			end
		end

		if (vehName == "mule" or vehName == "benson" or vehName == "pounder") then
			if (nameItem == "dollars" or nameItem == "dollarsz") then
				TriggerClientEvent("trunkchest:Update",source,"requestChest")
				TriggerClientEvent("Notify",source,"amarelo","Armazenamento proibido.",5000)
				return
			end
		else
			if noStore[nameItem] and not storeVehs[vehName] then
				TriggerClientEvent("trunkchest:Update",source,"requestChest")
				TriggerClientEvent("Notify",source,"amarelo","Armazenamento proibido.",5000)
				return
			end
		end

		if vRP.storeChest(user_id,vehChest[user_id],amount,parseInt(vehWeight[user_id]),slot,target) then
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
		else
			local result = vRP.getSrvdata(vehChest[user_id])
			TriggerClientEvent("trunkchest:UpdateWeight",source,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id]))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(slot,amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryChest(user_id,vehChest[user_id],amount,slot,target) then
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
		else
			local result = vRP.getSrvdata(vehChest[user_id])
			TriggerClientEvent("trunkchest:UpdateWeight",source,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id]))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet = vRPC.vehList(source,3)
		if vehicle then
			if not vRPC.inVehicle(source) then
				TriggerClientEvent("player:syncDoorsOptions",-1,vehNet,"close")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:OPENTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:openTrunk")
AddEventHandler("trunkchest:openTrunk",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth = vRPC.vehList(source,3)
		if vehicle then
			if not vehLock and not vehBlock and parseInt(vehHealth) > 0 then
				if vRP.userPlate(vehPlate) then
					if not vRPC.inVehicle(source) then
						TriggerClientEvent("player:syncDoorsOptions",-1,vehNet,"open")
					end

					vCLIENT.trunkOpen(source)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if vehNames[user_id] then
		vehNames[user_id] = nil
	end

	if vehChest[user_id] then
		vehChest[user_id] = nil
	end

	if vehWeight[user_id] then
		vehWeight[user_id] = nil
	end
end)