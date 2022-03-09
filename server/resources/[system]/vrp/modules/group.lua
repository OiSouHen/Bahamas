-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local permList = {}
local selfReturn = {}
permList["Taxi"] = {}
permList["Police"] = {}
permList["Mechanic"] = {}
permList["Paramedic"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local permissions = {
	["Admin"] = {
		["Admin"] = true
	},
	["Moderador"] = {
		["Admin"] = true,
		["Moderador"] = true
	},
	["Suporte"] = {
		["Admin"] = true,
		["Moderador"] = true,
		["Suporte"] = true
	},
	["Police"] = {
		["Police"] = true
	},
	["Paramedic"] = {
		["Paramedic"] = true
	},
	["Emergency"] = {
		["Police"] = true,
		["Paramedic"] = true
	},
	["Ballas"] = {
		["Ballas"] = true
	},
	["Vagos"] = {
		["Vagos"] = true
	},
	["Families"] = {
		["Families"] = true
	},
	["Fleeca"] = {
		["Fleeca"] = true
	},
	["Aztecas"] = {
		["Aztecas"] = true
	},
	["EastSide"] = {
		["EastSide"] = true
	},
	["Triads"] = {
		["Triads"] = true
	},
	["DaNang"] = {
		["DaNang"] = true
	},
	["Crips"] = {
		["Crips"] = true
	},
	["Mechanic"] = {},
	["Marabunta"] = {
		["Marabunta"] = true
	},
	["Rednecks"] = {
		["Rednecks"] = true
	},
	["Drugs"] = {
		["Ballas"] = true,
		["Vagos"] = true,
		["Families"] = true,
		["Aztecas"] = true,
		["Crips"] = true,
		["DaNang"] = true
	},
	["Weapons"] = {
		["EastSide"] = true,
		["Triads"] = true,
		["Marabunta"] = true,
		["Rednecks"] = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasPermission(user_id,perm)
	local perm = tostring(perm)
	local user_id = parseInt(user_id)
	local dataTable = vRP.getDatatable(user_id)

	if dataTable then
		if dataTable["permission"] == nil then
			dataTable["permission"] = {}
		end

		if dataTable["permission"][perm] then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setPermission(user_id,perm)
	local perm = tostring(perm)
	local user_id = parseInt(user_id)
	local dataTable = vRP.getDatatable(user_id)

	if dataTable then
		if dataTable["permission"] == nil then
			dataTable["permission"] = {}
		end

		if dataTable["permission"][perm] == nil then
			dataTable["permission"][perm] = true
		end
	else
		local userTables = vRP.userData(user_id,"Datatable")

		if userTables["inventory"] then
			if userTables["permission"] == nil then
				userTables["permission"] = {}
			end

			if userTables["permission"][perm] == nil then
				userTables["permission"][perm] = true
			end

			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(userTables) })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.cleanPermission(user_id)
	local user_id = parseInt(user_id)
	local dataTable = vRP.getDatatable(user_id)

	if dataTable then
		dataTable["permission"] = {}
	else
		local userTables = vRP.userData(user_id,"Datatable")

		if userTables["inventory"] then
			userTables["permission"] = {}
			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(userTables) })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.remPermission(user_id,perm)
	local perm = tostring(perm)
	local user_id = parseInt(user_id)
	local dataTable = vRP.getDatatable(user_id)

	if dataTable then
		if dataTable["permission"] == nil then
			dataTable["permission"] = {}
		end

		if dataTable["permission"][perm] then
			dataTable["permission"][perm] = nil
		end
	else
		local userTables = vRP.userData(user_id,"Datatable")

		if userTables["inventory"] then
			if userTables["permission"] == nil then
				userTables["permission"] = {}
			end

			if userTables["permission"][perm] then
				userTables["permission"][perm] = nil
			end

			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(userTables) })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updatePermission(user_id,perm,new)
	local new = tostring(new)
	local perm = tostring(perm)
	local user_id = parseInt(user_id)
	local dataTable = vRP.getDatatable(user_id)

	if dataTable then
		if dataTable["permission"] == nil then
			dataTable["permission"] = {}
		end

		if dataTable["permission"][perm] then
			dataTable["permission"][perm] = nil
		end

		dataTable["permission"][new] = true
	else
		local userTables = vRP.userData(user_id,"Datatable")
		if userTables["inventory"] then
			if userTables["permission"] == nil then
				userTables["permission"] = {}
			end

			if userTables["permission"][perm] then
				userTables["permission"][perm] = nil
			end

			userTables["permission"][new] = true

			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(userTables) })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasGroup(user_id,perm)
	local perm = tostring(perm)
	local user_id = parseInt(user_id)
	local dataTable = vRP.getDatatable(user_id)

	selfReturn[user_id] = false

	if dataTable then
		if dataTable["permission"] == nil then
			dataTable["permission"] = {}
		end

		local consult = dataTable["permission"]
		for k,v in pairs(consult) do
			if permissions[perm][k] then
				selfReturn[user_id] = true
				break
			end
		end
	end

	return selfReturn[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.numPermission(perm)
	local tableList = {}

	for k,v in pairs(permList[perm]) do
		table.insert(tableList,parseInt(k))
	end

	return tableList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.insertPermission(source,perm)
	permList[perm][tostring(source)] = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removePermission(source,perm)
	if permList[perm][tostring(source)] then
		permList[perm][tostring(source)] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if permList["Police"][tostring(source)] then
		permList["Police"][tostring(source)] = nil
	end

	if permList["Paramedic"][tostring(source)] then
		permList["Paramedic"][tostring(source)] = nil
	end

	if permList["Taxi"][tostring(source)] then
		permList["Taxi"][tostring(source)] = nil
	end

	if permList["Mechanic"][tostring(source)] then
		permList["Mechanic"][tostring(source)] = nil
	end

	if selfReturn[user_id] then
		selfReturn[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	if vRP.hasPermission(user_id,"Police") then
		permList["Police"][tostring(source)] = true
		TriggerClientEvent("police:updateService",source,true)

		local identity = vRP.userIdentity(user_id)
		if identity then
			if identity["penal"] >= 1 then
				TriggerEvent("blipsystem:serviceEnter",source,"Penal",24)
			else
				TriggerEvent("blipsystem:serviceEnter",source,"Policia",18)
			end
		end
	end

	if vRP.hasPermission(user_id,"Paramedic") then
		permList["Paramedic"][tostring(source)] = true
		TriggerClientEvent("paramedic:updateService",source,true)
		TriggerEvent("blipsystem:serviceEnter",source,"Paramédico",6)
	end

	if vRP.hasGroup(user_id,"Mechanic") then
		permList["Mechanic"][tostring(source)] = true
	end
end)