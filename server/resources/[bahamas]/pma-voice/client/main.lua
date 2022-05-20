local Cfg = Cfg
local currentGrid = 0

local volumes = {
	["radio"] = 0.6,
	["phone"] = 0.6
}

local micClicks = true
plyState = LocalPlayer.state
playerServerId = GetPlayerServerId(PlayerId())
radioEnabled,radioPressed,mode,radioChannel,callChannel = false,false,2,0,0

radioData = {}
callData = {}

AddEventHandler("pma-voice:settingsCallback",function(cb)
	cb(Cfg)
end)

RegisterCommand("volume",function(source,args)
	if args[1] then
		if tonumber(args[1]) >= 1 and tonumber(args[1]) <= 100 then
			local volume = tonumber(args[1])
			TriggerEvent("Notify","amarelo","<b>Volume:</b> "..volume.."%",5000)
			setVolume(volume / 100)
		end
	end
end)

function setVolume(volume,volumeType)
	local volume = tonumber(volume)
	local checkType = type(volume)
	if checkType ~= "number" then
		return
	end

	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			plyState:set(volumeType,volume,GetConvarInt("voice_syncData",0) == 1)
			volumes[volumeType] = volume
		end
	else
		for types,vol in pairs(volumes) do
			volumes[types] = volume
			plyState:set(types,volume,GetConvarInt("voice_syncData",0) == 1)
		end
	end
end
exports("setVolume",setVolume)

exports("setRadioVolume",function(vol)
	setVolume(vol,"radio")
end)

exports("getRadioVolume",function()
	return volumes["radio"]
end)

exports("setCallVolume",function(vol)
	setVolume(vol,"phone")
end)

exports("getCallVolume",function()
	return volumes["phone"]
end)

local radioEffectId = CreateAudioSubmix("Radio")
SetAudioSubmixEffectRadioFx(radioEffectId,0)
SetAudioSubmixEffectParamInt(radioEffectId,0,GetHashKey("default"),1)
AddAudioSubmixOutput(radioEffectId,0)

local phoneEffectId = CreateAudioSubmix("Phone")
SetAudioSubmixEffectRadioFx(phoneEffectId,1)
SetAudioSubmixEffectParamInt(phoneEffectId,1,GetHashKey("default"),1)
SetAudioSubmixEffectParamFloat(phoneEffectId,1,GetHashKey("freq_low"),300.0)
SetAudioSubmixEffectParamFloat(phoneEffectId,1,GetHashKey("freq_hi"),6000.0)
AddAudioSubmixOutput(phoneEffectId,1)

local submixFunctions = {
	["radio"] = function(plySource)
		MumbleSetSubmixForServerId(plySource,radioEffectId)
	end,
	["phone"] = function(plySource)
		MumbleSetSubmixForServerId(plySource,phoneEffectId)
	end
}

local disableSubmixReset = {}
function toggleVoice(plySource,enabled,moduleType)
	if enabled then
		MumbleSetVolumeOverrideByServerId(plySource,enabled and volumes[moduleType])
		if moduleType then
			disableSubmixReset[plySource] = true
			submixFunctions[moduleType](plySource)
		else
			MumbleSetSubmixForServerId(plySource,-1)
		end
	else
		disableSubmixReset[plySource] = nil
		SetTimeout(250,function()
			if not disableSubmixReset[plySource] then
				MumbleSetSubmixForServerId(plySource,-1)
			end
		end)

		MumbleSetVolumeOverrideByServerId(plySource,-1.0)
	end
end

function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1,#targets do
		for id,_ in pairs(targets[i]) do
			if addedPlayers[id] and id ~= playerServerId then
				goto skip_loop
			end

			if not addedPlayers[id] then
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(1,id)
			end

			::skip_loop::
		end
	end
end

function playMicClicks(clickType)
	if micClicks ~= "true" then return end
	SendNUIMessage({ sound = (clickType and "audio_on" or "audio_off"), volume = (clickType and (volume) or 0.05) })
end

