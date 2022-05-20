function syncRadioData(radioTable)
	radioData = radioTable

	for tgt,enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt,enabled,"radio")
		end
	end
end
RegisterNetEvent("pma-voice:syncRadioData",syncRadioData)

function setTalkingOnRadio(plySource,enabled)
	toggleVoice(plySource,enabled,"radio")
	radioData[plySource] = enabled
end
RegisterNetEvent("pma-voice:setTalkingOnRadio",setTalkingOnRadio)

function addPlayerToRadio(plySource)
	radioData[plySource] = false

	if radioPressed then
		playerTargets(radioData,NetworkIsPlayerTalking(PlayerId()) and callData or {})
	end
end
RegisterNetEvent("pma-voice:addPlayerToRadio",addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		for tgt,enabled in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt,false,"radio")
			end
		end

		radioData = {}
		playerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
		plyState:set("radioChannel",0,GetConvarInt("voice_syncData",0) == 1)
	else
		radioData[plySource] = nil
		toggleVoice(plySource,false)

		if radioPressed then
			playerTargets(radioData,NetworkIsPlayerTalking(PlayerId()) and callData or {})
		end
	end
end
RegisterNetEvent("pma-voice:removePlayerFromRadio",removePlayerFromRadio)

function setRadioChannel(channel)
	radioEnabled = true
	radioChannel = channel
	TriggerServerEvent("pma-voice:setPlayerRadio",channel)
	plyState:set("radioChannel",channel,GetConvarInt("voice_syncData",0) == 1)

	SendNUIMessage({ radioChannel = channel, radioEnabled = radioEnabled })
end

exports("setRadioChannel",setRadioChannel)
exports("SetRadioChannel",setRadioChannel)

exports("removePlayerFromRadio",function()
	radioEnabled = false
	setRadioChannel(0)
end)

exports("addPlayerToRadio",function(radio)
	local radio = tonumber(radio)
	if radio then
		setRadioChannel(radio)
	end
end)

RegisterCommand("+radiotalk",function()
	local ped = PlayerPedId()
	if IsPedSwimming(ped) or exports["player"]:handCuff() or IsPlayerFreeAiming(PlayerId()) then
		return
	end

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			playerTargets(radioData,NetworkIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent("pma-voice:setTalkingOnRadio",true)
			radioPressed = true
			playMicClicks(true)

			RequestAnimDict("random@arrests")
			while not HasAnimDictLoaded("random@arrests") do
				Wait(10)
			end
			TaskPlayAnim(ped,"random@arrests","generic_radio_chatter",8.0,0.0,-1,49,0,0,0,0)

			CreateThread(function()
				TriggerEvent("pma-voice:radioActive",true)

				while radioPressed do
					Wait(0)
					SetControlNormal(0,249,1.0)
					SetControlNormal(1,249,1.0)
					SetControlNormal(2,249,1.0)
					DisableControlAction(1,24,true)
					DisableControlAction(1,25,true)
					DisableControlAction(1,257,true)
					DisableControlAction(1,140,true)
					DisableControlAction(1,142,true)
				end
			end)
		end
	end
end,false)

RegisterCommand("-radiotalk",function()
	local ped = PlayerPedId()
	if IsPedSwimming(ped) or exports["player"]:handCuff() or IsPlayerFreeAiming(PlayerId()) then
		return
	end

	if radioChannel > 0 or radioEnabled and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(1)
		playerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive",false)
		playMicClicks(false)
		StopAnimTask(ped,"random@arrests","generic_radio_chatter",-4.0)
		TriggerServerEvent("pma-voice:setTalkingOnRadio",false)
	end
end,false)
RegisterKeyMapping("+radiotalk","Falar no rádio","keyboard","CAPITAL")

function syncRadio(_radioChannel)
	plyState:set("radioChannel",_radioChannel,GetConvarInt("voice_syncData",0) == 1)
	radioChannel = _radioChannel
end
RegisterNetEvent("pma-voice:clSetPlayerRadio",syncRadio)