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
Tunnel.bindInterface("paramedic",cRP)
vCLIENT = Tunnel.getInterface("paramedic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:tratamento")
AddEventHandler("paramedic:tratamento",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 and vRP.getHealth(entity) > 101 then
		if vRP.hasPermission(user_id,"Paramedic") then
			vRPC.startTreatment(entity)
			TriggerClientEvent("Notify",source,"amarelo","Tratamento começou.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:ANIMDEITAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:maca")
AddEventHandler("paramedic:maca",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 then
		if vRP.hasPermission(user_id,"Paramedic") then
			TriggerClientEvent("target:pacienteDeitar",entity)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:REANIMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:reanimar")
AddEventHandler("paramedic:reanimar",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 and vRP.getHealth(entity) <= 101 then
		if vRP.hasPermission(user_id,"Paramedic") then
			local nuser_id = vRP.getUserId(entity)

			TriggerClientEvent("Progress",source,10000)
			TriggerClientEvent("cancelando",source,true)
			vRPC.playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

			SetTimeout(10000,function()
				vRPC.removeObjects(source)
				vRP.upgradeThirst(nuser_id,10)
				vRP.upgradeHunger(nuser_id,10)
				vRPC.revivePlayer(entity,110)
				TriggerClientEvent("resetBleeding",entity)
				TriggerClientEvent("cancelando",source,false)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:SANGRAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:sangramento")
AddEventHandler("paramedic:sangramento",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 and vRP.getHealth(entity) > 101 then
		if vRP.hasPermission(user_id,"Paramedic") then
			TriggerClientEvent("resetBleeding",entity)
			TriggerClientEvent("Notify",source,"blood","Sangramento parou.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:DIAGNOSTICO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:diagnostico")
AddEventHandler("paramedic:diagnostico",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 then
		if vRP.hasPermission(user_id,"Paramedic") then
			local hurt = false
			local diagnostic,bleeding = vCLIENT.getDiagnostic(entity)
			if diagnostic then
				if next(diagnostic) then
					hurt = true
					TriggerClientEvent("drawInjuries",source,entity,diagnostic)
				end
			end

			local text = ""
			if bleeding == 3 then
				text = "- <b>Sangramento Baixo</b><br>"
			elseif bleeding == 4 then
				text = "- <b>Sangramento Médio</b><br>"
			elseif bleeding >= 5 then
				text = "- <b>Sangramento Alto</b><br>"
			end

			if diagnostic["taser"] then
				text = text .. "- <b>Eletrocutado</b><br>"
			end

			if diagnostic["vehicle"] then
				text = text .. "- <b>Acidente com veículo</b><br>"
			end

			if text ~= "" then
				TriggerClientEvent("Notify",source,"amarelo","Status do paciente:<br>" .. text,5000)
			elseif not hurt then
				TriggerClientEvent("Notify",source,"verde","Status do paciente:<br>- <b>Nada encontrado</b>",5000)
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
			["pants"] = { item = 56, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 16, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 15, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 57, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 16, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 15, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 84, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 122, texture = 0 },
			["shoes"] = { item = 47, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 186, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 110, texture = 3 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 86, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 90, texture = 0 },
			["mask"] = { item = 122, texture = 0 },
			["shoes"] = { item = 48, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 188, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 127, texture = 3 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETBURN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:presetBurn")
AddEventHandler("paramedic:presetBurn",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Emergency") then
			local model = vRP.modelPlayer(entity)

			if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",entity,preset["1"][model])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETPLASTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:presetPlaster")
AddEventHandler("paramedic:presetPlaster",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Emergency") then
			local model = vRP.modelPlayer(entity)

			if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",entity,preset["2"][model])
			end
		end
	end
end)