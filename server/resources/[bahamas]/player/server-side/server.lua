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
Tunnel.bindInterface("player",cRP)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("upgradeStress")
AddEventHandler("upgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,parseInt(number))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:KICKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:kickSystem")
AddEventHandler("player:kickSystem",function(message)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.kick(user_id,message)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and vRP.getHealth(source) > 101 then
			if args[2] == "friend" then
				local otherPlayer = vRPC.nearestPlayer(source,3)
				if otherPlayer then
					if vRP.getHealth(otherPlayer) > 101 and not vCLIENT.getHandcuff(otherPlayer) then
						local identity = vRP.userIdentity(user_id)
						local request = vRP.request(otherPlayer,"Aceitar o pedido de <b>"..identity["name"].." "..identity["name2"].."</b> da animação <b>"..args[1].."</b>?",30)
						if request then
							TriggerClientEvent("emotes",otherPlayer,args[1])
							TriggerClientEvent("emotes",source,args[1])
						end
					end
				end
			else
				TriggerClientEvent("emotes",source,args[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and vRP.getHealth(source) > 101 then
			local otherPlayer = vRPC.nearestPlayer(source,3)
			if otherPlayer then
				if vRP.hasPermission(user_id,"Paramedic") then
					TriggerClientEvent("emotes",otherPlayer,args[1])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHMENU:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehmenu:doors")
AddEventHandler("vehmenu:doors",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet = vRPC.vehList(source,5)
		if vehicle then
			TriggerClientEvent("player:syncDoors",-1,vehNet,number)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.receiveSalary()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.userPremium(user_id) then
			vRP.addBank(user_id,1000)
			TriggerClientEvent("Notify",source,"azul","Salário de <b>$1.000</b> recebido.",5000)
		end

		if vRP.hasPermission(user_id,"Police") then
			vRP.addBank(user_id,2000)
			TriggerClientEvent("Notify",source,"azul","Salário de <b>$2.000</b> recebido.",5000)
		end

		if vRP.hasPermission(user_id,"Paramedic") then
			vRP.addBank(user_id,2000)
			TriggerClientEvent("Notify",source,"azul","Salário de <b>$2.000</b> recebido.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 911
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("911",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and vRP.getHealth(source) > 101 then
			if vRP.hasPermission(user_id,"Police") then
				local identity = vRP.userIdentity(user_id)

				local policeResult = vRP.numPermission("Police")
				for k,v in pairs(policeResult) do
					async(function()
						TriggerClientEvent("chatME",v,"^7"..identity["name"].." "..identity["name2"]..": ^4"..rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 112
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("112",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and vRP.getHealth(source) > 101 then
			if vRP.hasPermission(user_id,"Paramedic") then
				local identity = vRP.userIdentity(user_id)

				local paramedicResult = vRP.numPermission("Paramedic")
				for k,v in pairs(paramedicResult) do
					async(function()
						TriggerClientEvent("chatME",v,"^5"..identity["name"].." "..identity["name2"]..": ^4"..rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SERVICEPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:servicePolice")
AddEventHandler("player:servicePolice",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			vRP.removePermission(source,"Police")
			TriggerEvent("blipsystem:serviceExit",source)
			vRP.updatePermission(user_id,"Police","waitPolice")
			TriggerClientEvent("police:updateService",source,false)
			TriggerClientEvent("Notify",source,"azul","Saiu de serviço.",5000)
		elseif vRP.hasPermission(user_id,"waitPolice") then
			vRP.insertPermission(source,"Police")
			vRP.updatePermission(user_id,"waitPolice","Police")
			TriggerClientEvent("police:updateService",source,true)

			local identity = vRP.userIdentity(user_id)
			if identity then
				if identity["penal"] >= 1 then
					TriggerEvent("blipsystem:serviceEnter",source,"Penal",24)
				else
					TriggerEvent("blipsystem:serviceEnter",source,"Policia",18)
				end
			end

			TriggerClientEvent("Notify",source,"azul","Entrou em serviço.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SERVICEPARAMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:serviceParamedic")
AddEventHandler("player:serviceParamedic",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Paramedic") then
			vRP.removePermission(source,"Paramedic")
			TriggerEvent("blipsystem:serviceExit",source)
			vRP.updatePermission(user_id,"Paramedic","waitParamedic")
			TriggerClientEvent("paramedic:updateService",source,false)
			TriggerClientEvent("Notify",source,"azul","Saiu de serviço.",5000)
		elseif vRP.hasPermission(user_id,"waitParamedic") then
			vRP.insertPermission(source,"Paramedic")
			vRP.updatePermission(user_id,"waitParamedic","Paramedic")
			TriggerClientEvent("paramedic:updateService",source,true)
			TriggerEvent("blipsystem:serviceEnter",source,"Paramédico",6)
			TriggerClientEvent("Notify",source,"azul","Entrou em serviço.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.shotsFired()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ped = GetPlayerPed(source)
		if DoesEntityExist(ped) then
			local coords = GetEntityCoords(ped)
			TriggerClientEvent("notifyShooting",-1,coords)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:carryFunctions")
AddEventHandler("player:carryFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local otherPlayer = vRPC.nearestPlayer(source,1.1)
		if otherPlayer then
			if vRP.hasGroup(user_id,"Emergency") then
				if mode == "bracos" then
					vCLIENT.toggleCarry(otherPlayer,source)
				elseif mode == "ombros" then
					TriggerClientEvent("rope:toggleRope",source,otherPlayer)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:WINSFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:winsFunctions")
AddEventHandler("player:winsFunctions",function(mode)
	local source = source
	local vehicle,vehNet = vRPC.vehSitting(source)
	if vehicle then
		TriggerClientEvent("player:syncWins",-1,vehNet,mode)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:IDENTITYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:identityFunctions")
AddEventHandler("player:identityFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(user_id)
		if identity then
			local port = "Não"
			if identity["port"] >= 1 then
				port = "Sim"
			end

			local premium = "Não"
			local infoAccount = vRP.infoAccount(identity["steam"])
			if infoAccount and parseInt(os.time()) <= parseInt(infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
				premium = minimalTimers(86400 * infoAccount["predays"] - (os.time() - infoAccount["premium"]))
			end

			TriggerClientEvent("Notify",source,"default","<b>Passaporte:</b> "..parseFormat(user_id).."<br><b>Nome:</b> "..identity["name"].." "..identity["name2"].."<br><b>Gemas:</b> "..parseFormat(vRP.userGemstone(user_id)).."<br><b>Maximo de Veículos:</b> "..identity["garage"].."<br><b>Maximo de Propriedades:</b> "..identity["homes"].."<br><b>Porte de Armamento:</b> "..port.."<br><b>Premium:</b> "..premium,10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(mode)
	local source = source
	local distance = 1.1

	if mode == "rv" then
		distance = 10.0
	end

	local otherPlayer = vRPC.nearestPlayer(source,distance)
	if otherPlayer then
		local user_id = vRP.getUserId(source)
		local consultItem = vRP.getInventoryItemAmount(user_id,"rope")
		if vRP.hasGroup(user_id,"Emergency") or consultItem[1] >= 1 then
			local vehicle,vehNet,vehPlate,vehName,vehLock = vRPC.vehList(source,5)
			if vehicle then
				if vehLock ~= 1 then
					if mode == "rv" then
						vCLIENT.removeVehicle(otherPlayer)
					elseif mode == "cv" then
						vCLIENT.putVehicle(otherPlayer,vehNet)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["1"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 130, texture = 1 },
			["vest"] = { item = 56, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 179, texture = 0 },
			["torso"] = { item = 363, texture = 0 },
			["accessory"] = { item = 151, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 56, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 222, texture = 0 },
			["torso"] = { item = 382, texture = 0 },
			["accessory"] = { item = 151, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 130, texture = 1 },
			["vest"] = { item = 56, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 179, texture = 0 },
			["torso"] = { item = 364, texture = 0 },
			["accessory"] = { item = 151, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 56, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 222, texture = 0 },
			["torso"] = { item = 383, texture = 0 },
			["accessory"] = { item = 151, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 28, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["3"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 1 },
			["tshirt"] = { item = 96, texture = 0 },
			["torso"] = { item = 32, texture = 7 },
			["accessory"] = { item = 126, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 79, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 101, texture = 0 },
			["torso"] = { item = 58, texture = 7 },
			["accessory"] = { item = 96, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 91, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["4"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 57, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 1 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 249, texture = 0 },
			["accessory"] = { item = 126, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 90, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 65, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 2, texture = 0 },
			["torso"] = { item = 257, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 104, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["5"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 1 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 146, texture = 6 },
			["accessory"] = { item = 127, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 85, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 2, texture = 0 },
			["torso"] = { item = 141, texture = 1 },
			["accessory"] = { item = 97, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 109, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:presetFunctions")
AddEventHandler("player:presetFunctions",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Emergency") then
			local model = vRP.modelPlayer(source)

			if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,preset[number][model])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local otherPlayer = vRPC.nearestPlayer(source,2)
	if otherPlayer then
		TriggerClientEvent("player:checkTrunk",otherPlayer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT - REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
local removeFit = {
	["homem"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mulher"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:outfitFunctions")
AddEventHandler("player:outfitFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and not vRP.reposeReturn(user_id) and not vRP.wantedReturn(user_id) then
		if mode == "aplicar" then
			local result = vRP.getSrvdata("saveClothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif mode == "preaplicar" then
			local result = vRP.getSrvdata("premClothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif mode == "salvar" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.setSrvdata("saveClothes:"..user_id,custom)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
		elseif mode == "presalvar" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.setSrvdata("premClothes:"..user_id,custom)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
		elseif mode == "remover" then
			local model = vRP.modelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["mulher"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("repose",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local timer = parseInt(args[2])
			local nuser_id = parseInt(args[1])
			local uSource = vRP.userSource(nuser_id)
			if uSource then
				local identity = vRP.userIdentity(nuser_id)
				if vRP.request(source,"Deseja aplicar <b>"..timer.." minutos</b> de repouso no(a) <b>"..identity["name"].." "..identity["name2"].."</b>?.",30) then
					TriggerClientEvent("Notify",source,"azul","Aplicou <b>"..timer.." minutos</b> de repouso.",10000)
					vRP.reposeTimer(nuser_id,timer)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WALKING
-----------------------------------------------------------------------------------------------------------------------------------------
local walking = {
	{ "move_m@alien" },
	{ "anim_group_move_ballistic" },
	{ "move_f@arrogant@a" },
	{ "move_m@brave" },
	{ "move_m@casual@a" },
	{ "move_m@casual@b" },
	{ "move_m@casual@c" },
	{ "move_m@casual@d" },
	{ "move_m@casual@e" },
	{ "move_m@casual@f" },
	{ "move_f@chichi" },
	{ "move_m@confident" },
	{ "move_m@business@a" },
	{ "move_m@business@b" },
	{ "move_m@business@c" },
	{ "move_m@drunk@a" },
	{ "move_m@drunk@slightlydrunk" },
	{ "move_m@buzzed" },
	{ "move_m@drunk@verydrunk" },
	{ "move_f@femme@" },
	{ "move_characters@franklin@fire" },
	{ "move_characters@michael@fire" },
	{ "move_m@fire" },
	{ "move_f@flee@a" },
	{ "move_p_m_one" },
	{ "move_m@gangster@generic" },
	{ "move_m@gangster@ng" },
	{ "move_m@gangster@var_e" },
	{ "move_m@gangster@var_f" },
	{ "move_m@gangster@var_i" },
	{ "anim@move_m@grooving@" },
	{ "move_f@heels@c" },
	{ "move_m@hipster@a" },
	{ "move_m@hobo@a" },
	{ "move_f@hurry@a" },
	{ "move_p_m_zero_janitor" },
	{ "move_p_m_zero_slow" },
	{ "move_m@jog@" },
	{ "anim_group_move_lemar_alley" },
	{ "move_heist_lester" },
	{ "move_f@maneater" },
	{ "move_m@money" },
	{ "move_m@posh@" },
	{ "move_f@posh@" },
	{ "move_m@quick" },
	{ "female_fast_runner" },
	{ "move_m@sad@a" },
	{ "move_m@sassy" },
	{ "move_f@sassy" },
	{ "move_f@scared" },
	{ "move_f@sexy@a" },
	{ "move_m@shadyped@a" },
	{ "move_characters@jimmy@slow@" },
	{ "move_m@swagger" },
	{ "move_m@tough_guy@" },
	{ "move_f@tough_guy@" },
	{ "move_p_m_two" },
	{ "move_m@bag" },
	{ "move_m@injured" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("andar",function(source,args,rawCommand)
	if args[1] and exports["chat"]:statusChat(source) then
		vCLIENT.movementClip(source,walking[parseInt(args[1])][1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("add",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and parseInt(args[2]) > 0 then
			if vRP.hasPermission(user_id,"service"..args[1]) then
				vRP.cleanPermission(args[2])

				if args[1] == "Police" or args[1] == "Paramedic" then
					vRP.setPermission(args[2],"wait"..args[1])
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..parseFormat(args[2]).."</b> adicionado.",5000)
				else
					vRP.setPermission(args[2],args[1])
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..parseFormat(args[2]).."</b> adicionado.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rem",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and parseInt(args[2]) > 0 then
			if vRP.hasPermission(user_id,"service"..args[1]) then
				if args[1] == "Police" or args[1] == "Paramedic" then
					vRP.remPermission(args[2],args[1])
					vRP.remPermission(args[2],"wait"..args[1])
					TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..parseFormat(args[2]).."</b> removido.",5000)
				else
					vRP.remPermission(args[2],args[1])
					TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..parseFormat(args[2]).."</b> removido.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SERVICOFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local delayDuty = {}
RegisterServerEvent("player:servicoFunctions")
AddEventHandler("player:servicoFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and delayDuty[user_id] == nil then
		delayDuty[user_id] = true

		if vRP.hasGroup(user_id,"Emergency") then
			local service = {}
			local onDuty = "<b>Passaporte:</b> "

			if vRP.hasPermission(user_id,"Police") then
				service = vRP.numPermission("Police")
			elseif vRP.hasPermission(user_id,"Paramedic") then
				service = vRP.numPermission("Paramedic")
			end

			for k,v in pairs(service) do
				local nuser_id = vRP.getUserId(v)
				if nuser_id then
					if k ~= #service then
						onDuty = onDuty..nuser_id..", "
					else
						onDuty = onDuty..nuser_id
					end
				end
			end

			TriggerClientEvent("Notify",source,"azul",onDuty,30000)
		end

		delayDuty[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if delayDuty[user_id] then
		delayDuty[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] then
			local identity = vRP.userIdentity(user_id)
			if identity then
				TriggerClientEvent("chatME",source,"^1* "..identity["name"].." ... "..rawCommand:sub(3))

				local players = vRPC.nearestPlayers(source,5)
				for _,v in pairs(players) do
					TriggerClientEvent("chatME",v[2],"^1* "..identity["name"].." ... "..rawCommand:sub(3))
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDLOGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deathLogs")
AddEventHandler("player:deathLogs",function(nSource)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and source ~= nSource then
		local nuser_id = vRP.getUserId(nSource)
		if nuser_id then
			TriggerEvent("discordLogs","Deaths","**Matou:** "..user_id.."\n**Morreu:** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDLINKS
-----------------------------------------------------------------------------------------------------------------------------------------
local discordLinks = {
	["Disconnect"] = "",
	["Airport"] = "",
	["Deaths"] = "",
	["Police"] = "",
	["Investigation"] = "",
	["Ballas"] = "",
	["Vagos"] = "",
	["Families"] = "",
	["Fleeca"] = "",
	["Aztecas"] = "",
	["Triads"] = "",
	["EastSide"] = "",
	["DaNang"] = "",
	["Crips"] = "",
	["Marabunta"] = "",
	["Rednecks"] = ""
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDLOGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("discordLogs")
AddEventHandler("discordLogs",function(webhook,message,color)
	PerformHttpRequest(discordLinks[webhook],function(err,text,headers) end,"POST",json.encode({
		username = "Bahamas",
		embeds = { { color = color, description = message } }
	}),{ ["Content-Type"] = "application/json" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
local webHook = ""
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	if not vRP.hasGroup(user_id,"Suporte") then
		local identity = vRP.userIdentity(user_id)
		if identity then
			local infoAccount = vRP.infoAccount(identity["steam"])
			if infoAccount then
				PerformHttpRequest(webHook,function(err,text,headers) end,"POST",json.encode({
					content = infoAccount["discord"].." #"..user_id.." "..identity["name"].." "..identity["name2"]
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)