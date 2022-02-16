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
Tunnel.bindInterface("taskbar",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chance = 0
local skillGap = 0
local activeTasks = 0
local taskInProcess = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENGUI
-----------------------------------------------------------------------------------------------------------------------------------------
function openGui(sentLength,taskID,chancesent,skillGapSent)
	SetNuiFocus(true,false)
	SendNUIMessage({ runProgress = true, Length = sentLength, Task = taskID, chance = chancesent, skillGap = skillGapSent })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEGUI
-----------------------------------------------------------------------------------------------------------------------------------------
function updateGui(sentLength,taskID,chancesent,skillGapSent)
	SendNUIMessage({ runUpdate = true, Length = sentLength, Task = taskID, chance = chancesent, skillGap = skillGapSent })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSEGUI
-----------------------------------------------------------------------------------------------------------------------------------------
function closeGui()
	SetNuiFocus(false,false)
	SendNUIMessage({ closeProgress = true })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSENORMALGUI
-----------------------------------------------------------------------------------------------------------------------------------------
function closeNormalGui()
	SetNuiFocus(false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKEND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("taskEnd",function(data,cb)
	closeNormalGui()

	if (tonumber(data["taskResult"]) > chance) and tonumber(data["taskResult"]) < (chance + skillGap + 3) then
		activeTasks = 3
	else
		activeTasks = 2
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKBAR
-----------------------------------------------------------------------------------------------------------------------------------------
function taskBar(difficulty,skillGapSent)
	skillGap = skillGapSent

	if skillGap < 5 then
		skillGap = 5
	end

	if taskInProcess then
		return false
	end

	chance = math.random(20,80)

	local length = math.ceil(difficulty * 1.0)

	taskInProcess = true
	local taskIdentifier = "taskid"..math.random(1000000)
	openGui(length,taskIdentifier,chance,skillGap)
	activeTasks = 1

	local maxcount = GetGameTimer() + length

	while activeTasks == 1 do
		Citizen.Wait(1)

		local curTime = GetGameTimer()
		if curTime > maxcount then
			activeTasks = 2
		end

		local updater = 100 - (((maxcount - curTime) / length) * 100)
		updater = math.min(100,updater)
		updateGui(updater,taskIdentifier,chance,skillGap)
	end

	closeGui()
	taskInProcess = false

	if activeTasks == 2 then
		return false
	else
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKONE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskOne()
	local rand = math.random(6,10)
	local finished = taskBar(1500,rand)
	if finished then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKTWO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskTwo()
	local rand = math.random(6,10)
	local finished = taskBar(2000,rand)
	if finished then
		local finished = taskBar(1500,rand)
		if finished then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKTHREE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskThree()
	local rand = math.random(6,10)
	local finished = taskBar(2500,rand)
	if finished then
		local finished = taskBar(2000,rand)
		if finished then
			local finished = taskBar(1500,rand)
			if finished then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKMECHANIC
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskMechanic()
	local rand = math.random(6,10)
	local finished = taskBar(7500,rand)
	if finished then
		local finished = taskBar(5000,rand)
		if finished then
			local finished = taskBar(2500,rand)
			if finished then
				local finished = taskBar(1000,rand)
				if finished then
					return true
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKFISHING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskFishing()
	local rand = math.random(6,10)
	local finished = taskBar(20000,rand)
	if finished then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskHandcuff()
	local rand = math.random(6,10)
	local finished = taskBar(1000,rand)
	if finished then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKTHREE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskLockpick()
	local rand = math.random(6,10)
	local finished = taskBar(2500,rand)
	if finished then
		local finished = taskBar(2000,rand)
		if finished then
			local finished = taskBar(1500,rand)
			if finished then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKTHREE
-----------------------------------------------------------------------------------------------------------------------------------------
function taskThree()
	local rand = math.random(6,10)
	local finished = taskBar(2500,rand)
	if finished then
		local finished = taskBar(2000,rand)
		if finished then
			local finished = taskBar(1500,rand)
			if finished then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function taskHomes()
	local rand = math.random(6,10)
	local finished = taskBar(4500,rand)
	if finished then
		local finished = taskBar(3500,rand)
		if finished then
			local finished = taskBar(2500,rand)
			if finished then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.taskDoors()
	local rand = math.random(6,10)
	local finished = taskBar(1000,rand)
	if finished then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("taskThree",taskThree)
exports("taskHomes",taskHomes)