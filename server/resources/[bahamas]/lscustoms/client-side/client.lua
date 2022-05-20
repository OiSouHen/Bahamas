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
Tunnel.bindInterface("lscustoms",cRP)
vSERVER = Tunnel.getInterface("lscustoms")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local activeAdmin = false
local activeBennys = false
local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalPoliceLivery = nil
local originalPlateIndex = nil
local attemptingPurchase = false
local isPurchaseSuccessful = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local bennysLocations = {
	["police01"] = {
		pos = vector3(450.4,-975.81,25.7),
		heading = 90.00
	},
	["police02"] = {
		pos = vector3(435.28,-975.86,25.7),
		heading = 90.00
	},
	["paramedic01"] = {
		pos = vector3(333.34,-574.76,28.80),
		heading = 340.00
	},
	["bennys01"] = {
		pos = vector3(-339.15,-136.66,39.01),
		heading = 87.88
	},
	["bennys02"] = {
		pos = vector3(-1155.12,-2005.7,13.18),
		heading = 334.49
	},
	["bennys03"] = {
		pos = vector3(1174.98,2640.4,37.74),
		heading = 1.0
	},
	["bennys04"] = {
		pos = vector3(1182.14,2639.94,37.74),
		heading = 1.0
	},
	["bennys05"] = {
		pos = vector3(110.63,6626.54,31.78),
		heading = 224.94
	},
	["bennys06"] = {
		pos = vector3(105.26,6621.59,31.78),
		heading = 223.94
	},
	["bennys07"] = {
		pos = vector3(727.51,-1067.94,22.15),
		heading = 179.75
	},
	["bennys08"] = {
		pos = vector3(735.42,-1067.86,22.15),
		heading = 179.75
	},
	["bennys09"] = {
		pos = vector3(-1178.37,-2845.97,13.93),
		heading = 331.66
	},
	["bennys10"] = {
		pos = vector3(-222.72,-1329.2,30.89),
		heading = 270.13
	},
	["bennys11"] = {
		pos = vector3(1143.68,-782.04,57.61),
		heading = 0.0
	},
	["bennys12"] = {
		pos = vector3(1149.86,-781.97,57.59),
		heading = 0.0
	},
	["bennys13"] = {
		pos = vector3(-1417.13,-446.3,35.91),
		heading = 31.50
	},
	["bennys14"] = {
		pos = vector3(-1423.5,-450.26,35.91),
		heading = 31.50
	},
	["bennys15"] = {
		pos = vector3(-32.43,-1065.65,28.39),
		heading = 340.16
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function saveVehicle()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehicleMods = {
		neon = {},
		colors = {},
		extracolors = {},
		dashColour = -1,
		interColour = -1,
		lights = {},
		tint = GetVehicleWindowTint(vehicle),
		wheeltype = GetVehicleWheelType(vehicle),
		platestyle = GetVehicleNumberPlateTextIndex(vehicle),
		mods = {},
		var = {},
		smokecolor = {},
		xenonColor = -1,
		liverys = 24,
		extras = {},
		plateIndex = 0
	}

	vehicleMods["xenonColor"] = GetCurrentXenonColour(vehicle)
	vehicleMods["lights"][1],vehicleMods["lights"][2],vehicleMods["lights"][3] = GetVehicleNeonLightsColour(vehicle)
	vehicleMods["colors"][1],vehicleMods["colors"][2] = GetVehicleColours(vehicle)
	vehicleMods["extracolors"][1],vehicleMods["extracolors"][2] = GetVehicleExtraColours(vehicle)
	vehicleMods["smokecolor"][1],vehicleMods["smokecolor"][2],vehicleMods["smokecolor"][3] = GetVehicleTyreSmokeColor(vehicle)
	vehicleMods["dashColour"] = GetVehicleInteriorColour(vehicle)
	vehicleMods["interColour"] = GetVehicleDashboardColour(vehicle)
	vehicleMods["liverys"] = GetVehicleLivery(vehicle)
	vehicleMods["plateIndex"] = GetVehicleNumberPlateTextIndex(vehicle)

	for i = 0,3 do
		vehicleMods["neon"][i] = IsVehicleNeonLightEnabled(vehicle,i)
	end

	for i = 0,16 do
		vehicleMods["mods"][i] = GetVehicleMod(vehicle,i)
	end

	for i = 17,22 do
		vehicleMods["mods"][i] = IsToggleModOn(vehicle,i)
	end

	for i = 23,48 do
		vehicleMods["mods"][i] = GetVehicleMod(vehicle,i)

		if i == 24 or i == 23 then
			vehicleMods["var"][i] = GetVehicleModVariation(vehicle,i)
		end
	end

	for i = 1,12 do
		local ison = IsVehicleExtraTurnedOn(vehicle,i)
		if 1 == tonumber(ison) then
			vehicleMods["extras"][i] = 1
		else
			vehicleMods["extras"][i] = 0
		end
	end

	TriggerServerEvent("lscustoms:updateVehicle",vehicleMods,GetVehicleNumberPlateText(vehicle),vRP.vehicleName())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTEMPTPURCHASE
-----------------------------------------------------------------------------------------------------------------------------------------
function AttemptPurchase(type,upgradeLevel)
	if upgradeLevel ~= nil then
		upgradeLevel = upgradeLevel + 2
	end

	TriggerServerEvent("lscustoms:attemptPurchase",type,upgradeLevel)

	attemptingPurchase = true

	while attemptingPurchase do
		Wait(1)
	end

	if not isPurchaseSuccessful then
		PlaySoundFrontend(-1,"ERROR","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
	end

	return isPurchaseSuccessful
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentMod(id)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local mod = GetVehicleMod(vehicle,id)
	local modName = GetLabelText(GetModTextLabel(vehicle,id,mod))

	return mod,modName
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentWheel()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local wheel = GetVehicleMod(vehicle,23)
	local wheelName = GetLabelText(GetModTextLabel(vehicle,23,wheel))
	local wheelType = GetVehicleWheelType(vehicle)

	return wheel,wheelName,wheelType
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTCHUSTOMWHEELSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentCustomWheelState()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local state = GetVehicleModVariation(vehicle,23)

	if state then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETORIGINALWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetOriginalWheel()
	return originalWheel
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETORIGINALCUSTOMWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetOriginalCustomWheel()
	return originalCustomWheels
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentWindowTint()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	return GetVehicleWindowTint(vehicle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTVEHICLEWHEELSMOKECLOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentVehicleWheelSmokeColour()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local r,g,b = GetVehicleTyreSmokeColor(vehicle)

	return r,g,b
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTNEONSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentNeonState(id)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local isEnabled = IsVehicleNeonLightEnabled(vehicle,id)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentNeonColour()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local r,g,b = GetVehicleNeonLightsColour(vehicle)

	return r,g,b
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTXENONSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentXenonState()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local isEnabled = IsToggleModOn(vehicle,22)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentXenonColour()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	return GetVehicleHeadlightsColour(vehicle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTTURBOSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentTurboState()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local isEnabled = IsToggleModOn(vehicle,18)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTEXTRASTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentExtraState(extra)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	return IsVehicleExtraTurnedOn(vehicle,extra)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKVALIDMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckValidMods(category,id,wheelType)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local tempMod = GetVehicleMod(vehicle,id)
	local tempWheel = GetVehicleMod(vehicle,23)
	local tempWheelType = GetVehicleWheelType(vehicle)
	local tempWheelCustom = GetVehicleModVariation(vehicle,23)
	local amountValidMods = 0
	local validMods = {}
	local hornNames = {}

	if wheelType ~= nil then
		SetVehicleWheelType(vehicle,wheelType)
	end

	if id == 14 then
		for k,v in pairs(vehicleCustomisation) do 
			if vehicleCustomisation[k]["category"] == category then
				hornNames = vehicleCustomisation[k]["hornNames"]

				break
			end
		end
	end

	local modAmount = GetNumVehicleMods(vehicle,id)
	for i = 1,modAmount do
		local label = GetModTextLabel(vehicle,id,(i - 1))
		local modName = GetLabelText(label)

		if modName == "NULL" then
			if id == 14 then
				if i <= #hornNames then
					modName = hornNames[i]["name"]
				else
					modName = "Horn "..i
				end
			else
				modName = category.." "..i
			end
		end

		validMods[i] = { id = (i - 1), name = modName }

		amountValidMods = amountValidMods + 1
	end

	if modAmount > 0 then
		table.insert(validMods,1,{ id = -1, name = "Original" })
	end

	if wheelType ~= nil then
		SetVehicleWheelType(vehicle,tempWheelType)
		SetVehicleMod(vehicle,23,tempWheel,tempWheelCustom)
	end

	return validMods,amountValidMods
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalMod()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleMod(vehicle,originalCategory,originalMod)
	SetVehicleDoorsShut(vehicle,true)

	originalCategory = nil
	originalMod = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalWindowTint()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleWindowTint(vehicle,originalWindowTint)

	originalWindowTint = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALCOLOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalColours()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleColours(vehicle,originalPrimaryColour,originalSecondaryColour)
	SetVehicleExtraColours(vehicle,originalPearlescentColour,originalWheelColour)
	SetVehicleDashboardColour(vehicle,originalDashColour)
	SetVehicleInteriorColour(vehicle,originalInterColour)

	originalPrimaryColour = nil
	originalSecondaryColour = nil
	originalPearlescentColour = nil
	originalWheelColour = nil
	originalDashColour = nil
	originalInterColour = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALWHEELS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalWheels()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	SetVehicleWheelType(vehicle,originalWheelType)

	if originalWheelCategory ~= nil then
		SetVehicleMod(vehicle,originalWheelCategory,originalWheel,originalCustomWheels)
		
		if GetVehicleClass(vehicle) == 8 then
			SetVehicleMod(vehicle,24,originalWheel,originalCustomWheels)
		end

		originalWheelType = nil
		originalWheelCategory = nil
		originalWheel = nil
		originalCustomWheels = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALNEONSTATES
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalNeonStates()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleNeonLightEnabled(vehicle,originalNeonLightSide,originalNeonLightState)

	originalNeonLightState = nil
	originalNeonLightSide = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALNEONCOLOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalNeonColours()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleNeonLightsColour(vehicle,originalNeonColourR,originalNeonColourG,originalNeonColourB)

	originalNeonColourR = nil
	originalNeonColourG = nil
	originalNeonColourB = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalXenonColour()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleHeadlightsColour(vehicle,originalXenonColour)
	SetVehicleLights(vehicle,0)

	originalXenonColour = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function RestorePoliceLivery()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleLivery(vehicle,originalPoliceLivery)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function RestorePlateIndex()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleNumberPlateTextIndex(vehicle,originalPlateIndex)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewMod(categoryID,modID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	if originalMod == nil and originalCategory == nil then
		originalCategory = categoryID
		originalMod = GetVehicleMod(vehicle,categoryID)
	end

	if categoryID == 39 or categoryID == 40 or categoryID == 41 then
		SetVehicleDoorOpen(vehicle,4,false,true)
	elseif categoryID == 37 or categoryID == 38 then
		SetVehicleDoorOpen(vehicle,5,false,true)
	end

	SetVehicleMod(vehicle,categoryID,modID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewWindowTint(windowTintID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleWindowTint(vehicle,windowTintID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewColour(paintType,paintCategory,paintID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	SetVehicleModKit(vehicle,0)

	if originalDashColour == nil and originalInterColour == nil and originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
		originalPrimaryColour,originalSecondaryColour = GetVehicleColours(vehicle)
		originalPearlescentColour,originalWheelColour = GetVehicleExtraColours(vehicle)
		originalDashColour = GetVehicleDashboardColour(vehicle)
		originalInterColour = GetVehicleInteriorColour(vehicle)
	end

	if paintType == 0 then
		if paintCategory == 1 then
			SetVehicleColours(vehicle,paintID,originalSecondaryColour)
			SetVehicleExtraColours(vehicle,originalPearlescentColour,originalWheelColour)
		else
			SetVehicleColours(vehicle,paintID,originalSecondaryColour)
		end
	elseif paintType == 1 then
		SetVehicleColours(vehicle,originalPrimaryColour,paintID)
	elseif paintType == 2 then
		SetVehicleExtraColours(vehicle,paintID,originalWheelColour)
	elseif paintType == 3 then
		SetVehicleExtraColours(vehicle,originalPearlescentColour,paintID)
	elseif paintType == 4 then
		SetVehicleDashboardColour(vehicle,paintID)
	elseif paintType == 5 then
		SetVehicleInteriorColour(vehicle,paintID)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewWheel(categoryID,wheelID,wheelType)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	if originalWheelCategory == nil and originalWheel == nil and originalWheelType == nil and originalCustomWheels == nil then
		originalWheelCategory = categoryID
		originalWheelType = GetVehicleWheelType(vehicle)
		originalWheel = GetVehicleMod(vehicle,23)
		originalCustomWheels = GetVehicleModVariation(vehicle,23)
	end

	SetVehicleWheelType(vehicle,wheelType)
	SetVehicleMod(vehicle,categoryID,wheelID,doesHaveCustomWheels)

	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,wheelID,doesHaveCustomWheels)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWNEON
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewNeon(side,enabled)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	if originalNeonLightState == nil and originalNeonLightSide == nil then
		if IsVehicleNeonLightEnabled(vehicle,side) then
			originalNeonLightState = 1
		else
			originalNeonLightState = 0
		end

		originalNeonLightSide = side
	end

	SetVehicleNeonLightEnabled(vehicle,side,enabled)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewNeonColour(r,g,b)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	if originalNeonColourR == nil and originalNeonColourG == nil and originalNeonColourB == nil then
		originalNeonColourR,originalNeonColourG,originalNeonColourB = GetVehicleNeonLightsColour(vehicle)
	end

	SetVehicleNeonLightsColour(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewXenonColour(colour)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	if originalXenonColour == nil then
		originalXenonColour = GetVehicleHeadlightsColour(vehicle)
	end

	SetVehicleLights(vehicle,2)
	SetVehicleHeadlightsColour(vehicle,colour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewPoliceLivery(liv)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleLivery(vehicle,tonumber(liv))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewPlateIndex(index)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleNumberPlateTextIndex(vehicle,tonumber(index))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyMod(categoryID,modID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	if categoryID == 18 then
		ToggleVehicleMod(vehicle,categoryID,modID)
	elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then
		originalCategory = categoryID
		originalMod = modID

		SetVehicleMod(vehicle,categoryID,modID)
	else
		originalCategory = categoryID
		originalMod = modID

		SetVehicleMod(vehicle,categoryID,modID)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYEXTRA
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyExtra(extraID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	local engine = GetVehicleEngineHealth(vehicle)
	local body = GetVehicleBodyHealth(vehicle)
	local fuel = GetVehicleFuelLevel(vehicle)
	local vehWindows = {}
	local vehTyres = {}
	local vehDoors = {}

	for i = 0,7 do
		local tyre_state = 2

		if IsVehicleTyreBurst(vehicle,i,true) then
			tyre_state = 1
		elseif IsVehicleTyreBurst(vehicle,i,false) then
			tyre_state = 0
		end

		vehTyres[i] = tyre_state
	end

	for i = 0,5 do
		vehDoors[i] = IsVehicleDoorDamaged(vehicle,i)
	end

	for i = 0,5 do
		vehWindows[i] = IsVehicleWindowIntact(vehicle,i)
	end

	local isEnabled = IsVehicleExtraTurnedOn(vehicle,extraID)
	if isEnabled == 1 then
		SetVehicleExtra(vehicle,tonumber(extraID),1)
		SetVehiclePetrolTankHealth(vehicle,4000.0)
	else
		SetVehicleExtra(vehicle,tonumber(extraID),0)
		SetVehiclePetrolTankHealth(vehicle,4000.0)
	end

	SetVehicleEngineHealth(vehicle,engine)
	SetVehicleBodyHealth(vehicle,body)
	SetVehicleFuelLevel(vehicle,fuel)

	for k,v in pairs(vehTyres) do
		if v < 2 then
			SetVehicleTyreBurst(vehicle,k,(v == 1),1000.0)
		end
	end

	for k,v in pairs(vehWindows) do
		if not v then
			SmashVehicleWindow(vehicle,k)
		end
	end

	for k,v in pairs(vehDoors) do
		if v then
			SetVehicleDoorBroken(vehicle,k,v)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyWindowTint(windowTintID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	originalWindowTint = windowTintID

	SetVehicleWindowTint(vehicle,windowTintID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyColour(paintType,paintCategory,paintID)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehPrimaryColour,vehSecondaryColour = GetVehicleColours(vehicle)
	local vehPearlescentColour,vehWheelColour = GetVehicleExtraColours(vehicle)

	if paintType == 0 then
		if paintCategory == 1 then
			SetVehicleColours(vehicle,paintID,vehSecondaryColour)
			SetVehicleExtraColours(vehicle,originalPearlescentColour,vehWheelColour)
			originalPrimaryColour = paintID
		else
			SetVehicleColours(vehicle,paintID,vehSecondaryColour)
			originalPrimaryColour = paintID
		end
	elseif paintType == 1 then
		SetVehicleColours(vehicle,vehPrimaryColour,paintID)
		originalSecondaryColour = paintID
	elseif paintType == 2 then
		SetVehicleExtraColours(vehicle,paintID,vehWheelColour)
		originalPearlescentColour = paintID
	elseif paintType == 3 then
		SetVehicleExtraColours(vehicle,vehPearlescentColour,paintID)
		originalWheelColour = paintID
	elseif paintType == 4 then
		SetVehicleDashboardColour(vehicle,paintID)
		originalDashColour = paintID
	elseif paintType == 5 then
		SetVehicleInteriorColour(vehicle,paintID)
		originalInterColour = paintID
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyWheel(categoryID,wheelID,wheelType)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	originalWheelCategory = categoryID
	originalWheel = wheelID
	originalWheelType = wheelType

	SetVehicleWheelType(vehicle,wheelType)
	SetVehicleMod(vehicle,categoryID,wheelID,doesHaveCustomWheels)
	
	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,wheelID,doesHaveCustomWheels)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYCUSTOMWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyCustomWheel(state)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	SetVehicleMod(vehicle,23,GetVehicleMod(vehicle,23),state)

	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,GetVehicleMod(vehicle,24),state)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYNEON
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyNeon(side,enabled)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	originalNeonLightState = enabled
	originalNeonLightSide = side

	SetVehicleNeonLightEnabled(vehicle,side,enabled)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyNeonColour(r,g,b)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	originalNeonColourR = r
	originalNeonColourG = g
	originalNeonColourB = b

	SetVehicleNeonLightsColour(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYXENONLIGHTS
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyXenonLights(category,state)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	ToggleVehicleMod(vehicle,category,state)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyXenonColour(colour)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	originalXenonColour = colour

	SetVehicleHeadlightsColour(vehicle,colour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyPoliceLivery(liv)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	originalPoliceLivery = liv

	SetVehicleLivery(vehicle,liv)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyPlateIndex(index)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	originalPlateIndex = index
	SetVehicleNumberPlateTextIndex(vehicle,index)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTYRESMOKE
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyTyreSmoke(r,g,b)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)

	ToggleVehicleMod(vehicle,20,true)
	SetVehicleTyreSmokeColor(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXITBENNYS
-----------------------------------------------------------------------------------------------------------------------------------------
function ExitBennys()
	if not activeAdmin then
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)

		FreezeEntityPosition(vehicle,false)
		SetEntityCollision(vehicle,true,true)
	end

	DisplayMenuContainer(false)
	activeBennys = false
	activeAdmin = false
	DestroyMenus()
	saveVehicle()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FREEZEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function freezeVehicle(pVeh,pBennys)
	SetVehicleModKit(pVeh,0)

	if not activeAdmin then
		SetEntityCoords(pVeh,pBennys["pos"])
		SetEntityHeading(pVeh,pBennys["heading"])
		FreezeEntityPosition(pVeh,true)
		SetVehicleOnGroundProperly(pVeh)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHENTERLOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
local function finishEnterLocation()
	activeBennys = true
	disableControls()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERLOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
function enterLocation(pBennys)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehclass = GetVehicleClass(vehicle)
	local isMotorcycle = false

	freezeVehicle(vehicle,pBennys)

	if vehclass == 8 then
		isMotorcycle = true
	else
		isMotorcycle = false
	end

	InitiateMenus(isMotorcycle,GetVehicleBodyHealth(vehicle))

	DisplayMenu(true,"mainMenu")
	DisplayMenuContainer(true)
	PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)

	finishEnterLocation()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
function disableControls()
	CreateThread(function()
		while activeBennys do
			DisableControlAction(1,38,true)
			DisableControlAction(1,172,true)
			DisableControlAction(1,173,true)
			DisableControlAction(1,177,true)
			DisableControlAction(1,176,true)
			DisableControlAction(1,71,true)
			DisableControlAction(1,72,true)
			DisableControlAction(1,34,true)
			DisableControlAction(1,35,true)
			DisableControlAction(1,75,true)
			
			if IsDisabledControlJustReleased(1,172) then
				MenuScrollFunctionality("up")
				PlaySoundFrontend(-1,"NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,173) then
				MenuScrollFunctionality("down")
				PlaySoundFrontend(-1,"NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,176) then
				MenuManager(true)
				PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,177) then
				MenuManager(false)
				PlaySoundFrontend(-1,"NO","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end

			Wait(0)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASESUCCESFUL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:purchaseSuccessful")
AddEventHandler("lscustoms:purchaseSuccessful",function()
	isPurchaseSuccessful = true
	attemptingPurchase = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASEFAILED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:purchaseFailed")
AddEventHandler("lscustoms:purchaseFailed",function()
	isPurchaseSuccessful = false
	attemptingPurchase = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if not activeBennys then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)

				for k,v in pairs(bennysLocations) do
					local distance = #(coords - v["pos"])

					if distance <= 15 then
						timeDistance = 1
						DrawMarker(23,v["pos"]["x"],v["pos"]["y"],v["pos"]["z"] - 0.95,0.0,0.0,0.0,0.0,0.0,0.0,5.0,5.0,0.0,142,131,176,175,0,0,0,0)

						if IsControlJustPressed(1,38) and distance <= 2.5 and vSERVER.checkPermission(v["permission"]) then
							enterLocation(bennysLocations[k])
							activeAdmin = false
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASEFAILED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:openAdmin")
AddEventHandler("lscustoms:openAdmin",function()
	if not activeBennys then
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			activeAdmin = true
			enterLocation(bennysLocations["admin"])
		end
	end
end)