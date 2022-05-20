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
Tunnel.bindInterface("barbershop",cRP)
vSERVER = Tunnel.getInterface("barbershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = -1
local myClothes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSkin",function(data)
	myClothes = {}
	myClothes = { tonumber(data["fathers"]),tonumber(data["kinship"]),tonumber(data["eyecolor"]),tonumber(data["skincolor"]),tonumber(data["acne"]),tonumber(data["stains"]),tonumber(data["freckles"]),tonumber(data["aging"]),tonumber(data["hair"]),tonumber(data["haircolor"]),tonumber(data["haircolor2"]),tonumber(data["makeup"]),tonumber(data["makeupintensity"]),tonumber(data["makeupcolor"]),tonumber(data["lipstick"]),tonumber(data["lipstickintensity"]),tonumber(data["lipstickcolor"]),tonumber(data["eyebrow"]),tonumber(data["eyebrowintensity"]),tonumber(data["eyebrowcolor"]),tonumber(data["beard"]),tonumber(data["beardintentisy"]),tonumber(data["beardcolor"]),tonumber(data["blush"]),tonumber(data["blushintentisy"]),tonumber(data["blushcolor"]),tonumber(data["face00"]),tonumber(data["face01"]),tonumber(data["face04"]),tonumber(data["face06"]),tonumber(data["face08"]),tonumber(data["face09"]),tonumber(data["face10"]),tonumber(data["face12"]),tonumber(data["face13"]),tonumber(data["face14"]),tonumber(data["face15"]),tonumber(data["face16"]),tonumber(data["face17"]),tonumber(data["face19"]),tonumber(data["mothers"]) }

	if data["value"] then
		SetNuiFocus(false)
		displayBarbershop(false)
		vSERVER.updateSkin(myClothes)
		SendNUIMessage({ openBarbershop = false })
	end

	TriggerEvent("barbershop:apply",myClothes)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATELEFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rotate",function(data,cb)
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)
	if data == "left" then
		SetEntityHeading(ped,heading + 10)
	elseif data == "right" then
		SetEntityHeading(ped,heading - 10)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("barbershop:apply")
