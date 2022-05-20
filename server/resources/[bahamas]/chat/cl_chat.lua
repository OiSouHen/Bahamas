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
Tunnel.bindInterface("chat",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chatOpen = false
local chatActive = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chatMessage")
AddEventHandler("chatMessage",function(author,color,text)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() then
		if chatActive then
			local args = { text }
			if author ~= "" then
				table.insert(args,1,author)
			end

			SendNUIMessage({ type = "ON_MESSAGE", message = { color = color, multiline = true, args = args } })
			SendNUIMessage({ type = "ON_SCREEN_STATE_CHANGE", shouldHide = false })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chatME")
AddEventHandler("chatME",function(text)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() then
		if chatActive then
			SendNUIMessage({ type = "ON_MESSAGE", message = { color = {}, multiline = true, args = { text } } })
			SendNUIMessage({ type = "ON_SCREEN_STATE_CHANGE", shouldHide = false })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERPRINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("__cfx_internal:serverPrint")
AddEventHandler("__cfx_internal:serverPrint",function(msg)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() then
		SendNUIMessage({ type = "ON_MESSAGE", message = { templateId = "print", multiline = true, args = { msg } } })
		chatOpen = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:addMessage")
AddEventHandler("chat:addMessage",function(message)
	SendNUIMessage({ type = "ON_MESSAGE", message = message })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:clear")
AddEventHandler("chat:clear",function(name)
	SendNUIMessage({ type = "ON_CLEAR" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARSUGGESTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:clearSuggestions")
AddEventHandler("chat:clearSuggestions",function()
	SendNUIMessage({ type = "ON_SUGGESTIONS_REMOVE" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATRESULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("chatResult",function(data,cb)
	SetNuiFocus(false)

	if data["message"] then
		if data["message"]:sub(1,1) == "/" then
			ExecuteCommand(data["message"]:sub(2))
		else
			TriggerServerEvent("chat:messageEntered",data["message"])
		end
	end

	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSUGGESTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:addSuggestion")
AddEventHandler("chat:addSuggestion",function(suggestions)
	for _,v in ipairs(suggestions) do
		SendNUIMessage({ type = "ON_SUGGESTION_ADD", suggestion = v })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("loaded",function(data,cb)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chat",function(source,args)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() then
		if chatOpen then
			if chatActive then
				chatActive = false
				SendNUIMessage({ type = "ON_CLEAR" })
			else
				chatActive = true
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("openChat",function(source,args)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() then
		chatOpen = true
		SetNuiFocus(true)
		SendNUIMessage({ type = "ON_OPEN" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("openChat","Abrir chat","keyboard","t")
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSCHAT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.statusChat()
	return chatOpen
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSCHAT
-----------------------------------------------------------------------------------------------------------------------------------------
function statusChat()
	return chatOpen
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("statusChat",statusChat)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onClientResourceStart",function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	local mHash = GetHashKey("mp_m_freemode_01")

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	if HasModelLoaded(mHash) then
		SetPlayerModel(PlayerId(),mHash)
		SetModelAsNoLongerNeeded(mHash)
		FreezeEntityPosition(PlayerPedId(),false)
	end

	TriggerEvent("spawn:generateJoin")
	TriggerServerEvent("Queue:playerConnect")

	ShutdownLoadingScreen()
end)