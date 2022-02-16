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
Tunnel.bindInterface("tablet",cRP)
vCLIENT = Tunnel.getInterface("tablet")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local typeCars = {}
local typeBikes = {}
local typeWorks = {}
local typeRental = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local vehicles = vehicleGlobal()
	for k,v in pairs(vehicles) do
		if v[4] == "cars" then
			table.insert(typeCars,{ k = k, name = v[1], price = v[3], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		elseif v[4] == "bikes" then
			table.insert(typeBikes,{ k = k, name = v[1], price = v[3], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		elseif v[4] == "work" then
			table.insert(typeWorks,{ k = k, name = v[1], price = v[3], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		elseif v[4] == "rental" then
			table.insert(typeRental,{ k = k, name = v[1], price = v[5], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPossuidos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehList = {}
		local vehicles = vRP.query("vehicles/getVehicles",{ user_id = parseInt(user_id) })
		for k,v in pairs(vehicles) do
			local vehicleTax = "Atrasado"
			if os.time() < parseInt(v["tax"] + 24 * 7 * 60 * 60) then
				vehicleTax = minimalTimers(parseInt(86400 * 7 - (os.time() - v["tax"])))
			end

			table.insert(vehList,{ k = v["vehicle"], name = vehicleName(v["vehicle"]), price = parseInt(vehiclePrice(v["vehicle"]) * 0.7), chest = vehicleChest(v["vehicle"]), tax = vehicleTax })
		end

		return vehList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestTax(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
		if vehicle[1] then
			if os.time() >= parseInt(vehicle[1]["tax"] + 24 * 7 * 60 * 60) then
				local vehiclePrice = parseInt(vehiclePrice(vehName) * 0.025)

				if vRP.paymentFull(user_id,vehiclePrice) then
					vRP.execute("vehicles/updateVehiclesTax",{ user_id = parseInt(user_id), vehicle = vehName, tax = os.time() })
					TriggerClientEvent("tablet:Update",source,"requestPossuidos")
				else
					TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestRental(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return
			end

			local vehPrice = vehicleGems(vehName)
			if vRP.request(source,"Comprar o veículo <b>"..vehicleName(vehName).."</b> pagando <b>"..parseFormat(vehPrice).." Gemas</b>?",30) then
				if vRP.paymentGems(user_id,vehPrice) then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
					if vehicle[1] then
						if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
							vRP.execute("vehicles/rentalVehiclesUpdate",{ user_id = parseInt(user_id), vehicle = vehName, days = 30, rental = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..vehicleName(vehName).."</b> atualizado.",5000)
						else
							vRP.execute("vehicles/rentalVehiclesDays",{ user_id = parseInt(user_id), vehicle = vehName, days = 30 })
							TriggerClientEvent("Notify",source,"verde","Adicionado <b>30 Dias</b> de aluguel no veículo <b>"..vehicleName(vehName).."</b>.",5000)
						end
					else
						vRP.execute("vehicles/rentalVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false), rental = parseInt(os.time()), rendays = 30 })
						TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..vehicleName(vehName).."</b> concluído.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Gemas insuficientes.",5000)
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.rentalMoney(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return
			end

			local vehPrice = vehicleGems(vehName) * 1000
			if vRP.request(source,"Comprar o veículo <b>"..vehicleName(vehName).."</b> pagando <b>$"..parseFormat(vehPrice).."</b>?",30) then
				if vRP.paymentFull(user_id,vehPrice) then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
					if vehicle[1] then
						if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
							vRP.execute("vehicles/rentalVehiclesUpdate",{ user_id = parseInt(user_id), vehicle = vehName, days = 30, rental = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..vehicleName(vehName).."</b> atualizado.",5000)
						else
							vRP.execute("vehicles/rentalVehiclesDays",{ user_id = parseInt(user_id), vehicle = vehName, days = 30 })
							TriggerClientEvent("Notify",source,"verde","Adicionado <b>30 Dias</b> de aluguel no veículo <b>"..vehicleName(vehName).."</b>.",5000)
						end
					else
						vRP.execute("vehicles/rentalVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false), rental = parseInt(os.time()), rendays = 30 })
						TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..vehicleName(vehName).."</b> concluído.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBuy(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return
			end

			local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
			if vehicle[1] then
				TriggerClientEvent("Notify",source,"amarelo","Já possui um <b>"..vehicleName(vehName).."</b>.",3000)
				actived[user_id] = nil
				return
			else
				if vehicleType(vehName) == "work" then
					if vRP.paymentFull(user_id,vehiclePrice(vehName)) then
						vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(true) })
						TriggerClientEvent("Notify",source,"verde","Compra concluída.",5000)
					else
						TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
					end
				else
					local vehPrice = vehiclePrice(vehName)
					if vRP.request(source,"Comprar o veículo <b>"..vehicleName(vehName).."</b> pagando <b>$"..parseFormat(vehPrice).."</b>?",30) then
						local maxVehs = vRP.query("vehicles/countVehicles",{ user_id = parseInt(user_id), work = "false" })
						local myGarages = vRP.getInformation(user_id)
						local amountVehs = myGarages[1]["garage"]

						if vRP.userPremium(user_id) then
							amountVehs = amountVehs + 2
						end

						if parseInt(maxVehs[1]["qtd"]) >= parseInt(amountVehs) then
							TriggerClientEvent("Notify",source,"amarelo","Atingiu o máximo de veículos.",3000)
							actived[user_id] = nil
							return
						end

						if vRP.paymentFull(user_id,vehPrice) then
							vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false) })
							TriggerClientEvent("Notify",source,"verde","Compra concluída.",5000)
						else
							TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
						end
					end
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestSell(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehType = vehicleType(vehName)
		if vehType == "work" then
			return false
		end

		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return false
			end

			local vehPrices = vehiclePrice(vehName) * 0.7
			local sellText = "Vender o veículo <b>"..vehicleName(vehName).."</b> por <b>$"..parseFormat(vehPrices).."</b>?"

			if vehType == "rental" then
				sellText = "Remover o veículo de sua lista de possuídos?"
			end

			if vRP.request(source,sellText,30) then
				local vehicles = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
				if vehicles[1] then
					vRP.remSrvdata("custom:"..user_id..":"..vehName)
					vRP.remSrvdata("vehChest:"..user_id..":"..vehName)
					vRP.remSrvdata("vehGloves:"..user_id..":"..vehName)
					vRP.execute("vehicles/removeVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
					TriggerClientEvent("tablet:Update",source,"requestPossuidos")

					if vehType ~= "rental" then
						vRP.addBank(user_id,vehPrices)
						TriggerClientEvent("itensNotify",source,{ "recebeu","dollars",parseFormat(vehPrices),"Dólares" })
					end
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local plateVehs = {}
local numberName = 1000
function cRP.startDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if not vRP.wantedReturn(user_id) then
				local request = vRP.request(source,"Deseja iniciar o teste pagando <b>$50</b>?",60)
				if request then
					if vRP.paymentFull(user_id,50) then
						numberName = numberName + 1
						plateVehs[user_id] = "PDMS"..numberName

						SetPlayerRoutingBucket(source,parseInt(user_id))
						TriggerEvent("plateEveryone",plateVehs[user_id])
						actived[user_id] = nil

						return true,plateVehs[user_id]
					else
						TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
					end
				end
			end

			actived[user_id] = nil
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(user_id)
		if identity then
			TriggerEvent("plateReveryone",plateVehs[user_id])
			SetPlayerRoutingBucket(source,0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.updateVehicles(source,typeCars,typeBikes,typeWorks,typeRental)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if actived[user_id] then
		actived[user_id] = nil
	end

	if plateVehs[user_id] then
		plateVehs[user_id] = nil
	end
end)