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
Tunnel.bindInterface("doors",cRP)
vTASKBAR = Tunnel.getInterface("taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
local doors = {
	[1] = { x = 1846.049, y = 2604.733, z = 45.579, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Police" },
	[2] = { x = 1819.475, y = 2604.743, z = 45.577, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Police" },
	[3] = { x = 1836.71, y = 2590.32, z = 46.20, hash = 539686410, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[4] = { x = 1769.52, y = 2498.92, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[5] = { x = 1766.34, y = 2497.09, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[6] = { x = 1763.20, y = 2495.26, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[7] = { x = 1756.89, y = 2491.66, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[8] = { x = 1753.75, y = 2489.85, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[9] = { x = 1750.61, y = 2488.02, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[10] = { x = 1757.14, y = 2474.87, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[11] = { x = 1760.26, y = 2476.71, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[12] = { x = 1763.44, y = 2478.50, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[13] = { x = 1766.54, y = 2480.33, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[14] = { x = 1769.73, y = 2482.13, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[15] = { x = 1772.83, y = 2483.97, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[16] = { x = 1776.00, y = 2485.77, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },

	[21] = { x = -952.54, y = -2049.71, z = 6.1, hash = -806761221, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[22] = { x = -953.05, y = -2051.72, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[23] = { x = -955.99, y = -2049.01, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[24] = { x = -959.65, y = -2052.67, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Police" },

	[31] = { x = -925.98, y = -2035.20, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 32 },
	[32] = { x = -926.82, y = -2034.42, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 31 },
	[33] = { x = -953.81, y = -2044.32, z = 9.7, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[34] = { x = -954.02, y = -2058.36, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 35 },
	[35] = { x = -954.78, y = -2057.61, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 34 },
	[36] = { x = -912.94, y = -2033.33, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 37 },
	[37] = { x = -913.69, y = -2032.55, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 36 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.doorsStatistics(doorNumber,doorStatus)
	local source = source

	doors[doorNumber]["lock"] = doorStatus

	if doors[doorNumber]["other"] ~= nil then
		local doorSecond = doors[doorNumber]["other"]
		doors[doorSecond]["lock"] = doorStatus
		TriggerClientEvent("doors:Update",-1,doorSecond,doorStatus)
	end

	TriggerClientEvent("doors:Update",-1,doorNumber,doorStatus)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.doorsPermission(doorNumber)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if doors[doorNumber]["perm"] ~= nil then
			if vRP.hasPermission(user_id,doors[doorNumber]["perm"]) then
				return true
			else
				local consultItem = vRP.getInventoryItemAmount(user_id,"lockpick")
				if consultItem[1] >= 1 then
					if math.random(100) >= 50 then
						vRP.removeInventoryItem(user_id,consultItem[2],1,true)
						vRP.generateItem(user_id,"lockpick2",1,false)
					end

					local taskResult = vTASKBAR.taskDoors(source)
					if taskResult then
						return true
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("doors:doorsUpdate",source,doors)
end)

-- CreateThread(function()
-- 	Wait(1000)
-- 	TriggerClientEvent("doors:doorsUpdate",-1,doors)
-- end)
