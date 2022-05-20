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
Tunnel.bindInterface("garages",cRP)
vSERVER = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehPlates = {}
local openGarage = ""
local searchBlip = nil
local spawnSelected = {}
local vehHotwired = false
local anim = "machinic_loop_mechandplayer"
local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local garageLocates = {
	["1"] = { x = 55.44, y = -876.17, z = 30.67,
		["1"] = { 60.44,-866.47,30.23,340.16 },
		["2"] = { 57.26,-865.35,30.25,340.16 },
		["3"] = { 54.03,-864.21,30.25,340.16 },
		["4"] = { 50.73,-863.01,30.26,340.16 },
		["5"] = { 60.52,-866.53,30.14,340.16 },
		["6"] = { 50.73,-873.28,30.11,158.75 },
		["7"] = { 47.36,-872.07,30.13,158.75 },
		["8"] = { 44.15,-870.9,30.13,158.75 }
	},
	["2"] = { x = 599.04, y = 2745.33, z = 42.04,
		["1"] = { 604.82,2738.27,41.64,187.09 },
		["2"] = { 601.75,2738.08,41.65,184.26 },
		["3"] = { 598.63,2737.85,41.69,184.26 },
		["4"] = { 595.59,2737.55,41.7,184.26 }
	},
	["3"] = { x = -136.8, y = 6356.84, z = 31.49,
		["1"] = { -133.72,6349.01,31.16,42.52 },
		["2"] = { -136.1,6346.53,31.16,42.52 }
	},
	["4"] = { x = 275.23, y = -345.56, z = 45.17,
		["1"] = { 266.06,-332.07,44.58,252.29 },
		["2"] = { 267.18,-328.9,44.58,252.29 },
		["3"] = { 268.32,-325.67,44.58,252.29 },
		["4"] = { 269.53,-322.4,44.58,252.29 },
		["5"] = { 270.77,-319.14,44.58,252.29 }
	},
	["5"] = { x = 596.43, y = 90.68, z = 93.13,
		["1"] = { 599.82,102.03,92.57,249.45 },
		["2"] = { 598.69,98.42,92.57,249.45 }
	},
	["6"] = { x = -340.57, y = 266.04, z = 85.68,
		["1"] = { -349.47,272.54,84.77,272.13 },
		["2"] = { -349.5,275.91,84.69,272.13 },
		["3"] = { -349.56,279.3,84.62,272.13 },
		["4"] = { -349.67,282.6,84.59,274.97 },
		["5"] = { -349.74,286.16,84.59,272.13 },
		["6"] = { -349.8,289.76,84.6,272.13 },
		["7"] = { -349.85,293.28,84.6,272.13 },
		["8"] = { -349.87,296.72,84.6,272.13 }
	},
	["7"] = { x = -2030.03, y = -465.99, z = 11.59,
		["1"] = { -2037.4,-461.02,11.07,138.9 },
		["2"] = { -2039.78,-459.07,11.07,138.9 },
		["3"] = { -2042.12,-457.1,11.07,138.9 },
		["4"] = { -2044.47,-455.11,11.07,138.9 },
		["5"] = { -2046.85,-453.09,11.07,138.9 },
		["6"] = { -2049.12,-451.17,11.07,138.9 },
		["7"] = { -2051.51,-449.23,11.07,138.9 }
	},
	["8"] = { x = -1184.94, y = -1509.99, z = 4.65,
		["1"] = { -1183.29,-1495.81,4.04,121.89 },
		["2"] = { -1185.23,-1493.28,4.04,121.89 },
		["3"] = { -1186.87,-1490.71,4.04,121.89 },
		["4"] = { -1188.69,-1488.27,4.04,121.89 }
	},
	["9"] = { x = 101.23, y = -1073.64, z = 29.37,
		["1"] = { 105.9,-1063.14,28.88,246.62 },
		["2"] = { 107.42,-1059.61,28.88,246.62 },
		["3"] = { 108.88,-1056.23,28.88,246.62 },
		["4"] = { 110.27,-1052.86,28.88,246.62 }
	},
	["10"] = { x = 213.97, y = -808.43, z = 31.0,
		["1"] = { 221.93,-804.11,30.35,249.45 },
		["2"] = { 222.9,-801.61,30.33,249.45 },
		["3"] = { 223.92,-799.2,30.33,249.45 },
		["4"] = { 224.85,-796.69,30.33,249.45 }
	},
	["11"] = { x = -348.89, y = -874.02, z = 31.31,
		["1"] = { -343.62,-875.51,30.75,167.25 },
		["2"] = { -339.98,-876.27,30.75,167.25 },
		["3"] = { -336.35,-876.98,30.75,167.25 },
		["4"] = { -332.72,-877.71,30.75,167.25 }
	},
	["12"] = { x = 67.72, y = 12.3, z = 69.22,
		["1"] = { 63.87,16.5,68.87,340.16 },
		["2"] = { 60.78,17.6,68.92,340.16 },
		["3"] = { 57.76,18.76,69.03,340.16 },
		["4"] = { 54.8,19.92,69.25,340.16 }
	},
	["13"] = { x = 361.96, y = 297.8, z = 103.88,
		["1"] = { 371.06,284.68,102.94,340.16 },
		["2"] = { 374.8,283.39,102.85,340.16 },
		["3"] = { 378.62,282.06,102.78,340.16 }
	},
	["14"] = { x = 1035.84, y = -763.87, z = 58.0,
		["1"] = { 1046.56,-774.55,57.69,90.71 },
		["2"] = { 1046.56,-778.24,57.68,90.71 },
		["3"] = { 1046.55,-782.0,57.68,90.71 },
		["4"] = { 1046.54,-785.65,57.66,90.71 }
	},
	["15"] = { x = -796.69, y = -2022.85, z = 9.17,
		["1"] = { -779.77,-2040.03,8.56,314.65 },
		["2"] = { -777.36,-2042.58,8.56,314.65 },
		["3"] = { -774.92,-2044.9,8.56,314.65 }
	},
	["16"] = { x = 453.28, y = -1146.77, z = 29.5,
		["1"] = { 467.33,-1151.89,28.96,85.04 },
		["2"] = { 467.16,-1154.75,28.96,85.04 },
		["3"] = { 467.1,-1157.73,28.96,87.88 }
	},
	["17"] = { x = 528.65, y = -146.25, z = 58.37,
		["1"] = { 540.99,-136.2,59.13,178.59 },
		["2"] = { 544.84,-136.25,59.01,178.59 },
		["3"] = { 548.83,-136.31,59.01,181.42 },
		["4"] = { 552.81,-136.41,58.99,178.59 }
	},
	["18"] = { x = -1159.56, y = -739.39, z = 19.88,
		["1"] = { -1144.95,-745.49,19.34,104.89 },
		["2"] = { -1142.76,-748.44,19.19,107.72 },
		["3"] = { -1140.18,-751.41,19.06,107.72 },
		["4"] = { -1137.99,-754.36,18.91,107.72 },
		["5"] = { -1135.43,-757.3,18.75,107.72 },
		["6"] = { -1133.12,-760.4,18.59,107.72 },
		["7"] = { -1130.59,-763.27,18.43,107.72 }
	},
	["19"] = { x = -3005.69, y = 81.53, z = 11.61,
		["1"] = { -2996.65,85.23,11.61,51.03 }
	},
	["20"] = { x = 935.95, y = 0.36, z = 78.76,
		["1"] = { 933.29,-3.74,78.44,147.41 }
	},
	["41"] = { x = 1162.7, y = -1477.81, z = 34.85,
		["1"] = { 1150.2,-1477.26,34.46,0.0 }
	},
	["42"] = { x = 1193.44, y = -1487.57, z = 34.85,
		["1"] = { 1200.66,-1502.24,35.08,181.42 }
	},
	["43"] = { x = 1835.94, y = 3671.48, z = 34.27,
		["1"] = { 1834.99,3665.03,33.41,212.6 },
		["2"] = { 1831.73,3663.18,33.51,212.6 },
		["3"] = { 1828.42,3661.31,33.56,212.6 }
	},
	["44"] = { x = 1841.95, y = 3675.0, z = 34.27,
		["1"] = { 1846.5,3658.46,33.9,119.06 }
	},
	["45"] = { x = -253.72, y = 6339.04, z = 32.42,
		["1"] = { -258.47,6347.58,32.1,269.3 },
		["2"] = { -261.6,6344.21,32.1,269.3 },
		["3"] = { -264.97,6340.84,32.1,272.13 }
	},
	["46"] = { x = -266.03, y = 6326.8, z = 32.42,
		["1"] = { -273.13,6329.85,32.1,133.23 }
	},
	["61"] = { x = 1856.95, y = 3683.82, z = 34.27,
		["1"] = { 1853.74,3675.92,33.41,212.6 },
		["2"] = { 1850.5,3674.06,33.43,209.77 },
		["3"] = { 1847.21,3672.24,33.38,209.77 }
	},
	["62"] = { x = 1860.95, y = 3686.05, z = 34.27,
		["1"] = { 1869.01,3671.07,33.48,116.23 }
	},
	["63"] = { x = -458.99, y = 6031.32, z = 31.34,
		["1"] = { -469.04,6038.77,31.0,226.78 },
		["2"] = { -472.45,6035.42,31.0,226.78 },
		["3"] = { -476.09,6031.71,31.0,226.78 },
		["4"] = { -479.61,6028.09,31.0,226.78 },
		["5"] = { -482.7,6024.95,31.0,226.78 }
	},
	["64"] = { x = -479.35, y = 6011.16, z = 31.29,
		["1"] = { -475.29,5988.55,31.0,317.49 }
	},
	["65"] = { x = 1840.74, y = 2545.92, z = 45.66,
		["1"] = { 1833.59,2542.09,45.54,272.13 }
	},
	["66"] = { x = 1840.75, y = 2538.27, z = 45.66,
		["1"] = { 1833.59,2542.09,45.54,272.13 }
	},
	["67"] = { x = -957.11, y = -2057.36, z = 9.4,
		["1"] = { -960.05,-2062.39,9.12,133.23 }
	},
	["68"] = { x = -943.23, y = -2020.73, z = 11.32,
		["1"] = { -950.33,-2021.68,11.71,42.52 }
	},
	["69"] = { x = 445.79, y = -1014.44, z = 28.56,
		["1"] = { 443.03,-1022.42,28.58,85.04 }
	},
	["70"] = { x = 462.39, y = -981.7, z = 43.69,
		["1"] = { 449.23,-981.21,43.69,90.71 }
	},
	["101"] = { x = 156.44, y = -1065.79, z = 30.04,
		["1"] = { 162.3,-1069.1,29.18,70.87 }
	},
	["102"] = { x = -1188.13, y = -1574.47, z = 4.35,
		["1"] = { -1188.48,-1572.54,4.33,306.15 },
		["2"] = { -1189.39,-1571.49,4.33,306.15 }
	},
	["103"] = { x = -777.44, y = 5593.64, z = 33.63,
		["1"] = { -776.98,5590.38,33.48,260.79 },
		["2"] = { -778.25,5586.74,33.48,255.12 }
	},
	["104"] = { x = 523.65, y = -1828.87, z = 28.46,
		["1"] = { 526.3,-1830.52,28.14,138.9 }
	},
	["105"] = { x = 1370.35, y = -1520.08, z = 57.49,
		["1"] = { 1371.34,-1523.06,56.43,204.1 }
	},
	["106"] = { x = 102.74, y = -1959.16, z = 20.79,
		["1"] = { 103.13,-1956.13,20.14,0.0 }
	},
	["107"] = { x = 337.63, y = -2036.08, z = 21.37,
		["1"] = { 336.22,-2037.89,20.59,141.74 }
	},
	["108"] = { x = -161.39, y = -1628.59, z = 33.63,
		["1"] = { -163.55,-1630.0,33.03,147.41 }
	},
	["109"] = { x = 236.22, y = -1702.66, z = 29.23,
		["1"] = { 234.52,-1705.29,28.61,141.74 }
	},
	["110"] = { x = 1159.65, y = -1644.01, z = 36.95,
		["1"] = { 1160.85,-1646.04,36.31,209.77 }
	},
	["111"] = { x = -1073.36, y = -1659.74, z = 4.38,
		["1"] = { -1074.72,-1660.89,3.79,36.86 }
	},
	["121"] = { x = -1728.06, y = -1050.69, z = 1.7,
		["1"] = { -1734.05,-1057.01,0.94,133.23 }
	},
	["122"] = { x = 1966.55, y = 3976.15, z = 31.49,
		["1"] = { 1971.66,3985.42,30.13,331.66 }
	},
	["123"] = { x = -776.63, y = -1494.93, z = 2.29,
		["1"] = { -786.5,-1498.89,-0.57,110.56 }
	},
	["124"] = { x = -895.04, y = 5687.46, z = 3.03,
		["1"] = { -907.5,5684.52,0.76,102.05 }
	},
	["141"] = { x = -842.47, y = 5403.79, z = 34.61,
		["1"] = { -838.49,5405.64,33.78,345.83 }
	},
	["142"] = { x = 453.74, y = -600.6, z = 28.59,
		["1"] = { 462.81,-606.03,28.49,212.6 },
		["2"] = { 461.54,-612.34,28.49,215.44 },
		["3"] = { 460.98,-619.81,28.49,215.44 }
	},
	["143"] = { x = 84.18, y = -1552.0, z = 29.59,
		["1"] = { 80.56,-1541.11,29.17,48.19 },
		["2"] = { 76.58,-1545.85,29.17,48.19 },
		["3"] = { 72.59,-1550.58,29.17,48.19 }
	},
	["144"] = { x = 355.15, y = 275.79, z = 103.15,
		["1"] = { 359.95,272.31,102.72,340.16 },
		["2"] = { 364.05,270.74,102.68,340.16 },
		["3"] = { 368.1,269.31,102.67,340.16 }
	},
	["145"] = { x = 905.6, y = -165.08, z = 74.11,
		["1"] = { 916.21,-170.61,74.04,99.22 },
		["2"] = { 918.35,-167.18,74.22,99.22 },
		["3"] = { 920.64,-163.54,74.43,99.22 }
	},
	["146"] = { x = -154.58, y = -1174.78, z = 23.99,
		["1"] = { -142.87,-1180.58,23.86,90.71 }
	},
	["147"] = { x = 1731.42, y = 3708.32, z = 34.17,
		["1"] = { 1728.51,3715.11,34.26,19.85 }
	},
	["148"] = { x = -354.68, y = 6066.69, z = 31.49,
		["1"] = { -360.39,6071.64,31.58,317.49 }
	},
	["149"] = { x = -677.31, y = 5831.62, z = 17.32,
		["1"] = { -678.47,5825.97,17.56,133.23 },
		["2"] = { -680.92,5828.44,17.56,133.23 },
		["3"] = { -683.36,5830.96,17.56,133.23 },
		["4"] = { -685.85,5833.44,17.56,133.23 }
	},
	["150"] = { x = 1241.27, y = -3262.69, z = 5.53,
		["1"] = { 1271.56,-3287.96,5.98,85.04 },
		["2"] = { 1271.82,-3282.63,6.0,85.04 },
		["3"] = { 1271.95,-3271.04,5.98,85.04 },
		["4"] = { 1272.11,-3266.03,5.98,85.04 }
	},
	["151"] = { x = -163.0, y = -2130.4, z = 16.7,
		["1"] = { -162.84,-2134.64,15.82,291.97 },
		["2"] = { -161.47,-2138.09,15.82,291.97 },
		["3"] = { -160.15,-2141.48,15.84,291.97 }
	},
	["152"] = { x = -593.38, y = -882.25, z = 25.91,
		["1"] = { -596.78,-886.11,25.0,87.88 },
		["2"] = { -596.59,-889.71,24.94,87.88 },
		["3"] = { -596.46,-892.86,24.99,87.88 }
	},
	["153"] = { x = -941.09, y = -2954.37, z = 13.93,
		["1"] = { -980.57,-2997.38,14.54,59.53 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openGarage(garageName)
	openGarage = garageName
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "openNUI" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleMods(veh,vehCustom)
	if vehCustom then
		SetVehicleModKit(veh,0)

		if vehCustom["wheeltype"] ~= nil then
			SetVehicleWheelType(veh,vehCustom["wheeltype"])
		end

		for i = 0,16 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				SetVehicleMod(veh,i,vehCustom["mods"][tostring(i)])
			end
		end

		for i = 17,22 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				ToggleVehicleMod(veh,i,vehCustom["mods"][tostring(i)])
			end
		end

		for i = 23,24 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				if vehCustom["var"] == nil then
					vehCustom["var"] = {}
					vehCustom["var"][tostring(i)] = 0
				end

				SetVehicleMod(veh,i,vehCustom["mods"][tostring(i)],vehCustom["var"][tostring(i)])
			end
		end

		for i = 25,48 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				SetVehicleMod(veh,i,vehCustom["mods"][tostring(i)])
			end
		end

		for i = 0,3 do
			SetVehicleNeonLightEnabled(veh,i,vehCustom["neon"][tostring(i)])
		end

		if vehCustom["extras"] ~= nil then
			for i = 1,12 do
				local onoff = tonumber(vehCustom["extras"][i])
				if onoff == 1 then
					SetVehicleExtra(veh,i,0)
				else
					SetVehicleExtra(veh,i,1)
				end
			end
		end

		if vehCustom["liverys"] ~= nil and vehCustom["liverys"] ~= 24  then
			SetVehicleLivery(veh,vehCustom["liverys"])
		end

		if vehCustom["plateIndex"] ~= nil and vehCustom["plateIndex"] ~= 4 then
			SetVehicleNumberPlateTextIndex(veh,vehCustom["plateIndex"])
		end

		SetVehicleXenonLightsColour(veh,vehCustom["xenonColor"])
		SetVehicleColours(veh,vehCustom["colors"][1],vehCustom["colors"][2])
		SetVehicleExtraColours(veh,vehCustom["extracolors"][1],vehCustom["extracolors"][2])
		SetVehicleNeonLightsColour(veh,vehCustom["lights"][1],vehCustom["lights"][2],vehCustom["lights"][3])
		SetVehicleTyreSmokeColor(veh,vehCustom["smokecolor"][1],vehCustom["smokecolor"][2],vehCustom["smokecolor"][3])

		if vehCustom["tint"] ~= nil then
			SetVehicleWindowTint(veh,vehCustom["tint"])
		end

		if vehCustom["dashColour"] ~= nil then
			SetVehicleInteriorColour(veh,vehCustom["dashColour"])
		end

		if vehCustom["interColour"] ~= nil then
			SetVehicleDashboardColour(veh,vehCustom["interColour"])
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.spawnPosition()
	local checkSlot = 0
	local checkPos = nil

	repeat
		checkSlot = checkSlot + 1

		if garageLocates[openGarage][tostring(checkSlot)] ~= nil then
			local _,groundZ = GetGroundZAndNormalFor_3dCoord(garageLocates[openGarage][tostring(checkSlot)][1],garageLocates[openGarage][tostring(checkSlot)][2],garageLocates[openGarage][tostring(checkSlot)][3])
			spawnSelected = { garageLocates[openGarage][tostring(checkSlot)][1],garageLocates[openGarage][tostring(checkSlot)][2],groundZ,garageLocates[openGarage][tostring(checkSlot)][4] }
			checkPos = GetClosestVehicle(spawnSelected[1],spawnSelected[2],spawnSelected[3],2.501,0,71)
		end
	until not DoesEntityExist(checkPos) or garageLocates[openGarage][tostring(checkSlot)] == nil

	if garageLocates[openGarage][tostring(checkSlot)] == nil then
		TriggerEvent("Notify","amarelo","Vagas estão ocupadas.",5000)

		return false
	end

	return true,spawnSelected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.createVehicle(vehHash,vehNet,vehPlate,vehEngine,vehBody,vehFuel,vehCustom,vehWindows,vehDoors,vehTyres,vehBrakes)
	if NetworkDoesNetworkIdExist(vehNet) then
		local nveh = NetToEnt(vehNet)
		if DoesEntityExist(nveh) then
			NetworkRegisterEntityAsNetworked(nveh)
			while not NetworkGetEntityIsNetworked(nveh) do
				NetworkRegisterEntityAsNetworked(nveh)
				Wait(1)
			end

			SetNetworkIdCanMigrate(vehNet,true)
			NetworkSetNetworkIdDynamic(vehNet,false)
			SetNetworkIdExistsOnAllMachines(vehNet,true)

			SetVehicleNumberPlateText(nveh,vehPlate)
			SetEntityAsMissionEntity(nveh,true,true)
			SetVehicleHasBeenOwnedByPlayer(nveh,true)
			SetVehicleNeedsToBeHotwired(nveh,false)
			SetVehRadioStation(nveh,"OFF")

			if vehCustom ~= nil then
				local vehMods = json.decode(vehCustom)
				vehicleMods(nveh,vehMods)
			end

			if vehBrakes[1] ~= nil then
				if vehBrakes[1] > 0.90 then
					vehBrakes[1] = 0.90
				end
			end

			if vehBrakes[2] ~= nil then
				if vehBrakes[2] > 0.55 then
					vehBrakes[2] = 0.55
				end
			end

			if vehBrakes[3] ~= nil then
				if vehBrakes[3] > 0.75 then
					vehBrakes[3] = 0.75
				end
			end

			SetVehicleHandlingFloat(nveh,"CHandlingData","fBrakeForce",vehBrakes[1] or 0.90)
			SetVehicleHandlingFloat(nveh,"CHandlingData","fBrakeBiasFront",vehBrakes[2] or 0.55)
			SetVehicleHandlingFloat(nveh,"CHandlingData","fHandBrakeForce",vehBrakes[3] or 0.75)

			SetVehicleEngineHealth(nveh,vehEngine + 0.0)
			SetVehicleBodyHealth(nveh,vehBody + 0.0)
			SetVehicleFuelLevel(nveh,vehFuel + 0.0)

			if vehWindows then
				if json.decode(vehWindows) ~= nil then
					for k,v in pairs(json.decode(vehWindows)) do
						if not v then
							SmashVehicleWindow(nveh,parseInt(k))
						end
					end
				end
			end

			if vehTyres then
				if json.decode(vehTyres) ~= nil then
					for k,v in pairs(json.decode(vehTyres)) do
						if v < 2 then
							SetVehicleTyreBurst(nveh,parseInt(k),(v == 1),1000.01)
						end
					end
				end
			end

			if vehDoors then
				if json.decode(vehDoors) ~= nil then
					for k,v in pairs(json.decode(vehDoors)) do
						if v then
							SetVehicleDoorBroken(nveh,parseInt(k),parseInt(v))
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deleteVehicle(vehicle)
	if IsEntityAVehicle(vehicle) then
		local vehWindows = {}
		local vehDoors = {}
		local vehTyres = {}

		for i = 0,5 do
			vehDoors[i] = IsVehicleDoorDamaged(vehicle,i)
		end

		for i = 0,5 do
			vehWindows[i] = IsVehicleWindowIntact(vehicle,i)
		end

		for i = 0,7 do
			local tyre_state = 2

			if IsVehicleTyreBurst(vehicle,i,true) then
				tyre_state = 1
			elseif IsVehicleTyreBurst(vehicle,i,false) then
				tyre_state = 0
			end

			vehTyres[i] = tyre_state
		end

		vSERVER.tryDelete(NetworkGetNetworkIdFromEntity(vehicle),GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle),vehDoors,vehWindows,vehTyres,GetVehicleNumberPlateText(vehicle),{ GetVehicleHandlingFloat(vehicle,"CHandlingData","fBrakeForce"),GetVehicleHandlingFloat(vehicle,"CHandlingData","fBrakeBiasFront"),GetVehicleHandlingFloat(vehicle,"CHandlingData","fHandBrakeForce") })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("myVehicles",function(data,cb)
	local vehicles = vSERVER.myVehicles(openGarage)
	if vehicles then
		cb({ vehicles = vehicles })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnVehicles",function(data)
	vSERVER.spawnVehicles(data["name"],openGarage)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deleteVehicles",function(data)
	cRP.deleteVehicle(vRP.nearVehicle(15))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLELOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:vehicleLock")
AddEventHandler("garages:vehicleLock",function(vehIndex,vehLock)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if vehLock then
				SetVehicleDoorsLockedForAllPlayers(v,false)
			else
				SetVehicleDoorsLockedForAllPlayers(v,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchBlip(vehCoords)
	if DoesBlipExist(searchBlip) then
		RemoveBlip(searchBlip)
		searchBlip = nil
	end

	searchBlip = AddBlipForCoord(vehCoords["x"],vehCoords["y"],vehCoords["z"])
	SetBlipSprite(searchBlip,225)
	SetBlipColour(searchBlip,2)
	SetBlipScale(searchBlip,0.6)
	SetBlipAsShortRange(searchBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo")
	EndTextCommandSetBlipName(searchBlip)

	SetTimeout(30000,function()
		RemoveBlip(searchBlip)
		searchBlip = nil
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(garageLocates) do
				local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
				if distance <= 15 then
					timeDistance = 1
					DrawMarker(23,v["x"],v["y"],v["z"] - 0.95,0.0,0.0,0.0,0.0,0.0,0.0,1.75,1.75,0.0,42,137,255,100,0,0,0,0)

					if IsControlJustPressed(1,38) and distance <= 1.0 then
						vSERVER.returnGarages(k)
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SYNCPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:syncPlates")
AddEventHandler("garages:syncPlates",function(vehPlate)
	vehPlates[vehPlate] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SYNCPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:syncRemlates")
AddEventHandler("garages:syncRemlates",function(vehPlate)
	vehPlates[vehPlate] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:ALLPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:allPlates")
AddEventHandler("garages:allPlates",function(vehTable)
	vehPlates = vehTable
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTANIMHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startAnimHotwired()
	vehHotwired = true

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(1)
	end

	TaskPlayAnim(PlayerPedId(),animDict,anim,3.0,3.0,-1,49,5.0,0,0,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPANIMHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stopAnimHotwired(vehicle)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(1)
	end

	vehHotwired = false
	StopAnimTask(PlayerPedId(),animDict,anim,2.0)

	if vehicle ~= nil then
		NetworkRegisterEntityAsNetworked(vehicle)
		while not NetworkGetEntityIsNetworked(vehicle) do
			NetworkRegisterEntityAsNetworked(vehicle)
			Wait(1)
		end

		local vehNet = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(vehNet,true)
		NetworkSetNetworkIdDynamic(vehNet,false)
		SetNetworkIdExistsOnAllMachines(vehNet,true)

		SetEntityAsMissionEntity(vehicle,true,true)
		SetVehicleHasBeenOwnedByPlayer(vehicle,true)
		SetVehicleNeedsToBeHotwired(vehicle,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateHotwired(status)
	vehHotwired = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local platext = GetVehicleNumberPlateText(vehicle)
			if GetPedInVehicleSeat(vehicle,-1) == ped and not vehPlates[platext] then
				SetVehicleEngineOn(vehicle,false,true,true)
				DisablePlayerFiring(ped,true)
				timeDistance = 1
			end

			if vehHotwired and vehicle then
				DisableControlAction(1,75,true)
				DisableControlAction(1,20,true)
				timeDistance = 1
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATELOCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:updateLocs")
AddEventHandler("garages:updateLocs",function(homeName,homeInfos)
	garageLocates[homeName] = homeInfos
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATEREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:updateRemove")
AddEventHandler("garages:updateRemove",function(homeName,homeInfos)
	if garageLocates[homeName] then
		garageLocates[homeName] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:ALLLOCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:allLocs")
AddEventHandler("garages:allLocs",function(garageTable)
	for k,v in pairs(garageTable) do
		garageLocates[k] = v
	end
end)