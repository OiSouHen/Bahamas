function removePlayerFromRadio(source,radioChannel)
	radioData[radioChannel] = radioData[radioChannel] or {}

	for player,_ in pairs(radioData[radioChannel]) do
		TriggerClientEvent("pma-voice:removePlayerFromRadio",player,source)
	end

	radioData[radioChannel][source] = nil
	voiceData[source] = voiceData[source] or defaultTable(source)
	voiceData[source].radio = 0
end

function addPlayerToRadio(source,radioChannel)
	radioData[radioChannel] = radioData[radioChannel] or {}

	for player,_ in pairs(radioData[radioChannel]) do
		TriggerClientEvent("pma-voice:addPlayerToRadio",player,source)
	end

	voiceData[source] = voiceData[source] or defaultTable(source)

	voiceData[source].radio = radioChannel
	radioData[radioChannel][source] = false
	TriggerClientEvent("pma-voice:syncRadioData",source,radioData[radioChannel])
end

function setPlayerRadio(source,radioChannel)
	if GetInvokingResource() then
		TriggerClientEvent("pma-voice:clSetPlayerRadio",source,radioChannel)
	end

	voiceData[source] = voiceData[source] or defaultTable(source)
	local plyVoice = voiceData[source]
	local radioChannel = tonumber(radioChannel)

	if not radioChannel then return end

	if radioChannel ~= 0 and plyVoice.radio == 0 then
		addPlayerToRadio(source,radioChannel)
	elseif radioChannel == 0 then
		removePlayerFromRadio(source,plyVoice.radio)
	elseif plyVoice.radio > 0 then
		removePlayerFromRadio(source,plyVoice.radio)
		addPlayerToRadio(source,radioChannel)
	end
end
exports("setPlayerRadio",setPlayerRadio)

RegisterNetEvent("pma-voice:setPlayerRadio",function(radioChannel)
	setPlayerRadio(source,radioChannel)
end)

function setTalkingOnRadio(talking)
	voiceData[source] = voiceData[source] or defaultTable(source)
	local plyVoice = voiceData[source]
	local radioTbl = radioData[plyVoice.radio]
	if radioTbl then
		for player,_ in pairs(radioTbl) do
			if player ~= source then
				TriggerClientEvent("pma-voice:setTalkingOnRadio",player,source,talking)
			end
		end
	end
end
RegisterNetEvent("pma-voice:setTalkingOnRadio",setTalkingOnRadio)