AddEventHandler("barbershop:apply",function(status)
	myClothes = {}
	myClothes = { status[1] or 0, status[2] or 0, status[3] or 0, status[4] or 0, status[5] or 0, status[6] or 0, status[7] or 0, status[8] or 0, status[9] or 0, status[10] or 0, status[11] or 0, status[12] or 0, status[13] or 0, status[14] or 0, status[15] or 0, status[16] or 0, status[17] or 0, status[18] or 0, status[19] or 0, status[20] or 0, status[21] or 0, status[22] or 0, status[23] or 0, status[24] or 0, status[25] or 0, status[26] or 0, status[27] or 0, status[28] or 0, status[29] or 0, status[30] or 0, status[31] or 0, status[32] or 0, status[33] or 0, status[34] or 0, status[35] or 0, status[36] or 0, status[37] or 0, status[38] or 0, status[39] or 0, status[40] or 0, status[41] or 0 }

	local ped = PlayerPedId()

    local weightFace = myClothes[2] / 100 + 0.0
    local weightSkin = myClothes[4] / 100 + 0.0

	SetPedHeadBlendData(ped,myClothes[41],myClothes[1],0,myClothes[41],myClothes[1],0,weightFace,weightSkin,0.0,false)

	SetPedEyeColor(ped,myClothes[3])

	if myClothes[5] == 0 then
		SetPedHeadOverlay(ped,0,myClothes[5],0.0)
	else
		SetPedHeadOverlay(ped,0,myClothes[5],1.0)
	end

	SetPedHeadOverlay(ped,6,myClothes[6],1.0)

	if myClothes[7] == 0 then
		SetPedHeadOverlay(ped,9,myClothes[7],0.0)
	else
		SetPedHeadOverlay(ped,9,myClothes[7],1.0)
	end

	SetPedHeadOverlay(ped,3,myClothes[8],1.0)

	SetPedComponentVariation(ped,2,myClothes[9],0,1)
	SetPedHairColor(ped,myClothes[10],myClothes[11])

	SetPedHeadOverlay(ped,4,myClothes[12],myClothes[13] * 0.1)
	SetPedHeadOverlayColor(ped,4,1,myClothes[14],myClothes[14])

	SetPedHeadOverlay(ped,8,myClothes[15],myClothes[16] * 0.1)
	SetPedHeadOverlayColor(ped,8,1,myClothes[17],myClothes[17])

	SetPedHeadOverlay(ped,2,myClothes[18],myClothes[19] * 0.1)
	SetPedHeadOverlayColor(ped,2,1,myClothes[20],myClothes[20])

	SetPedHeadOverlay(ped,1,myClothes[21],myClothes[22] * 0.1)
	SetPedHeadOverlayColor(ped,1,1,myClothes[23],myClothes[23])

	SetPedHeadOverlay(ped,5,myClothes[24],myClothes[25] * 0.1)
	SetPedHeadOverlayColor(ped,5,1,myClothes[26],myClothes[26])

	SetPedFaceFeature(ped,0,myClothes[27] * 0.1)
	SetPedFaceFeature(ped,1,myClothes[28] * 0.1)
	SetPedFaceFeature(ped,4,myClothes[29] * 0.1)
	SetPedFaceFeature(ped,6,myClothes[30] * 0.1)
	SetPedFaceFeature(ped,8,myClothes[31] * 0.1)
	SetPedFaceFeature(ped,9,myClothes[32] * 0.1)
	SetPedFaceFeature(ped,10,myClothes[33] * 0.1)
	SetPedFaceFeature(ped,12,myClothes[34] * 0.1)
	SetPedFaceFeature(ped,13,myClothes[35] * 0.1)
	SetPedFaceFeature(ped,14,myClothes[36] * 0.1)
	SetPedFaceFeature(ped,15,myClothes[37] * 0.1)
	SetPedFaceFeature(ped,16,myClothes[38] * 0.1)
	SetPedFaceFeature(ped,17,myClothes[39] * 0.1)
	SetPedFaceFeature(ped,19,myClothes[40] * 0.1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function displayBarbershop(enable)
	local ped = PlayerPedId()

	if enable then
		SetEntityHeading(PlayerPedId(),332.21)
		SetFollowPedCamViewMode(0)
		SetNuiFocus(true,true)
		SendNUIMessage({ openBarbershop = true, maxHair = GetNumberOfPedDrawableVariations(ped,2) - 1, fathers = myClothes[1], mothers = myClothes[41], kinship = myClothes[2], eyecolor = myClothes[3], skincolor = myClothes[4], acne = myClothes[5], stains = myClothes[6], freckles = myClothes[7], aging = myClothes[8], hair = myClothes[9], haircolor = myClothes[10], haircolor2 = myClothes[11], makeup = myClothes[12], makeupintensity = myClothes[13], makeupcolor = myClothes[14], lipstick = myClothes[15], lipstickintensity = myClothes[16], lipstickcolor = myClothes[17], eyebrow = myClothes[18], eyebrowintensity = myClothes[19], eyebrowcolor = myClothes[20], beard = myClothes[21], beardintentisy = myClothes[22], beardcolor = myClothes[23], blush = myClothes[24], blushintentisy = myClothes[25], blushcolor = myClothes[26], face00 = myClothes[27], face01 = myClothes[28], face04 = myClothes[29], face06 = myClothes[30], face08 = myClothes[31], face09 = myClothes[32], face10 = myClothes[33], face12 = myClothes[34], face13 = myClothes[35], face14 = myClothes[36], face15 = myClothes[37], face16 = myClothes[38], face17 = myClothes[39], face19 = myClothes[40] })

		if IsDisabledControlJustReleased(0,24) or IsDisabledControlJustReleased(0,142) then
			SendNUIMessage({ type = "click" })
		end

		SetPlayerInvincible(ped,true)

		if not DoesCamExist(cam) then
			cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
			SetCamCoord(cam,GetEntityCoords(ped))
			SetCamRot(cam,0.0,0.0,0.0)
			SetCamActive(cam,true)
			RenderScriptCams(true,false,0,true,true)
			SetCamCoord(cam,GetEntityCoords(ped))
		end

		local x,y,z = table.unpack(GetEntityCoords(ped))
		SetCamCoord(cam,x + 0.2,y + 0.5,z + 0.7)
		SetCamRot(cam,0.0,0.0,150.0)
	else
		SetPlayerInvincible(ped,false)
		RenderScriptCams(false,false,0,1,0)
		DestroyCam(cam,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false)
	SendNUIMessage({ openBarbershop = false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local locations = {
	{ -813.37,-183.85,37.57 },
	{ 138.13,-1706.46,29.3 },
	{ -1280.92,-1117.07,7.0 },
	{ 1930.54,3732.06,32.85 },
	{ 1214.2,-473.18,66.21 },
	{ -33.61,-154.52,57.08 },
	{ -276.65,6226.76,31.7 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local innerTable = {}
	for k,v in pairs(locations) do
		table.insert(innerTable,{ v[1],v[2],v[3],2.5,"E","Barbearia","Pressione para abrir" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(locations) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2.5 then
					timeDistance = 1

					if IsControlJustPressed(1,38) and vSERVER.checkShares() then
						displayBarbershop(true)
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea",function(x,y,z,distance)
	ClearAreaOfVehicles(x,y,z,distance + 0.0,false,false,false,false,false)
	ClearAreaOfEverything(x,y,z,distance + 0.0,false,false,false,false)
end)