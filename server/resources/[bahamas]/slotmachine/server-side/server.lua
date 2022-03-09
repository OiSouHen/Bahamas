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
Tunnel.bindInterface("slotmachine",cRP)
vCLIENT = Tunnel.getInterface("slotmachine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local activeSlot = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISSEATUSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("slotmachine:isSeatUsed")
AddEventHandler("slotmachine:isSeatUsed",function(index)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if activeSlot[index] == nil then
			activeSlot[index] = {}
			activeSlot[index]["used"] = true
		else
			if not activeSlot[index]["used"] then
				activeSlot[index]["used"] = true
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTUSING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("slotmachine:notUsing")
AddEventHandler("slotmachine:notUsing",function(index)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if activeSlot[index] ~= nil then
			activeSlot[index]["used"] = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKSTARTSLOTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("slotmachine:taskStartSlots")
AddEventHandler("slotmachine:taskStartSlots",function(index,data)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"dollars",parseInt(data["bet"]),true) then
			local w = { a = math.random(16), b = math.random(16), c = math.random(16) }

			local slotOne = math.random(100)
			local slotTow = math.random(100)
			local slotThr = math.random(100)

			if slotOne > 50 then w["a"] = w["a"] + 0.5 end
			if slotTow > 50 then w["b"] = w["b"] + 0.5 end
			if slotThr > 50 then w["c"] = w["c"] + 0.5 end

			TriggerClientEvent("slotmachine:startSpin",source,index,w)

			activeSlot[index]["win"] = w
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SLOTSCHECKWIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("slotmachine:slotsCheckWin")
AddEventHandler("slotmachine:slotsCheckWin",function(index,data,dt)
	if activeSlot[index] then
		if activeSlot[index]["win"] then
			if activeSlot[index]["win"]["a"] == data["a"] and activeSlot[index]["win"]["b"] == data["b"] and activeSlot[index]["win"]["c"] == data["c"] then
				CheckForWin(activeSlot[index]["win"],dt)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local winTable = {
	[1] = "2",
	[2] = "3",
	[3] = "6",
	[4] = "2",
	[5] = "4",
	[6] = "1",
	[7] = "6",
	[8] = "5",
	[9] = "2",
	[10] = "1",
	[11] = "3",
	[12] = "6",
	[13] = "7",
	[14] = "1",
	[15] = "4",
	[16] = "5"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MULTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local mulTable = {
	["1"] = 2,
	["2"] = 4,
	["3"] = 6,
	["4"] = 8,
	["5"] = 10,
	["6"] = 12,
	["7"] = 14
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKFORWIN
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckForWin(w,data)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local total = 0
		local a = winTable[w["a"]]
		local b = winTable[w["b"]]
		local c = winTable[w["c"]]

		if a == b and b == c and a == c then
			if mulTable[a] then
				total = data["bet"] * mulTable[a]
			end	
		elseif a == "6" and b == "6" then
			total = data["bet"] * 5
		elseif a == "6" and c == "6" then
			total = data["bet"] * 5
		elseif b == "6" and c == "6" then
			total = data["bet"] * 5
		elseif a == "6" then
			total = data["bet"] * 2
		elseif b == "6" then
			total = data["bet"] * 2
		elseif c == "6" then
			total = data["bet"] * 2
		end

		if total > 0 then
			vRP.giveInventoryItem(user_id,"dollars",total,true)
		end
	end
end