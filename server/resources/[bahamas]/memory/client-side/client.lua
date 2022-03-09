local MinigameActive = false
local SuccessTrigger = nil
local FailTrigger = nil

function StartMinigame(data)
	if MinigameActive then
		return
	end

	if data ~= nil then
		SuccessTrigger = data["success"]
		FailTrigger = data["fail"]

		SendNUIMessage({ action = "start" })
		SetNuiFocus(true,true)
		MinigameActive = true
	end
end

function FailMinigame()
	SendNUIMessage({ action = "fail" })
	SetNuiFocus(false,false)
	MinigameActive = false
	SuccessTrigger = nil
	FailTrigger = nil
end

exports("StartMinigame",StartMinigame)
exports("FailMinigame",FailMinigame)

RegisterNUICallback("success",function(data,cb)
	if SuccessTrigger ~= nil then
		TriggerEvent(SuccessTrigger)
	end

	SetNuiFocus(false,false)
	MinigameActive = false
	SuccessTrigger = nil
	FailTrigger = nil

	cb("ok")
end)

RegisterNUICallback("fail",function(data,cb)
	if FailTrigger ~= nil then
		TriggerEvent(FailTrigger)
	end

	SetNuiFocus(false,false)
	MinigameActive = false
	SuccessTrigger = nil
	FailTrigger = nil

	cb("ok")
end)