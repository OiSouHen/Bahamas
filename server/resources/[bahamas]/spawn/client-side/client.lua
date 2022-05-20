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
Tunnel.bindInterface("spawn",cRP)
vSERVER = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLocates = {}
local brokenCamera = false
local characterCamera = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- OTHERLOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local otherLocates = {
	{ -2205.92,-370.48,13.29,"Great Ocean Highway" },
	{ -250.35,6209.71,31.49,"Duluoz Avenue" },
	{ 1694.37,4794.66,41.92,"Grapedseed Avenue" },
	{ 1858.94,3741.78,33.09,"Armadillo Avenue" },
	{ 328.0,2617.89,44.48,"Senora Road" },
	{ 308.33,-232.25,54.07,"Hawick Avenue" },
	{ 449.71,-659.27,28.48,"Integrity Way" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:GENERATEJOIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:generateJoin")
AddEventHandler("spawn:generateJoin",function()
	DoScreenFadeOut(0)

	Wait(1000)

	local ped = PlayerPedId()
	characterCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",667.43,1025.9,378.87,340.0,0.0,342.0,60.0,false,0)
	SetCamActive(characterCamera,true)
	RenderScriptCams(true,false,1,true,true)
	SendNUIMessage({ action = "openSystem" })
	TriggerEvent("player:playerInvisible",true)
	SetEntityVisible(ped,false,false)
	SetNuiFocus(true,true)

	DoScreenFadeIn(0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEDISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("generateDisplay",function(data,cb)
	cb({ result = vSERVER.initSystem() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("characterChosen",function(data)
	vSERVER.characterChosen(data["id"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("newCharacter",function(data)
	vSERVER.newCharacter(data["name"],data["name2"],data["sex"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("generateSpawn",function(data,cb)
	cb({ result = spawnLocates })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JUSTSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:justSpawn")
AddEventHandler("spawn:justSpawn",function(status,spawnType)
	DoScreenFadeOut(0)

	spawnLocates = {}
	local ped = PlayerPedId()
	RenderScriptCams(false,false,0,true,true)
	SetCamActive(characterCamera,false)
	DestroyCam(characterCamera,true)
	characterCamera = nil

	if spawnType then
		TriggerEvent("player:playerInvisible",true)
		SetEntityVisible(ped,false,false)

		local numberLine = 0
		for k,v in pairs(status) do
			numberLine = numberLine + 1

			if k == "Modern" then
				spawnLocates[numberLine] = { x = v[1], y = v[2], z = v[3], name = "Pacific Bluffs", hash = numberLine }
			else
				local nameCoords = GetStreetNameAtCoord(v[1],v[2],v[3])
				local streetName = GetStreetNameFromHashKey(nameCoords)

				spawnLocates[numberLine] = { x = v[1], y = v[2], z = v[3], name = streetName, hash = numberLine }
			end
		end

		for k,v in pairs(otherLocates) do
			numberLine = numberLine + 1
			spawnLocates[numberLine] = { x = v[1], y = v[2], z = v[3], name = v[4], hash = numberLine }
		end

		Wait(2000)

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		characterCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",coords["x"],coords["y"],coords["z"] + 200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(characterCamera,true)
		RenderScriptCams(true,false,1,true,true)

		SendNUIMessage({ action = "openSpawn" })

		DoScreenFadeIn(1000)
	else
		TriggerEvent("player:playerInvisible",false)
		SetEntityVisible(ped,true,false)
		TriggerEvent("hudActived",true)
		SetNuiFocus(false,false)
		brokenCamera = false

		Wait(1000)

		DoScreenFadeIn(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSENEW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.closeNew()
	SendNUIMessage({ action = "closeNew" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnChosen",function(data)
	local ped = PlayerPedId()

	if data["hash"] == "spawn" then
		DoScreenFadeOut(0)

		SendNUIMessage({ action = "closeSpawn" })
		TriggerEvent("hudActived",true)
		SetNuiFocus(false,false)

		TriggerEvent("player:playerInvisible",false)
		RenderScriptCams(false,false,0,true,true)
		SetCamActive(characterCamera,false)
		DestroyCam(characterCamera,true)
		SetEntityVisible(ped,true,false)
		characterCamera = nil
		brokenCamera = false

		Wait(1000)

		DoScreenFadeIn(1000)
	else
		brokenCamera = false
		DoScreenFadeOut(0)

		Wait(1000)

		SetCamRot(characterCamera,270.0)
		SetCamActive(characterCamera,true)
		brokenCamera = true
		local speed = 0.7
		weight = 270.0

		DoScreenFadeIn(1000)

		SetEntityCoords(ped,spawnLocates[data["hash"]]["x"],spawnLocates[data["hash"]]["y"],spawnLocates[data["hash"]]["z"],1,0,0,0)
		local coords = GetEntityCoords(ped)

		SetCamCoord(characterCamera,coords["x"],coords["y"],coords["z"] + 200.0)
		local i = coords["z"] + 200.0

		while i > spawnLocates[data["hash"]]["z"] + 1.5 do
			i = i - speed
			SetCamCoord(characterCamera,coords["x"],coords["y"],i)

			if i <= spawnLocates[data["hash"]]["z"] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(characterCamera,weight)
			end

			if not brokenCamera then
				break
			end

			Wait(0)
		end
	end
end)