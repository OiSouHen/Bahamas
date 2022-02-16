-----------------------------------------------------------------------------------------------------------------------------------------
-- LANG
-----------------------------------------------------------------------------------------------------------------------------------------
local Lang = {
	join = "Entrando...",
	connecting = "Conectando...",
	position = "Você é o %d/%d da fila, aguarde sua conexão",
	steam = "Não foi possível identificar sua conexão com a Steam.",
	connecterror = "Não foi possível adiciona-lo na fila de conexão.",
	error = "Não foi possível dar continuidade a sua conexão na fila."
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Queue = {}
Queue.QueueList = {}
Queue.PlayerList = {}
Queue.PlayerCount = 0
Queue.Connecting = {}
Queue.ThreadCount = 0
local maxPlayers = 1024
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEAMRUNNING
-----------------------------------------------------------------------------------------------------------------------------------------
function steamRunning(source)
	local result = false
	local identifiers = GetPlayerIdentifiers(source)
	for _,v in pairs(identifiers) do
		if string.find(v,"steam") then
			result = true
			break
		end
	end

	return result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INQUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
function getQueue(ids,trouble,source,connect)
	for k,v in ipairs(connect and Queue.Connecting or Queue.QueueList) do
		local inQueue = false

		if not source then
			for _,i in ipairs(v["ids"]) do
				if inQueue then
					break
				end

				for _,o in ipairs(ids) do
					if o == i then
						inQueue = true
						break
					end
				end
			end
		else
			inQueue = ids == v["source"]
		end

		if inQueue then
			if trouble then
				return k,connect and Queue.Connecting[k] or Queue.QueueList[k]
			end

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISPRIORITY
-----------------------------------------------------------------------------------------------------------------------------------------
function isPriority(identifiers)
	local resultPriority = 0

	for _,v in pairs(identifiers) do
		if string.find(v,"steam") then
			local splitName = splitString(v,":")
			local infoAccount = vRP.infoAccount(splitName[2])
			if infoAccount then
				resultPriority = infoAccount["priority"]
				break
			end
		end
	end

	return resultPriority
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDQUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
function addQueue(ids,connectTime,name,source,deferrals)
	if getQueue(ids) then
		return
	end

	local tmp = { source = source, ids = ids, name = name, firstconnect = connectTime, priority = isPriority(ids), timeout = 0, deferrals = deferrals }

	local _pos = false
	local queueCount = #Queue.QueueList + 1

	for k,v in ipairs(Queue.QueueList) do
		if tmp["priority"] then
			if not v["priority"] then
				_pos = k
			else
				if tmp["priority"] > v["priority"] then
					_pos = k
				end
			end

			if _pos then
				break
			end
		end
	end

	if not _pos then
		_pos = #Queue.QueueList + 1
	end

	table.insert(Queue.QueueList,_pos,tmp)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEQUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
function removeQueue(ids,source)
	if getQueue(ids,false,source) then
		local pos,data = getQueue(ids,true,source)
		table.remove(Queue.QueueList,pos)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function isConnect(ids,source,refresh)
	local k,v = getQueue(ids,refresh and true or false,source and true or false,true)

	if not k then
		return false
	end

	if refresh and k and v then
		Queue.Connecting[k]["timeout"] = 0
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVECONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function removeConnect(ids,source)
	for k,v in ipairs(Queue.Connecting) do
		local connect = false

		if not source then
			for _,i in ipairs(v["ids"]) do
				if connect then
					break
				end

				for _,o in ipairs(ids) do
					if o == i then
						connect = true
						break
					end
				end
			end
		else
			connect = ids == v["source"]
		end

		if connect then
			table.remove(Queue.Connecting,k)
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function addConnect(ids,ignorePos,autoRemove,done)
	local function removeFromQueue()
		if not autoRemove then
			return
		end

		done(Lang.connecterror)
		removeConnect(ids)
		removeQueue(ids)
	end

	if #Queue.Connecting >= 100 then
		removeFromQueue()
		return false
	end

	if isConnect(ids) then
		removeConnect(ids)
	end

	local pos,data = getQueue(ids,true)
	if not ignorePos and (not pos or pos > 1) then
		removeFromQueue()
		return false
	end

	table.insert(Queue.Connecting,data)
	removeQueue(ids)
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEAMIDS
-----------------------------------------------------------------------------------------------------------------------------------------
function steamIds(source)
	return GetPlayerIdentifiers(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function updateData(source,ids,deferrals)
	local pos,data = getQueue(ids,true)
	Queue.QueueList[pos]["ids"] = ids
	Queue.QueueList[pos]["timeout"] = 0
	Queue.QueueList[pos]["source"] = source
	Queue.QueueList[pos]["deferrals"] = deferrals
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function notFull(firstJoin)
	local canJoin = Queue.PlayerCount + #Queue.Connecting < maxPlayers and #Queue.Connecting < 100
	if firstJoin and canJoin then
		canJoin = #Queue.QueueList <= 1
	end

	return canJoin
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function setPosition(ids,newPos)
	local pos,data = getQueue(ids,true)
	table.remove(Queue.QueueList,pos)
	table.insert(Queue.QueueList,newPos,data)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local function playerConnect(name,setKickReason,deferrals)
		local source = source
		local ids = steamIds(source)
		local connectTime = os.time()
		local connecting = true

		deferrals.defer()

		Citizen.CreateThread(function()
			while connecting do
				Citizen.Wait(500)
				if not connecting then
					return
				end
				deferrals.update(Lang.connecting)
			end
		end)

		Citizen.Wait(1000)

		local function done(message)
			connecting = false
			Citizen.CreateThread(function()
				if message then
					deferrals.update(tostring(message) and tostring(message) or "")
				end

				Citizen.Wait(1000)

				if message then
					deferrals.done(tostring(message) and tostring(message) or "")
					CancelEvent()
				end
			end)
		end

		local function update(message)
			connecting = false
			deferrals.update(tostring(message) and tostring(message) or "")
		end

		if not steamRunning(source) then
			done(Lang.steam)
			CancelEvent()
			return
		end

		local reason = "Removido da fila."

		local function setReason(message)
			reason = tostring(message)
		end

		TriggerEvent("Queue:playerJoinQueue",source,setReason)

		if WasEventCanceled() then
			done(reason)

			removeQueue(ids)
			removeConnect(ids)

			CancelEvent()
			return
		end

		local rejoined = false

		if getQueue(ids) then
			rejoined = true
			updateData(source,ids,deferrals)
		else
			addQueue(ids,connectTime,name,source,deferrals)
		end

		if isConnect(ids,false,true) then
			removeConnect(ids)

			if notFull() then
				local added = addConnect(ids,true,true,done)
				if not added then
					CancelEvent()
					return
				end

				done()
				TriggerEvent("Queue:playerConnecting",source,ids,deferrals)

				return
			else
				addQueue(ids,connectTime,name,source,deferrals)
				setPosition(ids,1)
			end
		end

		local pos,data = getQueue(ids,true)

		if not pos or not data then
			done(Lang.error)
			RemoveFromQueue(ids)
			RemoveFromConnecting(ids)
			CancelEvent()
			return
		end

		if notFull(true) then
			local added = addConnect(ids,true,true,done)
			if not added then
				CancelEvent()
				return
			end

			done()

			TriggerEvent("Queue:playerConnecting",source,ids,deferrals)

			return
		end

		update(string.format(Lang.position,pos,#Queue.QueueList))

		Citizen.CreateThread(function()
			if rejoined then
				return
			end

			Queue.ThreadCount = Queue.ThreadCount + 1
			local dotCount = 0

			while true do
				Citizen.Wait(1000)
				local dots = ""

				dotCount = dotCount + 1
				if dotCount > 3 then
					dotCount = 0
				end

				for i = 1,dotCount do
					dots = dots.."."
				end

				local pos,data = getQueue(ids,true)

				if not pos or not data then
					if data and data.deferrals then
						data.deferrals.done(Lang.error)
					end

					CancelEvent()
					removeQueue(ids)
					removeConnect(ids)
					Queue.ThreadCount = Queue.ThreadCount - 1
					return
				end

				if pos <= 1 and notFull() then
					local added = addConnect(ids)
					data.deferrals.update(Lang.join)
					Citizen.Wait(500)

					if not added then
						data.deferrals.done(Lang.connecterror)
						CancelEvent()
						Queue.ThreadCount = Queue.ThreadCount - 1
						return
					end

					data.deferrals.update("Carregando conexão com o servidor.")

					removeQueue(ids)
					Queue.ThreadCount = Queue.ThreadCount - 1

					TriggerEvent("Queue:playerConnecting",source,data.ids,data.deferrals)
					
					return
				end

				local message = string.format("Bahamas\n\n"..Lang.position.."%s\nEvite punições, fique por dentro das regras de conduta.\nAtualizações frequentes, deixe sua sugestão em nosso discord.",pos,#Queue.QueueList,dots)
				data.deferrals.update(message)
			end
		end)
	end

	AddEventHandler("playerConnecting",playerConnect)

	local function checkTimeOuts()
		local i = 1

		while i <= #Queue.QueueList do
			local data = Queue.QueueList[i]
			local lastMsg = GetPlayerLastMsg(data.source)

			if lastMsg == 0 or lastMsg >= 30000 then
				data.timeout = data.timeout + 1
			else
				data.timeout = 0
			end

			if not data.ids or not data.name or not data.firstconnect or data.priority == nil or not data.source then
				data.deferrals.done(Lang.error)
				table.remove(Queue.QueueList,i)
			elseif (data.timeout >= 120) and os.time() - data.firstconnect > 5 then
				data.deferrals.done(Lang.error)
				removeQueue(data.source,true)
				removeConnect(data.source,true)
			else
				i = i + 1
			end
		end

		i = 1

		while i <= #Queue.Connecting do
			local data = Queue.Connecting[i]
			local lastMsg = GetPlayerLastMsg(data.source)
			data.timeout = data.timeout + 1

			if ((data.timeout >= 300 and lastMsg >= 35000) or data.timeout >= 340) and os.time() - data.firstconnect > 5 then
				removeQueue(data.source,true)
				removeConnect(data.source,true)
			else
				i = i + 1
			end
		end

		SetTimeout(1000,checkTimeOuts)
	end

	checkTimeOuts()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Queue:playerConnect")
AddEventHandler("Queue:playerConnect",function()
	local source = source

	if not Queue.PlayerList[source] then
		local ids = steamIds(source)

		Queue.PlayerCount = Queue.PlayerCount + 1
		Queue.PlayerList[source] = true
		removeQueue(ids)
		removeConnect(ids)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	if Queue.PlayerList[source] then
		local ids = steamIds(source)

		Queue.PlayerCount = Queue.PlayerCount - 1
		Queue.PlayerList[source] = nil
		removeQueue(ids)
		removeConnect(ids)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEQUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Queue:removeQueue",function(ids)
	removeQueue(ids)
	removeConnect(ids)
end)