local playerMuted = false
RegisterCommand("+cycleproximity",function()
	if playerMuted then return end

	local voiceMode = mode
	local newMode = voiceMode + 1

	voiceMode = (newMode <= #Cfg.voiceModes and newMode) or 1
	local voiceModeData = Cfg.voiceModes[voiceMode]
	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	mode = voiceMode
	plyState:set("proximity",{
		index = voiceMode,
		distance = voiceModeData[1],
		mode = voiceModeData[2]
	},GetConvarInt("voice_syncData",0) == 1)
	SendNUIMessage({ voiceMode = voiceMode - 1 })
	TriggerEvent("pma-voice:setTalkingMode",voiceMode)
end,false)

RegisterCommand("-cycleproximity",function()
end)

RegisterKeyMapping("+cycleproximity","Distancia da fala","keyboard","HOME")

function toggleMute()
	playerMuted = not playerMuted
	
	if playerMuted then
		plyState:set("proximity",{
			index = 0,
			distance = 0.1,
			mode = "Muted",
		},GetConvarInt("voice_syncData",0) == 1)
		MumbleSetAudioInputDistance(0.1)
	else
		local voiceModeData = Cfg.voiceModes[mode]
		plyState:set("proximity",{
			index = mode,
			distance = voiceModeData[1],
			mode = voiceModeData[2]
		},GetConvarInt("voice_syncData",0) == 1)
		MumbleSetAudioInputDistance(Cfg.voiceModes[mode][1])
	end
end
exports("toggleMute",toggleMute)
RegisterNetEvent("pma-voice:toggleMute",toggleMute)

local mutedTbl = {}
function toggleMutePlayer(source)
	if mutedTbl[source] then
		mutedTbl[source] = nil
		MumbleSetVolumeOverrideByServerId(source,-1.0)
	else
		mutedTbl[source] = true
		MumbleSetVolumeOverrideByServerId(source,0.0)
	end
end
exports("toggleMutePlayer",toggleMutePlayer)

function setVoiceProperty(type,value)
	if type == "radioEnabled" then
		radioEnabled = value
		SendNUIMessage({ radioEnabled = value })
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp("pma-voice_enableMicClicks",val)
	end
end
exports("setVoiceProperty",setVoiceProperty)
exports("SetMumbleProperty",setVoiceProperty)
exports("SetTokoProperty",setVoiceProperty)

local currentRouting = 0
local nextRoutingRefresh = GetGameTimer()
local overrideCoords = false

function setOverrideCoords(coords)
	local coordType = type(coords)
	if coordType ~= "vector3" and coordType ~= "boolean" then
		return
	end
	overrideCoords = coords
end
exports("setOverrideCoords",setOverrideCoords)

function getMaxSize(zoneRadius)
	return math.floor(math.max(4500.0 + 8192.0, 0.0) / zoneRadius + math.max(8022.0 + 8192.0, 0.0) / zoneRadius)
end

local function getGridZone()
	local plyPos = overrideCoords or GetEntityCoords(PlayerPedId(),false)
	local zoneRadius = 256
	if nextRoutingRefresh < GetGameTimer() then
		nextRoutingRefresh = GetGameTimer() + 500
		currentRouting = LocalPlayer.state.routingBucket or 0
	end

	local sectorX = math.max(plyPos.x + 8192.0, 0.0) / zoneRadius
	local sectorY = math.max(plyPos.y + 8192.0, 0.0) / zoneRadius

	return (math.ceil(sectorX + sectorY) + (currentRouting * getMaxSize(zoneRadius)))
end

local lastGridChange = GetGameTimer()

local function updateZone(forced)
	local newGrid = getGridZone()
	if newGrid ~= currentGrid or forced then
		lastGridChange = GetGameTimer()
		currentGrid = newGrid
		MumbleClearVoiceTargetChannels(1)
		NetworkSetVoiceChannel(currentGrid)
		LocalPlayer.state:set("grid",currentGrid,true)

		for nearbyGrids = currentGrid - 3,currentGrid + 3 do
			MumbleAddVoiceTargetChannel(1,nearbyGrids)
		end
	end
end

local lastTalkingStatus = false
local lastRadioStatus = false
CreateThread(function()
	while true do
		while not MumbleIsConnected() do
			currentGrid = -1
			Wait(100)
		end

		updateZone()

		if lastRadioStatus ~= radioPressed or lastTalkingStatus ~= (NetworkIsPlayerTalking(PlayerId()) == 1) then
			lastRadioStatus = radioPressed
			lastTalkingStatus = NetworkIsPlayerTalking(PlayerId()) == 1

			TriggerEvent("hud:userTalking",lastTalkingStatus)
		end

		Wait(200)
	end
end)

RegisterCommand("vsync",function()
	local newGrid = getGridZone()

	NetworkSetVoiceChannel(newGrid + 100)
	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(1)
	MumbleSetVoiceTarget(1)
	MumbleClearVoiceTargetPlayers(1)
	updateZone(true)
end)

AddEventHandler("onClientResourceStart",function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end

	local micClicksKvp = GetResourceKvpString("pma-voice_enableMicClicks")
	if not micClicksKvp then
		SetResourceKvp("pma-voice_enableMicClicks",tostring(true))
	else
		micClicks = micClicksKvp
	end

	local voiceModeData = Cfg.voiceModes[mode]

	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	plyState:set("proximity",{
		index = mode,
		distance = voiceModeData[1],
		mode = voiceModeData[2]
	},GetConvarInt("voice_syncData",0) == 1)

	MumbleSetAudioOutputDistance(Cfg.voiceModes[#Cfg.voiceModes][1] + 0.0)

	while not MumbleIsConnected() do
		Wait(250)
	end

	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(1)
	MumbleSetVoiceTarget(1)

	updateZone()
end)

AddEventHandler("mumbleConnected",function(address,shouldReconnect)
	Wait(1000)
	updateZone(true)
end)

AddEventHandler("mumbleDisconnected",function(address)
	currentGrid = -1
end)