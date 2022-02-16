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
Tunnel.bindInterface("inventory",cRP)
vPLAYER = Tunnel.getInterface("player")
vGARAGE = Tunnel.getInterface("garages")
vTASKBAR = Tunnel.getInterface("taskbar")
vCLIENT = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local dropList = {}
local dropTimer = {}
local dropNumber = 0
local activeItens = {}
local healthItens = {}
local armorsItens = {}
local ammoPlayers = {}
local trashTables = {}
local verifyObjects = {}
local updateTrash = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONHASHS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponHashs = {
	[584646201] = "WEAPON_PISTOL_AMMO",
	[-1768145561] = "WEAPON_RIFLE_AMMO",
	[-270015777] = "WEAPON_SMG_AMMO",
	[1627465347] = "WEAPON_SMG_AMMO",
	[-2009644972] = "WEAPON_PISTOL_AMMO",
	[883325847] = "WEAPON_PETROLCAN_AMMO",
	[100416529] = "WEAPON_MUSKET_AMMO",
	[-1466123874] = "WEAPON_MUSKET_AMMO",
	[-1045183535] = "WEAPON_PISTOL_AMMO",
	[-1076751822] = "WEAPON_PISTOL_AMMO",
	[-1063057011] = "WEAPON_RIFLE_AMMO",
	[961495388] = "WEAPON_RIFLE_AMMO",
	[-619010992] = "WEAPON_SMG_AMMO",
	[2017895192] = "WEAPON_SHOTGUN_AMMO",
	[-771403250] = "WEAPON_PISTOL_AMMO",
	[736523883] = "WEAPON_SMG_AMMO",
	[-1357824103] = "WEAPON_RIFLE_AMMO",
	[2024373456] = "WEAPON_SMG_AMMO",
	[-1075685676] = "WEAPON_PISTOL_AMMO",
	[453432689] = "WEAPON_PISTOL_AMMO",
	[-2066285827] = "WEAPON_RIFLE_AMMO",
	[487013001] = "WEAPON_SHOTGUN_AMMO",
	[1432025498] = "WEAPON_SHOTGUN_AMMO",
	[1593441988] = "WEAPON_PISTOL_AMMO",
	[-86904375] = "WEAPON_RIFLE_AMMO",
	[137902532] = "WEAPON_PISTOL_AMMO",
	[-1074790547] = "WEAPON_RIFLE_AMMO",
	[2132975508] = "WEAPON_RIFLE_AMMO",
	[-2084633992] = "WEAPON_RIFLE_AMMO",
	[324215364] = "WEAPON_SMG_AMMO",
	[-1716589765] = "WEAPON_PISTOL_AMMO",
	[1649403952] = "WEAPON_SMG_AMMO",
	[-1121678507] = "WEAPON_SMG_AMMO"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local fishCoords = {
	["One"] = {
		["x"] = -3418.14,
		["y"] = 967.56,
		["z"] = 8.34,
		["dist"] = 20,
		["item"] = {
			"octopus",
			"shrimp",
			"carp",
			"horsefish",
			"tilapia"
		}
	},
	["Two"] = {
		["x"] = -4302.97,
		["y"] = 950.8,
		["z"] = 0.3,
		["dist"] = 100,
		["item"] = {
			"codfish",
			"catfish",
			"goldenfish",
			"pirarucu",
			"pacu",
			"tambaqui"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVESYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(activeItens) do
			if activeItens[k] > 0 then
				activeItens[k] = activeItens[k] - 1
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(dropTimer) do
			if dropTimer[k] > 0 then
				dropTimer[k] = dropTimer[k] - 1

				if dropTimer[k] <= 0 then
					dropTimer[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBackpack()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myInventory = {}
		local inventory = vRP.userInventory(user_id)
		for k,v in pairs(inventory) do
			if (parseInt(v["amount"]) <= 0 or itemBody(v["item"]) == nil) then
				vRP.removeInventoryItem(user_id,v["item"],parseInt(v["amount"]),false)
			else
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
		end

		return myInventory,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.invUpdate(slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.invUpdate(user_id,slot,target,amount) then
			TriggerClientEvent("inventory:Update",source,"updateMochila")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOFULL
-----------------------------------------------------------------------------------------------------------------------------------------
local noFull = {
	["chip"] = true,
	["premium01"] = true,
	["premium02"] = true,
	["premium03"] = true,
	["premium04"] = true,
	["premiumplate"] = true,
	["newgarage"] = true,
	["newchars"] = true,
	["newprops"] = true,
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
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropItem(nameItem,slot,amount,x,y,z,gridZone)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if activeItens[user_id] == nil and not vPLAYER.getHandcuff(source) and not vRP.wantedReturn(user_id) then
			if noFull[nameItem] then
				TriggerClientEvent("inventory:Update",source,"updateMochila")
				TriggerClientEvent("Notify",source,"amarelo","Armazenamento proibido.",5000)
				return
			end

			if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
				if dropList[gridZone] == nil then
					dropList[gridZone] = {}
				end

				dropNumber = dropNumber + 1
				local splitName = splitString(nameItem,"-")
				local numberSelect = tostring(dropNumber)

				local days = 1
				local durability = 0
				if splitName[2] ~= nil then
					durability = parseInt(os.time() - splitName[2])
					days = itemDurability(nameItem)
				end

				dropList[gridZone][numberSelect] = {
					["key"] = nameItem,
					["amount"] = amount,
					["coords"] = { x,y,z },
					["name"] = itemName(nameItem),
					["peso"] = itemWeight(nameItem),
					["index"] = itemIndex(nameItem),
					["days"] = days,
					["durability"] = durability
				}

				TriggerClientEvent("inventory:Update",source,"updateMochila")
				TriggerClientEvent("inventory:dropInsert",-1,gridZone,numberSelect,dropList[gridZone][numberSelect])
			end
		else
			TriggerClientEvent("inventory:Update",source,"updateMochila")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:INVEXPLODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:invExplode")
AddEventHandler("inventory:invExplode",function(source,nameItem,amount)
	local x,y,z,gridZone = vCLIENT.dropFunctions(source)

	if dropList[gridZone] == nil then
		dropList[gridZone] = {}
	end

	dropNumber = dropNumber + 1
	local splitName = splitString(nameItem,"-")
	local numberSelect = tostring(dropNumber)

	local days = 1
	local durability = 0
	if splitName[2] ~= nil then
		durability = parseInt(os.time() - splitName[2])
		days = itemDurability(nameItem)
	end

	dropList[gridZone][numberSelect] = {
		["key"] = nameItem,
		["amount"] = amount,
		["coords"] = { x,y,z },
		["name"] = itemName(nameItem),
		["peso"] = itemWeight(nameItem),
		["index"] = itemIndex(nameItem),
		["days"] = days,
		["durability"] = durability
	}

	TriggerClientEvent("inventory:dropInsert",-1,gridZone,numberSelect,dropList[gridZone][numberSelect])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropStockade(x,y,z,gridZone)
	if dropList[gridZone] == nil then
		dropList[gridZone] = {}
	end

	for i = 1,20 do
		dropNumber = dropNumber + 1
		local numberSelect = tostring(dropNumber)

		dropList[gridZone][numberSelect] = {
			["key"] = "dollarsz",
			["amount"] = math.random(2250,3250),
			["coords"] = { x,y,z },
			["name"] = itemName("dollarsz"),
			["peso"] = itemWeight("dollarsz"),
			["index"] = itemIndex("dollarsz"),
			["days"] = 1,
			["durability"] = 0
		}

		TriggerClientEvent("inventory:dropInsert",-1,gridZone,numberSelect,dropList[gridZone][numberSelect])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMPICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.itemPickup(pickupId,pickupAmount,pickupSlot,gridZone)
	local source = source
	local dropId = tostring(pickupId)
	local user_id = vRP.getUserId(source)
	if user_id then
		if dropTimer[dropId] == nil then
			dropTimer[dropId] = 1

			if dropList[gridZone] == nil then
				return
			end

			if dropList[gridZone][dropId] == nil then
				TriggerClientEvent("inventory:Update",source,"updateMochila")
				return
			else
				if dropList[gridZone][dropId] ~= nil then
					if (vRP.inventoryWeight(user_id) + (itemWeight(dropList[gridZone][dropId]["key"]) * parseInt(pickupAmount))) <= vRP.getBackpack(user_id) then
						if dropList[gridZone][dropId] == nil or dropList[gridZone][dropId]["amount"] < pickupAmount then
							TriggerClientEvent("inventory:Update",source,"updateMochila")
							return
						end

						if vRP.checkMaxItens(user_id,dropList[gridZone][dropId]["key"],pickupAmount) then
							TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
							TriggerClientEvent("inventory:Update",source,"updateMochila")
							return
						end

						if dropList[gridZone] then
							if dropList[gridZone][dropId] then
								local inventory = vRP.userInventory(user_id)
								if inventory[tostring(pickupSlot)] and dropList[gridZone][dropId]["key"] then
									if inventory[tostring(pickupSlot)]["item"] == dropList[gridZone][dropId]["key"] then
										vRP.giveInventoryItem(user_id,dropList[gridZone][dropId]["key"],pickupAmount,false,pickupSlot)
									else
										vRP.giveInventoryItem(user_id,dropList[gridZone][dropId]["key"],pickupAmount,false)
									end
								else
									if dropList[gridZone][dropId] then
										vRP.giveInventoryItem(user_id,dropList[gridZone][dropId]["key"],pickupAmount,false,pickupSlot)
									end
								end

								TriggerClientEvent("inventory:Update",source,"updateMochila")

								dropList[gridZone][dropId]["amount"] = dropList[gridZone][dropId]["amount"] - pickupAmount

								if dropList[gridZone][dropId]["amount"] <= 0 then
									TriggerClientEvent("inventory:dropRemove",-1,gridZone,dropId)
									dropList[gridZone][dropId] = nil
								else
									TriggerClientEvent("inventory:dropInsert",-1,gridZone,dropId,dropList[gridZone][dropId])
								end
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
						TriggerClientEvent("inventory:Update",source,"updateMochila")
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.useItem(slot,rAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if rAmount == nil then rAmount = 1 end
		if rAmount <= 0 then rAmount = 1 end

		local amountItens = parseInt(rAmount)

		if activeItens[user_id] == nil and not vCLIENT.enterVehicle(source) then
			local inventory = vRP.userInventory(user_id)
			if not inventory[tostring(slot)] or inventory[tostring(slot)]["item"] == nil then
				return
			end

			local splitName = splitString(inventory[tostring(slot)]["item"],"-")
			local totalName = inventory[tostring(slot)]["item"]
			local nameItem = splitName[1]

			if splitName[2] ~= nil then
				if vRP.checkBroken(totalName) then
					TriggerClientEvent("Notify",source,"vermelho","Item quebrado.",5000)
					return
				end
			end

			if vCLIENT.checkWater(source) and nameItem ~= "soap" then
				return
			end

			if vPLAYER.getHandcuff(source) and nameItem ~= "lockpick" then
				return
			end

			if itemType(totalName) == "Armamento" then
				if vRPC.inVehicle(source) then
					if not itemVehicle(totalName) then
						return
					end
				end

				local checkWeapon = vCLIENT.checkWeapon(source)
				if checkWeapon then
					local weaponStatus,weaponAmmo,hashItem = vCLIENT.storeWeaponHands(source)
					if weaponStatus then
						local wHash = GetHashKey(hashItem)
						if weaponHashs[wHash] then
							if parseInt(weaponAmmo) <= 0 then
								weaponAmmo = 0
							end

							ammoPlayers[user_id][weaponHashs[wHash]] = parseInt(weaponAmmo)
						end

						TriggerClientEvent("itensNotify",source,{ "guardou",itemIndex(hashItem),1,itemName(hashItem) })
					end
				else
					local wHash = GetHashKey(nameItem)
					if weaponHashs[wHash] then
						if ammoPlayers[user_id][weaponHashs[wHash]] == nil then
							ammoPlayers[user_id][weaponHashs[wHash]] = 0
						end
					end

					if vCLIENT.putWeaponHands(source,nameItem,ammoPlayers[user_id][weaponHashs[wHash]] or 0) then
						TriggerClientEvent("itensNotify",source,{ "equipou",itemIndex(totalName),1,itemName(totalName) })
					end
				end
			return end

			if itemType(totalName) == "Munição" then
				local checkWeapon,weaponHash,weaponAmmo = vCLIENT.rechargeCheck(source,nameItem)

				if checkWeapon then
					if nameItem ~= weaponHashs[weaponHash] then
						return
					end

					if weaponHashs[weaponHash] then
						if vRP.tryGetInventoryItem(user_id,totalName,amountItens,false,slot) then
							if parseInt(weaponAmmo) <= 0 then
								weaponAmmo = 0
							end

							ammoPlayers[user_id][nameItem] = parseInt(weaponAmmo) + amountItens

							TriggerClientEvent("itensNotify",source,{ "equipou",itemIndex(totalName),amountItens,itemName(totalName) })
							vCLIENT.rechargeWeapon(source,weaponHash,parseInt(ammoPlayers[user_id][nameItem]))
							TriggerClientEvent("inventory:Update",source,"updateMochila")
						end
					end
				end
			return end

			if itemType(totalName) == "Usável" or itemType(totalName) == "Animal" then
				if nameItem == "bullguer01" or nameItem == "bullguer02" or nameItem == "bullguer03" or nameItem == "bullguer04" or nameItem == "bullguer05" or nameItem == "bullguer06" or nameItem == "bullguer07" or nameItem == "bullguer08" or nameItem == "bullguer09" or nameItem == "bullguer10" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,30)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "bullguer11" or nameItem == "bullguer12" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,20)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "bullguer13" or nameItem == "bullguer14" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_sandwich_01",49,18905,0.13,0.05,0.02,-50.0,16.0,60.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,25)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "bullguer15" or nameItem == "bullguer16" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,25)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "bullguer17" or nameItem == "bullguer18" or nameItem == "bullguer19" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,30)
								vRP.generateItem(user_id,"emptybottle",1)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "newgarage" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,false,slot) then
						vRP.execute("characters/updateGarages",{ id = parseInt(user_id) })
						TriggerClientEvent("inventory:Update",source,"updateMochila")
						TriggerClientEvent("Notify",source,"verde","Garagem liberada.",5000)
					end
				return end

				if nameItem == "newprops" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,false,slot) then
						vRP.execute("characters/updateHomes",{ id = parseInt(user_id) })
						TriggerClientEvent("inventory:Update",source,"updateMochila")
						TriggerClientEvent("Notify",source,"verde","Propriedade liberada.",5000)
					end
				return end

				if nameItem == "newchars" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,false,slot) then
						local identity = vRP.userIdentity(user_id)
						TriggerClientEvent("inventory:Update",source,"updateMochila")
						vRP.execute("accounts/infosUpdatechars",{ steam = identity["steam"] })
						TriggerClientEvent("Notify",source,"verde","Personagem liberado.",5000)
					end
				return end

				if nameItem == "wheelchair" then
					local plateVehicle = "WCH"..parseInt(math.random(10000,99999) + user_id)
					TriggerEvent("plateHardness",plateVehicle,1)
					TriggerEvent("plateEveryone",plateVehicle)
					vCLIENT.wheelChair(source,plateVehicle)
				return end

				if nameItem == "rottweiler01" or nameItem == "rottweiler02" or nameItem == "rottweiler03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_rottweiler")
				return end

				if nameItem == "husky01" or nameItem == "husky02" or nameItem == "husky03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_husky")
				return end

				if nameItem == "shepherd01" or nameItem == "shepherd02" or nameItem == "shepherd03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_shepherd")
				return end

				if nameItem == "retriever01" or nameItem == "retriever02" or nameItem == "retriever03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_retriever")
				return end

				if nameItem == "poodle01" or nameItem == "poodle02" or nameItem == "poodle03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_poodle")
				return end

				if nameItem == "pug01" or nameItem == "pug02" or nameItem == "pug03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_pug")
				return end

				if nameItem == "westy01" or nameItem == "westy02" or nameItem == "westy03" then
					TriggerClientEvent("dynamic:animalSpawn",source,"a_c_westy")
				return end

				if nameItem == "hat" then
					TriggerClientEvent("skinshop:setHat",source)
				return end

				if nameItem == "mask" then
					TriggerClientEvent("skinshop:setMask",source)
				return end

				if nameItem == "gloves" then
					TriggerClientEvent("skinshop:setArms",source)
				return end

				if nameItem == "glasses" then
					TriggerClientEvent("skinshop:setGlasses",source)
				return end

				if nameItem == "homecont0"..string.sub(totalName,10,10) then
					TriggerClientEvent("inventory:Close",source)
					TriggerEvent("homes:propItem",source,totalName,string.sub(totalName,10,10))
				return end

				if nameItem == "namechange" then
					TriggerClientEvent("inventory:Close",source)

					local name = vRP.prompt(source,"Primeiro Nome:","")
					local name2 = vRP.prompt(source,"Segundo Nome:","")
					if name == "" or name2 == "" then
						return
					end

					if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
						vRP.execute("characters/updateName",{ name = name, name2 = name2, user_id = parseInt(user_id) })
						TriggerClientEvent("Notify",source,"verde","Identidade atualizada.",5000)
						TriggerClientEvent("inventory:Update",source,"updateMochila")
					end
				return end

				if nameItem == "chip" then
					TriggerClientEvent("inventory:Close",source)

					local firstNumber = vRP.prompt(source,"Três primeiros digitos:","")
					local lastNumber = vRP.prompt(source,"Três ultimos digitos:","")
					if firstNumber == "" or lastNumber == "" then
						return
					end

					local initCheck = sanitizeString(firstNumber,"0123456789",true)
					local finiCheck = sanitizeString(lastNumber,"0123456789",true)

					if string.len(initCheck) == 3 and string.len(finiCheck) == 3 then
						if not vRP.userPhone(firstNumber.."-"..lastNumber) then
							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.execute("characters/updatePhone",{ phone = firstNumber.."-"..lastNumber, id = parseInt(user_id) })
								TriggerEvent("smartphone:updatePhoneNumber",user_id,firstNumber.."-"..lastNumber)
								TriggerClientEvent("Notify",source,"verde","Telefone atualizado.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","Número escolhido já possui um proprietário.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","O número telefônico deve conter 6 dígitos e somente números.",5000)
					end
				return end

				if nameItem == "c4" then
					if not vRPC.inVehicle(source) then
						local stockNet = exports["stockade"]:stockadeNet()
						local vehicle = vCLIENT.checkStockade(source,stockNet)
						if vehicle then
							TriggerEvent("stockade:explodeVehicle")
							TriggerClientEvent("Progress",source,7000)
							TriggerClientEvent("inventory:Close",source)
							vRP.removeInventoryItem(user_id,totalName,1,false)
							TriggerClientEvent("inventory:blockButtons",source,true)
							vRPC.playAnim(source,false,{"anim@heists@ornate_bank@thermal_charge_heels","thermal_charge"},true)

							local ped = GetPlayerPed(source)
							local coords = GetEntityCoords(ped)
							local policeResult = vRP.numPermission("Police")
							for k,v in pairs(policeResult) do
								async(function()
									TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Roubo a Carro Forte", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vehicleName("stockade"), time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
								end)
							end

							Citizen.Wait(7000)

							TriggerClientEvent("inventory:blockButtons",source,false)
							vRPC.stopAnim(source,false)
						end
					end
				return end

				if nameItem == "dices" then
					TriggerClientEvent("inventory:Close",source)

					local diceRandom = math.random(6)
					local identity = vRP.userIdentity(user_id)
					TriggerClientEvent("chatME",source,"^3* "..identity["name"].." ... tirou ^1"..diceRandom.."^3 em um dado de ^16^3 lados.")

					local players = vRPC.nearestPlayers(source,5)
					for _,v in pairs(players) do
						TriggerClientEvent("chatME",v[2],"^3* "..identity["name"].." ... tirou ^1"..diceRandom.."^3 em um dado de ^16^3 lados.")
					end
				return end

				if nameItem == "deck" then
					TriggerClientEvent("inventory:Close",source)

					local card = math.random(13)
					local cards = { "A","2","3","4","5","6","7","8","9","10","J","Q","K" }

					local naipe = math.random(4)
					local naipes = { "^8♣","^8♠","^9♦","^9♥" }

					local identity = vRP.userIdentity(user_id)
					TriggerClientEvent("chatME",source,"^3* "..identity["name"].." ... puxou do baralho um "..cards[card]..naipes[naipe])

					local players = vRPC.nearestPlayers(source,5)
					for _,v in pairs(players) do
						TriggerClientEvent("chatME",v[2],"^3* "..identity["name"].." ... puxou do baralho um "..cards[card]..naipes[naipe])
					end
				return end

				if nameItem == "bandage" then
					if (healthItens[user_id] == nil or GetGameTimer() > healthItens[user_id]) then
						if vRP.getHealth(source) > 101 and vRP.getHealth(source) < 200 then
							activeItens[user_id] = 10
							TriggerClientEvent("Progress",source,10000)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)
							vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									vRPC.stopAnim(source,false)
									TriggerClientEvent("inventory:blockButtons",source,false)

									if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
										TriggerClientEvent("sounds:source",source,"bandage",0.5)
										healthItens[user_id] = GetGameTimer() + 60000
										vRP.upgradeStress(user_id,3)
										vRPC.updateHealth(source,15)
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					else
						local healTimers = parseInt((healthItens[user_id] - GetGameTimer()) / 1000)
						TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..healTimers.." segundos</b>.",5000)
					end
				return end

				if nameItem == "analgesic" or nameItem == "oxy" then
					if (healthItens[user_id] == nil or GetGameTimer() > healthItens[user_id]) then
						if vRP.getHealth(source) > 101 and vRP.getHealth(source) < 200 then
							activeItens[user_id] = 3
							TriggerClientEvent("Progress",source,3000)
							TriggerClientEvent("inventory:Close",source)
							vRPC.playAnim(source,true,{"mp_suicide","pill"},true)
							TriggerClientEvent("inventory:blockButtons",source,true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									vRPC.stopAnim(source,false)
									TriggerClientEvent("inventory:blockButtons",source,false)

									if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
										healthItens[user_id] = GetGameTimer() + 30000
										vRP.upgradeStress(user_id,2)
										vRPC.updateHealth(source,8)
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"azul","Não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					else
						local healTimers = parseInt((healthItens[user_id] - GetGameTimer()) / 1000)
						TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..healTimers.." segundos</b>.",5000)
					end
				return end

				if nameItem == "soap" then
					if vPLAYER.checkSoap(source) then
						activeItens[user_id] = 30
						TriggerClientEvent("Progress",source,30000)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:blockButtons",source,true)
						vRPC.playAnim(source,false,{"amb@world_human_bum_wash@male@high@base","base"},true)

						repeat
							if activeItens[user_id] == 0 then
								activeItens[user_id] = nil
								vRPC.removeObjects(source)
								TriggerClientEvent("inventory:blockButtons",source,false)

								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									vPLAYER.cleanResidual(source)
								end
							end

							Citizen.Wait(100)
						until activeItens[user_id] == nil
					end
				return end

				if nameItem == "joint" then
					local consultItem = vRP.getInventoryItemAmount(user_id,"lighter")
					if consultItem[1] <= 0 then
						return
					end

					activeItens[user_id] = 30
					TriggerClientEvent("Progress",source,30000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.weedTimer(user_id,1)
								vRP.downgradeHunger(user_id,5)
								vRP.downgradeThirst(user_id,5)
								vRP.downgradeStress(user_id,20)
								vPLAYER.movementClip(source,"move_m@shadyped@a")
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "backpack" then
					if vRP.getBackpack(user_id) >= 100 then
						return
					end

					activeItens[user_id] = 30
					TriggerClientEvent("Progress",source,30000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.setBackpack(user_id)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "lean" then
					activeItens[user_id] = 3
					TriggerClientEvent("Progress",source,3000)
					TriggerClientEvent("inventory:Close",source)
					vRPC.playAnim(source,true,{"mp_suicide","pill"},true)
					TriggerClientEvent("inventory:blockButtons",source,true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.chemicalTimer(user_id,10)
								vRP.downgradeStress(user_id,25)
								TriggerClientEvent("cleanEffectDrugs",source)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "ecstasy" then
					activeItens[user_id] = 3
					TriggerClientEvent("Progress",source,3000)
					TriggerClientEvent("inventory:Close",source)
					vRPC.playAnim(source,true,{"mp_suicide","pill"},true)
					TriggerClientEvent("inventory:blockButtons",source,true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.chemicalTimer(user_id,10)
								TriggerClientEvent("setEcstasy",source)
								TriggerClientEvent("setEnergetic",source,10,1.35)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "cocaine" then
					activeItens[user_id] = 5
					TriggerClientEvent("Progress",source,5000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.chemicalTimer(user_id,10)
								TriggerClientEvent("setCocaine",source)
								TriggerClientEvent("setEnergetic",source,25,1.25)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "meth" then
					if armorsItens[user_id] then
						if GetGameTimer() < armorsItens[user_id] then
							local armorTimers = parseInt((armorsItens[user_id] - GetGameTimer()) / 1000)
							TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..armorTimers.." segundos</b>.",5000)
							return
						end
					end

					activeItens[user_id] = 10
					TriggerClientEvent("Progress",source,10000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								armorsItens[user_id] = GetGameTimer() + 60000
								TriggerClientEvent("setMeth",source)
								vRP.chemicalTimer(user_id,10)
								vRPC.setArmour(source,10)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "cigarette" then
					local consultItem = vRP.getInventoryItemAmount(user_id,"lighter")
					if consultItem[1] <= 0 then
						return
					end

					activeItens[user_id] = 60
					TriggerClientEvent("Progress",source,60000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.downgradeStress(user_id,15)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "vape" then
					activeItens[user_id] = 60
					TriggerClientEvent("Progress",source,60000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","ba_prop_battle_vape_01",49,18905,0.08,-0.00,0.03,-150.0,90.0,-10.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRP.downgradeStress(user_id,15)
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "medkit" then
					if (healthItens[user_id] == nil or GetGameTimer() > healthItens[user_id]) then
						if vRP.getHealth(source) > 101 and vRP.getHealth(source) < 200 then
							activeItens[user_id] = 20
							TriggerClientEvent("Progress",source,20000)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)
							vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									vRPC.stopAnim(source,false)
									TriggerClientEvent("inventory:blockButtons",source,false)

									if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
										healthItens[user_id] = GetGameTimer() + 120000
										TriggerClientEvent("resetBleeding",source)
										vRPC.updateHealth(source,40)
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					else
						local healTimers = parseInt((healthItens[user_id] - GetGameTimer()) / 1000)
						TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..healTimers.." segundos</b>.",5000)
					end
				return end

				if nameItem == "gauze" then
					activeItens[user_id] = 5
					TriggerClientEvent("Progress",source,5000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								TriggerClientEvent("sounds:source",source,"bandage",0.5)
								TriggerClientEvent("resetBleeding",source)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "binoculars" then
					local ped = GetPlayerPed(source)
					if GetSelectedPedWeapon(ped) ~= GetHashKey("WEAPON_UNARMED") then
						return
					end

					activeItens[user_id] = 5
					TriggerClientEvent("Progress",source,5000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							TriggerClientEvent("useBinoculos",source)
							TriggerClientEvent("inventory:blockButtons",source,false)
							vRPC.createObjects(source,"amb@world_human_binoculars@male@enter","enter","prop_binoc_01",50,28422)
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "camera" then
					local ped = GetPlayerPed(source)
					if GetSelectedPedWeapon(ped) ~= GetHashKey("WEAPON_UNARMED") then
						return
					end

					activeItens[user_id] = 5
					TriggerClientEvent("Progress",source,5000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							TriggerClientEvent("useCamera",source)
							TriggerClientEvent("inventory:blockButtons",source,false)
							vRPC.createObjects(source,"amb@world_human_paparazzi@male@base","base","prop_pap_camera_01",49,28422)
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "adrenaline" then
					local distance = vCLIENT.adrenalineDistance(source)
					local parAmount = vRP.numPermission("Paramedic")
					if parseInt(#parAmount) > 0 and not distance then
						return
					end

					local otherPlayer = vRPC.nearestPlayer(source,2)
					if otherPlayer then
						local nuser_id = vRP.getUserId(otherPlayer)
						if nuser_id then
							if vRP.getHealth(otherPlayer) <= 101 then
								activeItens[user_id] = 15
								vRPC.stopActived(source)
								TriggerClientEvent("Progress",source,15000)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:blockButtons",source,true)
								vRPC.playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

								repeat
									if activeItens[user_id] == 0 then
										activeItens[user_id] = nil
										vRPC.removeObjects(source)
										TriggerClientEvent("inventory:blockButtons",source,false)

										if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
											vRP.upgradeThirst(user_id,10)
											vRP.upgradeHunger(user_id,10)
											vRPC.revivePlayer(otherPlayer,110)
											TriggerClientEvent("resetBleeding",otherPlayer)
										end
									end

									Citizen.Wait(100)
								until activeItens[user_id] == nil
							end
						end
					end
				return end

				if nameItem == "teddy" then
					TriggerClientEvent("inventory:Close",source)
					vRPC.createObjects(source,"impexp_int-0","mp_m_waremech_01_dual-0","v_ilev_mr_rasberryclean",49,24817,-0.20,0.46,-0.016,-180.0,-90.0,0.0)
				return end

				if nameItem == "rose" then
					TriggerClientEvent("inventory:Close",source)
					vRPC.createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.13,0.15,0.0,-100.0,0.0,-20.0)
				return end

				if nameItem == "firecracker" then
					if not vRPC.inVehicle(source) and vCLIENT.checkCracker(source) then
						activeItens[user_id] = 3
						TriggerClientEvent("Progress",source,3000)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:blockButtons",source,true)
						vRPC.playAnim(source,false,{"anim@mp_fireworks","place_firework_3_box"},true)

						repeat
							if activeItens[user_id] == 0 then
								activeItens[user_id] = nil
								vRPC.stopAnim(source,false)
								TriggerClientEvent("inventory:blockButtons",source,false)

								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									TriggerClientEvent("inventory:Firecracker",source)
								end
							end

							Citizen.Wait(100)
						until activeItens[user_id] == nil
					end
				return end

				if nameItem == "gsrkit" then
					local otherPlayer = vRPC.nearestPlayer(source,2)
					if otherPlayer then
						if vPLAYER.getHandcuff(otherPlayer) then
							activeItens[user_id] = 10
							TriggerClientEvent("Progress",source,10000)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									TriggerClientEvent("inventory:blockButtons",source,false)

									if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
										local checkStatus = vPLAYER.gsrCheck(otherPlayer)
										if checkStatus then
											TriggerClientEvent("Notify",source,"verde","Resultado positivo.",5000)
										else
											TriggerClientEvent("Notify",source,"amarelo","Resultado negativo.",3000)
										end
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						end
					end
				return end

				if nameItem == "gdtkit" then
					local otherPlayer = vRPC.nearestPlayer(source,2)
					if otherPlayer then
						local nuser_id = vRP.getUserId(otherPlayer)
						if nuser_id then
							activeItens[user_id] = 10
							TriggerClientEvent("Progress",source,10000)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									TriggerClientEvent("inventory:blockButtons",source,false)

									if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
										local weed = vRP.weedReturn(nuser_id)
										local chemical = vRP.chemicalReturn(nuser_id)
										local alcohol = vRP.alcoholReturn(nuser_id)

										local chemStr = ""
										local alcoholStr = ""
										local weedStr = ""

										if chemical == 0 then
											chemStr = "Nenhum"
										elseif chemical == 1 then
											chemStr = "Baixo"
										elseif chemical == 2 then
											chemStr = "Médio"
										elseif chemical >= 3 then
											chemStr = "Alto"
										end

										if alcohol == 0 then
											alcoholStr = "Nenhum"
										elseif alcohol == 1 then
											alcoholStr = "Baixo"
										elseif alcohol == 2 then
											alcoholStr = "Médio"
										elseif alcohol >= 3 then
											alcoholStr = "Alto"
										end

										if weed == 0 then
											weedStr = "Nenhum"
										elseif weed == 1 then
											weedStr = "Baixo"
										elseif weed == 2 then
											weedStr = "Médio"
										elseif weed >= 3 then
											weedStr = "Alto"
										end

										TriggerClientEvent("Notify",source,"azul","<b>Químicos:</b> "..chemStr.."<br><b>Álcool:</b> "..alcoholStr.."<br><b>Drogas:</b> "..weedStr,8000)
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						end
					end
				return end

				if nameItem == "vest" then
					local ped = GetPlayerPed(source)
					local coords = GetEntityCoords(ped)
					local distance = #(coords - vector3(487.31,-997.1,30.68))
					if distance > 3 then
						if armorsItens[user_id] then
							if GetGameTimer() < armorsItens[user_id] then
								local armorTimers = parseInt((armorsItens[user_id] - GetGameTimer()) / 1000)
								TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..armorTimers.." segundos</b>.",5000)
								return
							end
						end
					end

					activeItens[user_id] = 30
					TriggerClientEvent("Progress",source,30000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								armorsItens[user_id] = GetGameTimer() + (30 * 60000)
								vRPC.setArmour(source,100)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "GADGET_PARACHUTE" then
					activeItens[user_id] = 5
					TriggerClientEvent("Progress",source,5000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vCLIENT.parachuteColors(source)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "hardness" then
					if vRPC.inVehicle(source) then
						local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,4)
						if vehicle then
							activeItens[user_id] = 60
							vRPC.stopActived(source)
							TriggerClientEvent("Progress",source,60000)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)
							vRPC.playAnim(source,true,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									vRPC.stopAnim(source,false)
									TriggerClientEvent("inventory:blockButtons",source,false)

									if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
										TriggerClientEvent("hud:plateHardness",-1,vehPlate,1)
										vRP.execute("vehicles/updateHardness",{ vehicle = vehName, plate = vehPlate, hardness = 1 })
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						end
					end
				return end

				if nameItem == "toolbox" then
					if not vRPC.inVehicle(source) then
						local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock = vRPC.vehList(source,4)
						if vehicle then
							vRPC.stopActived(source)
							activeItens[user_id] = 100
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)
							vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

							TriggerClientEvent("player:syncHoodOptions",-1,vehNet,"open")

							local taskResult = vTASKBAR.taskMechanic(source)
							if taskResult then
								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									TriggerClientEvent("inventory:repairVehicle",-1,vehNet,vehPlate)
									vRP.upgradeStress(user_id,2)
								end
							end

							TriggerClientEvent("player:syncHoodOptions",-1,vehNet,"close")

							TriggerClientEvent("inventory:blockButtons",source,false)
							vRPC.stopAnim(source,false)
							activeItens[user_id] = nil
						end
					end
				return end

				if nameItem == "graphite01" or nameItem == "graphite02" or nameItem == "graphite03" then
					if not vRPC.inVehicle(source) then
						local vehicle,vehNet,playerAround = vRPC.vehAround(source)
						if vehicle then
							activeItens[user_id] = amountItens
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("Progress",source,1000 * amountItens)
							TriggerClientEvent("inventory:blockButtons",source,true)
							TriggerClientEvent("player:syncHoodOptions",-1,vehNet,"open")
							vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

							repeat
								if activeItens[user_id] == 0 then
									activeItens[user_id] = nil
									vRPC.stopAnim(source,false)
									TriggerClientEvent("inventory:blockButtons",source,false)

									TriggerClientEvent("player:syncHoodOptions",-1,vehNet,"close")

									if vRP.tryGetInventoryItem(user_id,totalName,amountItens,true,slot) then
										TriggerEvent("engine:applyBrakes",totalName,vehNet,amountItens,playerAround)
									end
								end

								Citizen.Wait(100)
							until activeItens[user_id] == nil
						end
					end
				return end

				if nameItem == "lockpick" then
					if not vPLAYER.getHandcuff(source) then
						local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth,vehClass = vRPC.vehList(source,4)
						if vehicle then
							if vehClass == 15 or vehClass == 16 or vehClass == 19 or vehName == "stockade" then
								return
							end

							if vRPC.inVehicle(source) then
								vRPC.stopActived(source)
								activeItens[user_id] = 100
								vGARAGE.startAnimHotwired(source)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:blockButtons",source,true)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									if math.random(100) >= 20 then
										vRP.upgradeStress(user_id,2)
										TriggerEvent("plateEveryone",vehPlate)
										TriggerEvent("platePlayers",vehPlate,user_id)
									end

									if math.random(100) >= 75 then
										local ped = GetPlayerPed(source)
										local coords = GetEntityCoords(ped)

										local policeResult = vRP.numPermission("Police")
										for k,v in pairs(policeResult) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Roubo de Veículo", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vehicleName(vehName).." - "..vehPlate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
											end)
										end
									end
								end

								if parseInt(math.random(1000)) >= 900 then
									vRP.generateItem(user_id,"lockpick2",1,false)
									vRP.removeInventoryItem(user_id,totalName,1,false)
									TriggerClientEvent("itensNotify",source,{ "quebrou","lockpick",1,"Lockpick" })
								end

								TriggerClientEvent("inventory:blockButtons",source,false)
								vGARAGE.stopAnimHotwired(source,vehicle)
								activeItens[user_id] = nil
							else
								vRPC.stopActived(source)
								activeItens[user_id] = 100
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:blockButtons",source,true)
								vRPC.playAnim(source,false,{"missfbi_s4mop","clean_mop_back_player"},true)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									if math.random(100) >= 75 then
										vRP.upgradeStress(user_id,2)
										TriggerEvent("plateEveryone",vehPlate)
										TriggerClientEvent("garages:vehicleLock",-1,vehNet,vehLock)
									end

									if math.random(100) >= 75 then
										local ped = GetPlayerPed(source)
										local coords = GetEntityCoords(ped)

										local policeResult = vRP.numPermission("Police")
										for k,v in pairs(policeResult) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Roubo de Veículo", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vehicleName(vehName).." - "..vehPlate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
											end)
										end
									end
								end

								if parseInt(math.random(1000)) >= 900 then
									vRP.generateItem(user_id,"lockpick2",1,false)
									vRP.removeInventoryItem(user_id,totalName,1,false)
									TriggerClientEvent("itensNotify",source,{ "quebrou","lockpick",1,"Lockpick" })
								end

								TriggerClientEvent("inventory:blockButtons",source,false)
								vRPC.stopAnim(source,false)
								activeItens[user_id] = nil
							end
						else
							if vRP.wantedReturn(user_id) then
								return
							end

							local homeName = exports["homes"]:homesTheft(source)
							if homeName then
								vRPC.stopActived(source)
								activeItens[user_id] = 100
								vRP.upgradeStress(user_id,2)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:blockButtons",source,true)
								vRPC.playAnim(source,false,{"missheistfbi3b_ig7","lift_fibagent_loop"},false)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									exports["homes"]:enterHomes(source,user_id,homeName,true)
								else
									exports["homes"]:resetTheft(homeName)
								end

								if parseInt(math.random(1000)) >= 900 then
									vRP.generateItem(user_id,"lockpick2",1,false)
									vRP.removeInventoryItem(user_id,totalName,1,false)
									TriggerClientEvent("itensNotify",source,{ "quebrou","lockpick",1,"Lockpick" })
								end

								TriggerClientEvent("inventory:blockButtons",source,false)
								vRPC.stopAnim(source,false)
								activeItens[user_id] = nil
							end
						end
					else
						activeItens[user_id] = 100
						TriggerClientEvent("inventory:blockButtons",source,true)
						TriggerClientEvent("player:blockCommands",source,true)

						local taskResult = vTASKBAR.taskLockpick(source)
						if taskResult then
							vPLAYER.removeHandcuff(source)
							vRPC.stopAnim(source,false)
						end

						if parseInt(math.random(100)) >= 50 then
							vRP.generateItem(user_id,"lockpick2",1,false)
							vRP.removeInventoryItem(user_id,totalName,1,false)
							TriggerClientEvent("itensNotify",source,{ "quebrou","lockpick",1,"Lockpick" })
						end

						TriggerClientEvent("player:blockCommands",source,false)
						TriggerClientEvent("inventory:blockButtons",source,false)
						activeItens[user_id] = nil
					end
				return end

				if nameItem == "energetic" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","prop_energy_drink",49,60309,0.0,0.0,0.0,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								TriggerClientEvent("setEnergetic",source,25,1.15)
								vRP.upgradeStress(user_id,5)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "absolut" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.alcoholTimer(user_id,1)
								vRP.upgradeThirst(user_id,20)
								TriggerClientEvent("setDrunkTime",source,90)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "hennessy" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.alcoholTimer(user_id,1)
								vRP.upgradeThirst(user_id,20)
								TriggerClientEvent("setDrunkTime",source,300)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "chandon" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.alcoholTimer(user_id,1)
								vRP.upgradeThirst(user_id,20)
								TriggerClientEvent("setDrunkTime",source,300)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "dewars" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.alcoholTimer(user_id,1)
								vRP.upgradeThirst(user_id,20)
								TriggerClientEvent("setDrunkTime",source,300)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "orangejuice" or nameItem == "passionjuice" or nameItem == "tangejuice" or nameItem == "grapejuice" or nameItem == "strawberryjuice" or nameItem == "bananajuice" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,50)
								vRP.generateItem(user_id,"emptybottle",1)

								if nameItem == "passionjuice" then
									vRP.downgradeStress(user_id,10)
								end
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "water" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,20)
								vRP.generateItem(user_id,"emptybottle",1)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "sinkalmy" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,5)
								vRP.chemicalTimer(user_id,3)
								vRP.downgradeStress(user_id,25)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "ritmoneury" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,5)
								vRP.chemicalTimer(user_id,3)
								vRP.downgradeStress(user_id,40)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "dirtywater" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRPC.downHealth(source,20)
								vRP.upgradeStress(user_id,3)
								vRP.upgradeThirst(user_id,20)
								vRP.generateItem(user_id,"emptybottle",1)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "cola" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","prop_ecola_can",49,60309,0.01,0.01,0.05,0.0,0.0,90.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,15)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "soda" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","ng_proc_sodacan_01b",49,60309,0.0,0.0,-0.04,0.0,0.0,130.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeThirst(user_id,15)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "fishingrod" then
					local enemyLocates = false
					local ped = GetPlayerPed(source)
					local coords = GetEntityCoords(ped)

					for k,v in pairs(fishCoords) do
						local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
						if distance <= v["dist"] then
							enemyLocates = k
						end
					end

					if enemyLocates then
						activeItens[user_id] = 100
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:blockButtons",source,true)

						if not vCLIENT.fishingAnim(source) then
							vRPC.stopActived(source)
							vRPC.createObjects(source,"amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",49,60309)
						end

						if vTASKBAR.taskFishing(source) then
							local fishRand = math.random(#fishCoords[enemyLocates]["item"])
							local fishSelect = fishCoords[enemyLocates]["item"][fishRand]

							if (vRP.inventoryWeight(user_id) + itemWeight(fishSelect)) <= vRP.getBackpack(user_id) then
								if vRP.tryGetInventoryItem(user_id,"bait",1,false) then
									vRP.generateItem(user_id,fishSelect,1,true)
								else
									TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("bait").."</b>.",5000)
								end
							else
								TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
							end
						end

						TriggerClientEvent("inventory:blockButtons",source,false)
						activeItens[user_id] = nil
					end
				return end

				if nameItem == "emptybottle" then
					local status,style = vCLIENT.checkFountain(source)
					if status then
						if style == "fountain" then
							if vRP.checkMaxItens(user_id,"water",amountItens) then
								TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
								return
							end

							vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
						elseif style == "floor" then
							if vRP.checkMaxItens(user_id,"dirtywater",amountItens) then
								TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
								return
							end

							vRPC.playAnim(source,false,{"amb@world_human_bum_wash@male@high@base","base"},true)
						end

						vRPC.stopActived(source)
						activeItens[user_id] = amountItens * 3
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:blockButtons",source,true)
						TriggerClientEvent("Progress",source,amountItens * 3000)

						repeat
							if activeItens[user_id] == 0 then
								activeItens[user_id] = nil
								vRPC.removeObjects(source)
								TriggerClientEvent("inventory:blockButtons",source,false)

								if (vRP.inventoryWeight(user_id) + (itemWeight(totalName) * parseInt(amountItens))) <= vRP.getBackpack(user_id) then
									if vRP.tryGetInventoryItem(user_id,totalName,amountItens,false,slot) then
										if style == "floor" then
											vRP.generateItem(user_id,"dirtywater",amountItens,true)
										else
											vRP.generateItem(user_id,"water",amountItens,true)
										end
									end
								end
							end

							Citizen.Wait(100)
						until activeItens[user_id] == nil
					end
				return end

				if nameItem == "coffee" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								TriggerClientEvent("setEnergetic",source,15,1.15)
								vRP.upgradeThirst(user_id,15)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "hamburger" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,20)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "hamburger2" or nameItem == "hamburger3" or nameItem == "hamburger4" or nameItem == "hamburger5" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								if nameItem == "hamburger2" then
									vRP.upgradeHunger(user_id,40)
								elseif nameItem == "hamburger3" then
									vRP.upgradeHunger(user_id,50)
								elseif nameItem == "hamburger4" then
									vRP.upgradeHunger(user_id,60)
								elseif nameItem == "hamburger5" then
									vRP.upgradeHunger(user_id,70)
								end
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "hotdog" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,15)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "sandwich" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_sandwich_01",49,18905,0.13,0.05,0.02,-50.0,16.0,60.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,15)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "tacos" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_taco_01",49,18905,0.16,0.06,0.02,-50.0,220.0,60.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,20)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "fries" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,10)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "orange" or nameItem == "banana" or nameItem == "tange" or nameItem == "grape" or nameItem == "strawberry" or nameItem == "tomato" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.upgradeHunger(user_id,3)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "chocolate" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.downgradeStress(user_id,10)
								vRP.upgradeHunger(user_id,10)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "donut" then
					activeItens[user_id] = 15
					vRPC.stopActived(source)
					TriggerClientEvent("Progress",source,15000)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:blockButtons",source,true)
					vRPC.createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_amb_donut",49,28422)

					repeat
						if activeItens[user_id] == 0 then
							activeItens[user_id] = nil
							vRPC.removeObjects(source,"one")
							TriggerClientEvent("inventory:blockButtons",source,false)

							if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
								vRP.downgradeStress(user_id,10)
								vRP.upgradeHunger(user_id,10)
							end
						end

						Citizen.Wait(100)
					until activeItens[user_id] == nil
				return end

				if nameItem == "notepad" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("notepad:createNotepad",source)
					end
				return end

				if nameItem == "tires" then
					if not vRPC.inVehicle(source) then
						local vehicle,vehNet = vRPC.vehList(source,4)
						if vehicle then
							vRPC.stopActived(source)
							activeItens[user_id] = 100
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:blockButtons",source,true)
							vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

							local taskResult = vTASKBAR.taskMechanic(source)
							if taskResult then
								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									TriggerClientEvent("inventory:repairTires",-1,vehNet)
								end
							end

							TriggerClientEvent("inventory:blockButtons",source,false)
							vRPC.stopAnim(source,false)
							activeItens[user_id] = nil
						end
					end
				return end

				if nameItem == "premiumplate" then
					TriggerClientEvent("inventory:Close",source)

					local vehModel = vRP.prompt(source,"Modelo:","")
					if vehModel == "" then
						return
					end

					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehModel) })
					if vehicle[1] then
						local vehPlate = vRP.prompt(source,"Placa:","")
						if vehPlate == "" then
							return
						end

						local namePlate = string.sub(vehPlate,1,8)
						local plateCheck = sanitizeString(namePlate,"abcdefghijklmnopqrstuvwxyz0123456789",true)

						if string.len(plateCheck) ~= 8 then
							TriggerClientEvent("Notify",source,"amarelo","O nome de definição para a placa deve conter 8 caracteres.",5000)
							return
						else
							if vRP.userPlate(namePlate) then
								TriggerClientEvent("Notify",source,"vermelho","A placa escolhida já está sendo registrada em outro veículo.",5000)
								return
							else
								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									vRP.execute("vehicles/plateVehiclesUpdate",{ user_id = parseInt(user_id), vehicle = vehModel, plate = string.upper(namePlate) })
									TriggerClientEvent("Notify",source,"verde","Placa atualizada.",5000)
								end
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","Modelo de veículo não encontrado.",5000)
					end
				return end

				if nameItem == "plate" then
					if vCLIENT.plateVehicle(source) then
						activeItens[user_id] = 10
						TriggerClientEvent("Progress",source,10000)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:blockButtons",source,true)

						repeat
							if activeItens[user_id] == 0 then
								activeItens[user_id] = nil
								TriggerClientEvent("inventory:blockButtons",source,false)

								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									local plate = vRP.generatePlate()
									vCLIENT.plateApply(source,plate)
									TriggerEvent("plateEveryone",plate)
								end
							end

							Citizen.Wait(100)
						until activeItens[user_id] == nil
					end
				return end

				if nameItem == "radio" then
					vRPC.stopActived(source)
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("radio:openSystem",source)
				return end

				if nameItem == "divingsuit" then
					TriggerClientEvent("hud:setDiving",source)
				return end

				if nameItem == "handcuff" then
					if not vRPC.inVehicle(source) then
						local otherPlayer = vRPC.nearestPlayer(source,0.8)
						if otherPlayer then
							if vPLAYER.getHandcuff(otherPlayer) then
								vPLAYER.toggleHandcuff(otherPlayer)
								TriggerClientEvent("sounds:source",source,"uncuff",0.5)
								TriggerClientEvent("sounds:source",otherPlayer,"uncuff",0.5)
								TriggerClientEvent("player:blockCommands",otherPlayer,false)
							else
								TriggerClientEvent("toggleCarry",otherPlayer,source)
								vRPC.playAnim(otherPlayer,false,{"mp_arrest_paired","crook_p2_back_left"},false)
								vRPC.playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)

								Citizen.Wait(3500)

								vRPC.stopAnim(source,false)
								vPLAYER.toggleHandcuff(otherPlayer)
								TriggerClientEvent("inventory:Close",otherPlayer)
								TriggerClientEvent("toggleCarry",otherPlayer,source)
								TriggerClientEvent("sounds:source",source,"cuff",0.5)
								TriggerClientEvent("sounds:source",otherPlayer,"cuff",0.5)
								TriggerClientEvent("player:blockCommands",otherPlayer,true)
							end
						end
					end
				return end

				if nameItem == "hood" then
					local otherPlayer = vRPC.nearestPlayer(source,2)
					if otherPlayer and vPLAYER.getHandcuff(otherPlayer) then
						TriggerClientEvent("hud:toggleHood",otherPlayer)
						TriggerClientEvent("inventory:Close",otherPlayer)
					end
				return end

				if nameItem == "rope" then
					local otherPlayer = vRPC.nearestPlayer(source,2)
					if otherPlayer and (vRP.getHealth(otherPlayer) <= 101 or vPLAYER.getHandcuff(otherPlayer)) then
						TriggerClientEvent("rope:toggleRope",source,otherPlayer)
						TriggerClientEvent("inventory:Close",otherPlayer)
					end
				return end

				if nameItem == "premium01" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
						local identity = vRP.userIdentity(user_id)
						if identity then
							if not vRP.userPremium(user_id) then
								vRP.execute("accounts/setPremium",{ steam = identity["steam"], premium = parseInt(os.time()), predays = 3, priority = 30 })
							else
								vRP.execute("accounts/updatePremium",{ steam = identity["steam"], predays = 3 })

								local infoAccount = vRP.infoAccount(identity["steam"])
								if infoAccount then
									if parseInt(infoAccount["priority"]) < 30 then
										vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 30 })
									end
								end
							end
						end

						TriggerClientEvent("inventory:Update",source,"updateMochila")
					end
				return end

				if nameItem == "premium02" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
						local identity = vRP.userIdentity(user_id)
						if identity then
							if not vRP.userPremium(user_id) then
								vRP.execute("accounts/setPremium",{ steam = identity["steam"], premium = parseInt(os.time()), predays = 7, priority = 45 })
							else
								vRP.execute("accounts/updatePremium",{ steam = identity["steam"], predays = 7 })

								local infoAccount = vRP.infoAccount(identity["steam"])
								if infoAccount then
									if parseInt(infoAccount["priority"]) < 45 then
										vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 45 })
									end
								end
							end
						end

						TriggerClientEvent("inventory:Update",source,"updateMochila")
					end
				return end

				if nameItem == "premium03" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
						local identity = vRP.userIdentity(user_id)
						if identity then
							if not vRP.userPremium(user_id) then
								vRP.execute("accounts/setPremium",{ steam = identity["steam"], premium = parseInt(os.time()), predays = 15, priority = 60 })
							else
								vRP.execute("accounts/updatePremium",{ steam = identity["steam"], predays = 15 })

								local infoAccount = vRP.infoAccount(identity["steam"])
								if infoAccount then
									if parseInt(infoAccount["priority"]) < 60 then
										vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 60 })
									end
								end
							end
						end

						TriggerClientEvent("inventory:Update",source,"updateMochila")
					end
				return end

				if nameItem == "premium04" then
					if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
						local identity = vRP.userIdentity(user_id)
						if identity then
							if not vRP.userPremium(user_id) then
								vRP.execute("accounts/setPremium",{ steam = identity["steam"], premium = parseInt(os.time()), predays = 30, priority = 75 })
							else
								vRP.execute("accounts/updatePremium",{ steam = identity["steam"], predays = 30 })

								local infoAccount = vRP.infoAccount(identity["steam"])
								if infoAccount then
									if parseInt(infoAccount["priority"]) < 75 then
										vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 75 })
									end
								end
							end
						end

						TriggerClientEvent("inventory:Update",source,"updateMochila")
					end
				return end

				if nameItem == "pager" then
					local otherPlayer = vRPC.nearestPlayer(source,2)
					if otherPlayer then
						local nuser_id = vRP.getUserId(otherPlayer)
						if nuser_id then
							if vRP.hasPermission(nuser_id,"Police") then
								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									vRP.removePermission(otherPlayer,"Police")
									TriggerClientEvent("radio:outServers",otherPlayer)
									vRP.updatePermission(nuser_id,"Police","waitPolice")
									TriggerEvent("blipsystem:serviceExit",otherPlayer)
									TriggerClientEvent("police:updateService",otherPlayer,false)
									TriggerClientEvent("Notify",source,"amarelo","Todas as comunicações foram retiradas.",5000)
								end
							end

							if vRP.hasPermission(nuser_id,"Paramedic") then
								if vRP.tryGetInventoryItem(user_id,totalName,1,true,slot) then
									vRP.removePermission(otherPlayer,"Paramedic")
									TriggerClientEvent("radio:outServers",otherPlayer)
									TriggerEvent("blipsystem:serviceExit",otherPlayer)
									vRP.updatePermission(nuser_id,"Paramedic","waitParamedic")
									TriggerClientEvent("Notify",source,"amarelo","Todas as comunicações foram retiradas.",5000)
								end
							end
						end
					end
				return end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if ammoPlayers[user_id] then
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Weapons", value = json.encode(ammoPlayers[user_id]) })
		ammoPlayers[user_id] = nil
	end

	if activeItens[user_id] then
		activeItens[user_id] = nil
	end

	if verifyObjects[user_id] then
		verifyObjects[user_id] = nil
	end

	if healthItens[user_id] then
		healthItens[user_id] = nil
	end

	if armorsItens[user_id] then
		armorsItens[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("inventory:dropList",source,dropList)
	ammoPlayers[user_id] = vRP.userData(user_id,"Weapons")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Cancel")
AddEventHandler("inventory:Cancel",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if activeItens[user_id] ~= nil and activeItens[user_id] > 0 then
			activeItens[user_id] = nil
			vRPC.removeObjects(source)
			vGARAGE.updateHotwired(source,false)
			TriggerClientEvent("Progress",source,1000)
			TriggerClientEvent("inventory:blockButtons",source,false)

			if verifyObjects[user_id] then
				trashTables[verifyObjects[user_id][1]][verifyObjects[user_id][2]] = nil
				verifyObjects[user_id] = nil
			end
		else
			vRPC.removeObjects(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkInventory()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if activeItens[user_id] ~= nil and activeItens[user_id] > 0 then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXISTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkExistWeapon(nameItem,weaponAmmo,equipeNow)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultItem = vRP.getInventoryItemAmount(user_id,nameItem)
		if consultItem[1] <= 0 then
			local wType = itemAmmo(nameItem)

			if ammoPlayers[user_id][wType] then
				if equipeNow then
					ammoPlayers[user_id][wType] = parseInt(weaponAmmo)
				end

				if ammoPlayers[user_id][wType] > 0 then
					vRP.generateItem(user_id,wType,ammoPlayers[user_id][wType])
					TriggerClientEvent("inventory:Update",source,"updateMochila")
					ammoPlayers[user_id][wType] = 0
				end
			end

			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVENTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.preventWeapon(weaponHash,weaponAmmo)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local wHash = GetHashKey(weaponHash)
		if weaponHashs[wHash] then
			if ammoPlayers[user_id][weaponHashs[wHash]] then
				if weaponAmmo > 0 then
					ammoPlayers[user_id][weaponHashs[wHash]] = parseInt(weaponAmmo)
				else
					ammoPlayers[user_id][weaponHashs[wHash]] = nil
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLEARWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:clearWeapons")
AddEventHandler("inventory:clearWeapons",function(user_id)
	if ammoPlayers[user_id] then
		ammoPlayers[user_id] = {}
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:verifyObjects")
AddEventHandler("inventory:verifyObjects",function(entity,service)
	if GetGameTimer() >= updateTrash then
		updateTrash = GetGameTimer() + (120 * 60000)
		trashTables = {}
	end

	local nameEmpty = ""
	if service == "Lixeiro" then
		nameEmpty = "Lixeira"
	elseif service == "Jornaleiro" then
		nameEmpty = "Caixa"
	end

	if entity[1] ~= nil and entity[2] ~= nil and entity[3] ~= nil and entity[4] ~= nil then
		local source = source
		local model = entity[2]
		local coords = entity[4]
		local netObjects = entity[3]
		local user_id = vRP.getUserId(source)

		if user_id and verifyObjects[user_id] == nil and activeItens[user_id] == nil then
			if trashTables[model] == nil then
				trashTables[model] = {}
			end

			if trashTables[model][netObjects] then
				TriggerClientEvent("Notify",source,"amarelo",nameEmpty.." vazia.",5000)
				return
			end

			for k,v in pairs(trashTables[model]) do
				if #(v - coords) <= 0.75 then
					TriggerClientEvent("Notify",source,"amarelo",nameEmpty.." vazia.",5000)
					return
				end
			end

			activeItens[user_id] = 6
			trashTables[model][netObjects] = coords
			TriggerClientEvent("Progress",source,6000)
			TriggerClientEvent("inventory:Close",source)
			verifyObjects[user_id] = { model,netObjects }
			TriggerClientEvent("inventory:blockButtons",source,true)
			vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)

			repeat
				if activeItens[user_id] == 0 then
					activeItens[user_id] = nil
					vRPC.stopAnim(source,false)
					TriggerClientEvent("inventory:blockButtons",source,false)

					local itemSelect = { "",1 }
					local randItem = math.random(250)

					if service == "Lixeiro" then
						if parseInt(randItem) >= 141 and parseInt(randItem) <= 200 then
							itemSelect = { "glassbottle",math.random(2) }
						elseif parseInt(randItem) >= 111 and parseInt(randItem) <= 140 then
							itemSelect = { "plasticbottle",math.random(2) }
						elseif parseInt(randItem) >= 71 and parseInt(randItem) <= 110 then
							itemSelect = { "elastic",math.random(2) }
						elseif parseInt(randItem) >= 41 and parseInt(randItem) <= 70 then
							itemSelect = { "metalcan",1 }
						elseif parseInt(randItem) >= 11 and parseInt(randItem) <= 40 then
							itemSelect = { "battery",1 }
						elseif parseInt(randItem) >= 3 and parseInt(randItem) <= 10 then
							itemSelect = { "fabric",1 }
						elseif parseInt(randItem) <= 2 then
							itemSelect = { "titanium",1 }
						end
					elseif service == "Jornaleiro" then
						if parseInt(randItem) <= 175 then
							itemSelect = { "newspaper",1 }
						end
					end

					if itemSelect[1] == "" then
						TriggerClientEvent("Notify",source,"amarelo",nameEmpty.." vazia.",5000)
					else
						if (vRP.inventoryWeight(user_id) + (itemWeight(itemSelect[1]) * parseInt(itemSelect[2]))) <= vRP.getBackpack(user_id) then
							vRP.generateItem(user_id,itemSelect[1],itemSelect[2],true)
							vRP.upgradeStress(user_id,1)
						else
							TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
							trashTables[model][netObjects] = nil
						end
					end

					verifyObjects[user_id] = nil
				end

				Citizen.Wait(100)
			until activeItens[user_id] == nil
		end
	else
		TriggerClientEvent("Notify",source,"amarelo",nameEmpty.." vazia.",5000)
	end
end)