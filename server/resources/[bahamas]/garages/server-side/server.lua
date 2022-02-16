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
Tunnel.bindInterface("garages",cRP)
vPLAYER = Tunnel.getInterface("player")
vCLIENT = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehList = {}
local vehPlates = {}
local spawnTimers = {}
local vehHardness = {}
local searchTimers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGELOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local garageLocates = {
	-- Garages
	["1"] = { name = "Garage", payment = false },
	["2"] = { name = "Garage", payment = true },
	["3"] = { name = "Garage", payment = true },
	["4"] = { name = "Garage", payment = true },
	["5"] = { name = "Garage", payment = true },
	["6"] = { name = "Garage", payment = true },
	["7"] = { name = "Garage", payment = true },
	["8"] = { name = "Garage", payment = true },
	["9"] = { name = "Garage", payment = true },
	["10"] = { name = "Garage", payment = true },
	["11"] = { name = "Garage", payment = true },
	["12"] = { name = "Garage", payment = true },
	["13"] = { name = "Garage", payment = true },
	["14"] = { name = "Garage", payment = true },
	["15"] = { name = "Garage", payment = true },
	["16"] = { name = "Garage", payment = true },
	["17"] = { name = "Garage", payment = true },
	["18"] = { name = "Garage", payment = true },
	["19"] = { name = "Garage", payment = true },
	["20"] = { name = "Garage", payment = true },

	-- Paramedic
	["41"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["42"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	["43"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["44"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	["45"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["46"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	-- Police
	["61"] = { name = "Police", payment = false, perm = "Police" },
	["62"] = { name = "heliPolice", payment = false, perm = "Police" },

	["63"] = { name = "Police", payment = false, perm = "Police" },
	["64"] = { name = "heliPolice", payment = false, perm = "Police" },

	["65"] = { name = "Police", payment = false, perm = "Police" },
	["66"] = { name = "busPolice", payment = false, perm = "Police" },

	["67"] = { name = "Police", payment = false, perm = "Police" },
	["68"] = { name = "heliPolice", payment = false, perm = "Police" },

	["69"] = { name = "Police", payment = false, perm = "Police" },
	["70"] = { name = "heliPolice", payment = false, perm = "Police" },

	-- Bikes
	["101"] = { name = "Bikes", payment = true },
	["102"] = { name = "Bikes", payment = true },
	["103"] = { name = "Bikes", payment = true },
	["104"] = { name = "Bikes", payment = true },
	["105"] = { name = "Bikes", payment = true },
	["106"] = { name = "Bikes", payment = true },
	["107"] = { name = "Bikes", payment = true },
	["108"] = { name = "Bikes", payment = true },
	["109"] = { name = "Bikes", payment = true },
	["110"] = { name = "Bikes", payment = true },
	["111"] = { name = "Bikes", payment = true },

	-- Boats
	["121"] = { name = "Boats", payment = true },
	["122"] = { name = "Boats", payment = true },
	["123"] = { name = "Boats", payment = true },
	["124"] = { name = "Boats", payment = true },

	-- Works
	["141"] = { name = "Lumberman", payment = true },
	["142"] = { name = "Driver", payment = true },
	["143"] = { name = "Garbageman", payment = true },
	["144"] = { name = "Transporter", payment = true },
	["145"] = { name = "Taxi", payment = true },
	["146"] = { name = "TowDriver", payment = true },
	["147"] = { name = "TowDriver", payment = true },
	["148"] = { name = "TowDriver", payment = true },
	["149"] = { name = "Fisherman", payment = true },
	["150"] = { name = "Trucker", payment = true },
	["151"] = { name = "Kart", payment = true },
	["152"] = { name = "Bullguer", payment = true },
	["153"] = { name = "AirForce", payment = true }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateReveryone")
AddEventHandler("plateReveryone",function(vehPlate)
	if vehPlates[vehPlate] then
		vehPlates[vehPlate] = nil

		TriggerClientEvent("garages:syncRemlates",-1,vehPlate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateEveryone")
AddEventHandler("plateEveryone",function(vehPlate)
	if vehPlates[vehPlate] == nil then
		vehPlates[vehPlate] = true

		TriggerClientEvent("garages:syncPlates",-1,vehPlate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEHARDNESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateHardness")
AddEventHandler("plateHardness",function(vehPlate,vehStatus)
	vehHardness[vehPlate] = parseInt(vehStatus)
	TriggerClientEvent("hud:plateHardness",-1,vehPlate,vehStatus)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("platePlayers")
AddEventHandler("platePlayers",function(vehPlate,user_id)
	local plateId = vRP.userPlate(vehPlate)
	if not plateId then
		vehPlates[vehPlate] = user_id
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateRobberys")
AddEventHandler("plateRobberys",function(vehPlate,vehName)
	if vehPlate ~= nil and vehName ~= nil then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vehPlates[vehPlate] ~= user_id then
				vehPlates[vehPlate] = user_id
				TriggerClientEvent("garages:syncPlates",-1,vehPlate)
			end

			TriggerClientEvent("Notify",source,"verde","Chave recebida.",3000)

			if math.random(100) >= 50 then
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
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local workgarage = {
	["Paramedic"] = {
		"lguard",
		"blazer2",
		"ambulance"
	},
	["heliParamedic"] = {
		"maverick2",
		"firetruk"
	},
	["Police"] = {
		"tahoe",
		"audia3",
		"audirs62",
		"audirs6avant",
		"audirs5",
		"audiq8",
		"ducati1200",
		"audia4",
		"fordraptor"
	},
	["heliPolice"] = {
		"maverick2"
	},
	["busPolice"] = {
		"pbus",
		"riot"
	},
	["Driver"] = {
		"bus"
	},
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},
	["Transporter"] = {
		"stockade"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["Fisherman"] = {
		"mule3"
	},
	["Trucker"] = {
		"packer"
	},
	["Kart"] = {
		"veto",
		"veto2"
	},
	["TowDriver"] = {
		"flatbed",
		"towtruck2"
	},
	["AirForce"] = {
		"volatus",
		"supervolito",
		"cuban800",
		"luxor",
		"mammatus",
		"miljet",
		"nimbus",
		"shamal",
		"velum",
		"buzzard2",
		"frogger",
		"havok",
		"swift",
		"swift2",
		"dodo"
	},
	["Garbageman"] = {
		"trash"
	},
	["Taxi"] = {
		"taxi"
	},
	["Bikes"] = {
		"bmx",
		"cruiser",
		"fixter",
		"scorcher",
		"tribike",
		"tribike2",
		"tribike3"
	},
	["Bullguer"] = {
		"faggio"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.myVehicles(garageWork)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myVehicle = {}
		local garageName = garageLocates[garageWork]["name"]
		local vehicle = vRP.query("vehicles/getVehicles",{ user_id = parseInt(user_id) })

		if workgarage[garageName] then
			for k,v in pairs(workgarage[garageName]) do
				local veh = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = v })
				if veh[1] then
					table.insert(myVehicle,{ name = veh[1]["vehicle"], name2 = vehicleName(veh[1]["vehicle"]), engine = parseInt(veh[1]["engine"] * 0.1), body = parseInt(veh[1]["body"] * 0.1), fuel = parseInt(veh[1]["fuel"]) })
				end
			end
		else
			for k,v in ipairs(vehicle) do
				if v["work"] == "false" then
					table.insert(myVehicle,{ name = vehicle[k]["vehicle"], name2 = vehicleName(vehicle[k]["vehicle"]), engine = parseInt(vehicle[k]["engine"] * 0.1), body = parseInt(vehicle[k]["body"] * 0.1), fuel = parseInt(vehicle[k]["fuel"]) })
				end
			end
		end

		return myVehicle
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.spawnVehicles(vehName,garageName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if spawnTimers[user_id] == nil then
			spawnTimers[user_id] = true

			local vehNet = nil
			for k,v in pairs(vehList) do
				if parseInt(v[1]) == parseInt(user_id) and v[2] == vehName then
					vehNet = parseInt(k)
					break
				end
			end

			local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })

			if vehNet == nil then
				local vehPrice = vehiclePrice(vehName)

				if os.time() >= parseInt(vehicle[1]["tax"] + 24 * 7 * 60 * 60) then
					TriggerClientEvent("Notify",source,"amarelo","Taxa do veículo atrasada, efetue o pagamento<br>através do seu tablet no sistema da benefactor.",5000)
				elseif parseInt(os.time()) <= parseInt(vehicle[1]["time"] + 24 * 60 * 60) then
					local status = vRP.request(source,"Veículo detido, deseja acionar o seguro pagando <b>$"..parseFormat(vehPrice * 0.5).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,vehPrice * 0.5) then
							vRP.execute("vehicles/arrestVehicles",{ user_id = parseInt(user_id), vehicle = vehName, arrest = 0, time = 0 })
						else
							TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
						end
					end
				elseif parseInt(vehicle[1]["arrest"]) >= 1 then
					local status = vRP.request(source,"Veículo detido, deseja acionar o seguro pagando <b>$"..parseFormat(vehPrice * 0.1).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,vehPrice * 0.1) then
							vRP.execute("vehicles/arrestVehicles",{ user_id = parseInt(user_id), vehicle = vehName, arrest = 0, time = 0 })
						else
							TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
						end
					end
				else
					if parseInt(vehicle[1]["rental"]) > 0 then
						if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
							TriggerClientEvent("Notify",source,"amarelo","Validade do veículo expirou, efetue a renovação do mesmo.",5000)
							spawnTimers[user_id] = nil

							return
						end
					end

					local mHash = GetHashKey(vehName)
					local checkSpawn,vehCoords = vCLIENT.spawnPosition(source)
					if checkSpawn then

						local vehMods = nil
						local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..vehName })
						if parseInt(#custom) > 0 then
							vehMods = custom[1]["dvalue"]
						end

						if garageLocates[garageName]["payment"] then
							if vRP.userPremium(user_id) then
								local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

								while not DoesEntityExist(vehObject) do
									Citizen.Wait(1)
								end

								local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
								vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
								TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
								TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
								vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
								TriggerEvent("plateEveryone",vehicle[1]["plate"])
								vehPlates[vehicle[1]["plate"]] = user_id
							else
								if vRP.request(source,"Deseja retirar o veículo pagando <b>$"..parseFormat(vehPrice * 0.05).."</b> dólares?",30) then
									if vRP.getBank(user_id) >= parseInt(vehPrice * 0.05) then
										local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

										while not DoesEntityExist(vehObject) do
											Citizen.Wait(1)
										end

										local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
										vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
										TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
										TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
										TriggerEvent("plateEveryone",vehicle[1]["plate"])
										vehPlates[vehicle[1]["plate"]] = user_id
										vehList[netVeh] = { user_id,vehName }
									else
										TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
									end
								end
							end
						else
							local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

							while not DoesEntityExist(vehObject) do
								Citizen.Wait(1)
							end

							local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
							vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
							TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
							TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
							vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
							TriggerEvent("plateEveryone",vehicle[1]["plate"])
							vehPlates[vehicle[1]["plate"]] = user_id
						end
					end
				end
			else
				if GetGameTimer() >= searchTimers[user_id] then
					searchTimers[user_id] = GetGameTimer() + 60000

					local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
					if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) then
						vCLIENT.searchBlip(source,GetEntityCoords(idNetwork))
						TriggerClientEvent("Notify",source,"amarelo","Rastreador do veículo foi ativado por <b>30 segundos</b>, lembrando que<br>se o mesmo estiver em movimento a localização pode ser imprecisa.",10000)
					else
						if vehList[vehNet] then
							vehList[vehNet] = nil
						end

						if vehPlates[vehicle[1]["plate"]] then
							vehPlates[vehicle[1]["plate"]] = nil
						end

						TriggerClientEvent("Notify",source,"verde","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","O rastreador só pode ser ativado a cada <b>60 segundos</b>.",5000)
				end
			end

			spawnTimers[user_id] = nil
		else
			TriggerClientEvent("Notify",source,"amarelo","Existe uma busca por seu veículo em andamento.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderador") and args[1] then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			local mHash = GetHashKey(args[1])
			local vehObject = CreateVehicle(mHash,coords["x"],coords["y"],coords["z"],heading,true,true)

			while not DoesEntityExist(vehObject) do
				Citizen.Wait(1)
			end

			local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
			local vehPlate = "VEH"..parseInt(math.random(10000,99999) + user_id)
			vCLIENT.createVehicle(-1,mHash,netVeh,vehPlate,1000,1000,100,nil,false,false,false,{ 1.25,0.75,0.95 })
			TriggerEvent("engine:insertEngines",netVeh,100,"")
			vehList[netVeh] = { user_id,vehName,vehPlate }
			TaskWarpPedIntoVehicle(ped,vehObject,-1)
			TriggerEvent("plateHardness",vehPlate,1)
			TriggerEvent("plateEveryone",vehPlate)
			vehPlates[vehPlate] = user_id
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remove",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			TriggerClientEvent("target:toggleAdmin",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Suporte") then
			local vehicle = vRPC.nearVehicle(source,15)
			if vehicle then
				vCLIENT.deleteVehicle(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:lockVehicle")
AddEventHandler("garages:lockVehicle",function(vehNet,vehPlate,vehLock)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vehPlates[vehPlate] == user_id then
			TriggerClientEvent("garages:vehicleLock",-1,vehNet,vehLock)

			if vehLock then
				TriggerClientEvent("sounds:source",source,"unlock",0.4)
				TriggerClientEvent("Notify",source,"unlocked","Veículo destrancado.",5000)
			else
				TriggerClientEvent("sounds:source",source,"lock",0.3)
				TriggerClientEvent("Notify",source,"locked","Veículo trancado.",5000)
			end

			if not vRPC.inVehicle(source) then
				vRPC.playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)
				Citizen.Wait(400)
				vRPC.stopAnim(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.tryDelete(vehNet,vehEngine,vehBody,vehFuel,vehDoors,vehWindows,vehTyres,vehPlate,vehBrake)
	if vehList[vehNet] and vehNet ~= 0 then
		local user_id = vehList[vehNet][1]
		local vehName = vehList[vehNet][2]

		if parseInt(vehEngine) <= 100 then
			vehEngine = 100
		end

		if parseInt(vehBody) <= 100 then
			vehBody = 100
		end

		if parseInt(vehFuel) >= 100 then
			vehFuel = 100
		end

		if parseInt(vehFuel) <= 5 then
			vehFuel = 5
		end

		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName) })
		if vehicle[1] ~= nil then
			vRP.execute("vehicles/updateVehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName), engine = parseInt(vehEngine), body = parseInt(vehBody), fuel = parseInt(vehFuel), doors = json.encode(vehDoors), windows = json.encode(vehWindows), tyres = json.encode(vehTyres), brakes = json.encode(vehBrake) })
		end
	end

	TriggerEvent("garages:deleteVehicle",vehNet,vehPlate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(vehNet,vehPlate)
	TriggerClientEvent("player:deleteVehicle",-1,vehNet,vehPlate)
	TriggerEvent("plateReveryone",vehPlate)

	if vehList[vehNet] then
		vehList[vehNet] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.returnGarages(garageName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if workgarage[garageLocates[garageName]["name"]] == nil then
			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"vermelho","Multas pendentes encontradas.",3000)
				return false
			end
		end

		if not vRP.wantedReturn(user_id) then
			if string.sub(garageName,0,5) == "Homes" then
				local consult = vRP.query("propertys/userPermissions",{ name = garageName, user_id = parseInt(user_id) })
				if consult[1] == nil then
					return false
				else
					local ownerConsult = vRP.query("propertys/userOwnermissions",{ name = garageName })
					if ownerConsult[1] then
						if parseInt(os.time()) >= parseInt(ownerConsult[1]["tax"] + 24 * 7 * 60 * 60) then
							TriggerClientEvent("Notify",source,"amarelo","Taxas da propriedade atrasada.",10000)
							return false
						end
					end
				end
			end

			if garageLocates[garageName]["perm"] ~= nil then
				if vRP.hasPermission(user_id,garageLocates[garageName]["perm"]) then
					return vCLIENT.openGarage(source,garageName)
				end
			else
				return vCLIENT.openGarage(source,garageName)
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vehs",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if args[1] == "transfer" and parseInt(args[3]) > 0 then
				local myVehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = args[2] })
				if myVehicle[1] then
					if parseInt(myVehicle[1]["rental"]) >= 1 then
						TriggerClientEvent("Notify",source,"amarelo","Veículos alugados não podem ser transferidos.",5000)
						return
					end

					local nuser_id = parseInt(args[3])
					local identity = vRP.userIdentity(nuser_id)
					if identity then
						local maxVehs = vRP.query("vehicles/countVehicles",{ user_id = parseInt(nuser_id), work = "false" })
						local myGarages = vRP.getInformation(nuser_id)
						local amountVehs = myGarages[1]["garage"]

						if vRP.userPremium(nuser_id) then
							amountVehs = amountVehs + 2
						end

						if parseInt(maxVehs[1]["qtd"]) >= parseInt(amountVehs) then
							TriggerClientEvent("Notify",source,"amarelo","Atingiu o máximo de veículos.",3000)
							return
						end

						if vRP.request(source,"Deseja transferir o veículo <b>"..vehicleName(args[2]).."</b> para <b>"..identity["name"].." "..identity["name2"].."</b>?",30) then
							local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(nuser_id), vehicle = args[2] })
							if vehicle[1] then
								TriggerClientEvent("Notify",source,"amarelo","<b>"..identity["name"].." "..identity["name2"].."</b> já possui este modelo de veículo.",5000)
							else
								vRP.execute("vehicles/moveVehicles",{ user_id = parseInt(user_id), nuser_id = parseInt(nuser_id), vehicle = args[2] })

								local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..args[2] })
								if parseInt(#custom) > 0 then
									vRP.execute("entitydata/setData",{ dkey = "custom:"..nuser_id..":"..args[2], value = custom[1]["dvalue"] })
									vRP.execute("entitydata/removeData",{ dkey = "custom:"..user_id..":"..args[2] })
								end

								local vehChest = vRP.getSrvdata("vehChest:"..user_id..":"..args[2])
								if vehChest ~= nil then
									vRP.setSrvdata("vehChest:"..nuser_id..":"..args[2],vehChest)
									vRP.remSrvdata("vehChest:"..user_id..":"..args[2])
								end

								local vehGloves = vRP.getSrvdata("vehGloves:"..user_id..":"..args[2])
								if vehGloves ~= nil then
									vRP.setSrvdata("vehGloves:"..nuser_id..":"..args[2],vehGloves)
									vRP.remSrvdata("vehGloves:"..user_id..":"..args[2])
								end

								TriggerClientEvent("Notify",source,"verde","Transferência concluída.",5000)
							end
						end
					end
				end
			else
				local vehicle = vRP.query("vehicles/getVehicles",{ user_id = parseInt(user_id) })
				if parseInt(#vehicle) > 0 then
					local vehCounts = 0
					local vehicleList = ""
					local vehicleRental = ""
					for k,v in pairs(vehicle) do
						vehCounts = vehCounts + 1

						if parseInt(v["rental"]) > 0 then
							if parseInt(os.time()) >= (v["rental"] + 24 * v["rendays"] * 60 * 60) then
								if vehCounts ~= parseInt(#vehicle) then
									vehicleRental = vehicleRental.."<b>Nome:</b> "..vehicleName(v["vehicle"]).."   -   <b>Modelo:</b> "..v["vehicle"].."<br><b>Vencimento:</b> Vencido<br><br>"
								else
									vehicleRental = vehicleRental.."<b>Nome:</b> "..vehicleName(v["vehicle"]).."   -   <b>Modelo:</b> "..v["vehicle"].."<br><b>Vencimento:</b> Vencido"
								end
							else
								if vehCounts ~= parseInt(#vehicle) then
									vehicleRental = vehicleRental.."<b>Nome:</b> "..vehicleName(v["vehicle"]).."   -   <b>Modelo:</b> "..v["vehicle"].."<br><b>Vencimento:</b> "..minimalTimers(parseInt(86400 * v["rendays"] - (os.time() - v["rental"]))).."<br><br>"
								else
									vehicleRental = vehicleRental.."<b>Nome:</b> "..vehicleName(v["vehicle"]).."   -   <b>Modelo:</b> "..v["vehicle"].."<br><b>Vencimento:</b> "..minimalTimers(parseInt(86400 * v["rendays"] - (os.time() - v["rental"])))
								end
							end
						else
							if vehCounts ~= parseInt(#vehicle) then
								vehicleList = vehicleList.."<b>Nome:</b> "..vehicleName(v["vehicle"]).."   -   <b>Modelo:</b> "..v["vehicle"].."<br>"
							else
								vehicleList = vehicleList.."<b>Nome:</b> "..vehicleName(v["vehicle"]).."   -   <b>Modelo:</b> "..v["vehicle"]
							end
						end
					end

					if vehicleList ~= "" and vehicleRental ~= "" then
						TriggerClientEvent("Notify",source,"default",vehicleRental..vehicleList,20000)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:updateGarages")
AddEventHandler("garages:updateGarages",function(homeName,homeInfos)
	garageLocates[homeName] = { ["name"] = homeName, ["payment"] = false }

	-- CONFIG
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)
	configTable[homeName] = { ["name"] = homeName, ["payment"] = false }
	SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)

	-- LOCATES
	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)
	locatesTable[homeName] = homeInfos
	SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)

	TriggerClientEvent("garages:updateLocs",-1,homeName,homeInfos)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:REMOVEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:removeGarages")
AddEventHandler("garages:removeGarages",function(homeName)
	if garageLocates[homeName] then
		garageLocates[homeName] = nil

		local configFile = LoadResourceFile("logsystem","garageConfig.json")
		local configTable = json.decode(configFile)
		if configTable[homeName] then
			configTable[homeName] = nil
			SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)
		end

		local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
		local locatesTable = json.decode(locatesFile)
		if locatesTable[homeName] then
			locatesTable[homeName] = nil
			SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)
		end

		TriggerClientEvent("garages:updateRemove",-1,homeName)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)

	for k,v in pairs(configTable) do
		garageLocates[k] = v
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("garages:allPlates",source,vehPlates)
	TriggerClientEvent("hud:allHardness",source,vehHardness)

	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)

	TriggerClientEvent("garages:allLocs",source,locatesTable)

	searchTimers[user_id] = GetGameTimer()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if searchTimers[user_id] then
		searchTimers[user_id] = nil
	end

	if spawnTimers[user_id] then
		spawnTimers[user_id] = nil
	end
end)