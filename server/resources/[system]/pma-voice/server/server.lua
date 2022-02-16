voiceData = {}
radioData = {}
callData = {}

function defaultTable(source)
	return {
		radio = 0,
		call = 0,
		lastRadio = 0,
		lastCall = 0
	}
end

CreateThread(function()
	for i = 1,1024 do
		MumbleCreateChannel(i)
	end
end)

RegisterNetEvent("playerJoined",function()
	if not voiceData[source] then
		voiceData[source] = defaultTable(source)
		local plyState = Player(source).state
		plyState:set("routingBucket",0,true)

		if GetConvarInt("voice_syncData",0) == 1 then
			plyState:set("radio",0.6,true)
			plyState:set("phone",0.6,true)
			plyState:set("proximity",{},true)
			plyState:set("callChannel",0,true)
			plyState:set("radioChannel",0,true)
		end
	end
end)

function updateRoutingBucket(source,routingBucket)
	local route
	if routingBucket then
		SetPlayerRoutingBucket(source,routingBucket)
	else
		route = GetPlayerRoutingBucket(source)
	end
	Player(source).state:set("routingBucket",route or routingBucket,true)
end
exports("updateRoutingBucket",updateRoutingBucket)

AddEventHandler("playerDropped",function()
	local source = source
	if voiceData[source] then
		local plyData = voiceData[source]

		if plyData.radio ~= 0 then
			removePlayerFromRadio(source,plyData.radio)
		end

		if plyData.call ~= 0 then
			removePlayerFromCall(source,plyData.call)
		end

		voiceData[source] = nil
	end
end)

AddEventHandler("onResourceStart",function(resource)
	if resource ~= GetCurrentResourceName() then return end

	local players = GetPlayers()
	for i = 1,#players do
		local ply = players[i]
		if not voiceData[ply] then
			voiceData[ply] = defaultTable(ply)
			Player(ply).state:set("routingBucket",GetPlayerRoutingBucket(ply),true)
		end
	end
end)

function getPlayersInRadioChannel(channel)
	local returnChannel = radioData[channel]
	if returnChannel then
		return returnChannel
	end

	return {}
end
exports("getPlayersInRadioChannel",getPlayersInRadioChannel)
exports("GetPlayersInRadioChannel",getPlayersInRadioChannel)