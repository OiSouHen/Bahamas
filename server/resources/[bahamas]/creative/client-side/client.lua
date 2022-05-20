-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
local oldSpeed = 0
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			timeDistance = 1

			SetPedHelmet(ped,false)
			DisableControlAction(0,345,true)

			local veh = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(veh,-1) == ped then
				if GetVehicleDirtLevel(veh) ~= 0.0 then
					SetVehicleDirtLevel(veh,0.0)
				end

				local speed = GetEntitySpeed(veh) * 3.6
				if speed ~= oldSpeed then
					if (oldSpeed - speed) >= 60 then
						TriggerServerEvent("upgradeStress",10)

						if GetVehicleClass(veh) ~= 8 and GetEntityModel(veh) ~= 1755270897 then
							SetVehicleEngineOn(veh,false,true,true)
							vehicleTyreBurst(veh)
						end
					end

					oldSpeed = speed
				end
			end
		else
			if oldSpeed ~= 0 then
				oldSpeed = 0
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleTyreBurst(vehicle)
	local tyre = math.random(4)
	if tyre == 1 then
		if not IsVehicleTyreBurst(vehicle,0,false) then
			SetVehicleTyreBurst(vehicle,0,true,1000.0)
		end
	elseif tyre == 2 then
		if not IsVehicleTyreBurst(vehicle,1,false) then
			SetVehicleTyreBurst(vehicle,1,true,1000.0)
		end
	elseif tyre == 3 then
		if not IsVehicleTyreBurst(vehicle,4,false) then
			SetVehicleTyreBurst(vehicle,4,true,1000.0)
		end
	elseif tyre == 4 then
		if not IsVehicleTyreBurst(vehicle,5,false) then
			SetVehicleTyreBurst(vehicle,5,true,1000.0)
		end
	end

	if math.random(100) < 30 then
		Wait(500)
		vehicleTyreBurst(vehicle)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ 265.05,-1262.65,29.3,361,62,"Posto de Gasolina",0.4 },
	{ 819.02,-1027.96,26.41,361,62,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,62,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,62,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,62,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,62,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,62,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,62,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,62,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,62,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,62,"Posto de Gasolina",0.4 },
	{ 1207.4,2659.93,37.9,361,62,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,62,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,62,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,62,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,62,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,62,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,62,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,62,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,62,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,62,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,62,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,62,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,62,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,62,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,62,"Posto de Gasolina",0.4 },
	{ 1776.7,3330.56,41.32,361,62,"Posto de Gasolina",0.4 },
	{ -1112.4,-2884.08,13.93,361,62,"Posto de Gasolina",0.4 },
	{ 1155.43,-1521.37,34.85,80,38,"Hospital",0.5 },
	{ 1839.43,3672.86,34.27,80,38,"Hospital",0.5 },
	{ -247.42,6331.39,32.42,80,38,"Hospital",0.5 },
	{ 55.43,-876.19,30.66,357,5,"Garagem",0.6 },
	{ 598.04,2741.27,42.07,357,65,"Garagem",0.6 },
	{ -136.36,6357.03,31.49,357,65,"Garagem",0.6 },
	{ 275.23,-345.54,45.17,357,65,"Garagem",0.6 },
	{ 596.40,90.65,93.12,357,65,"Garagem",0.6 },
	{ -340.76,265.97,85.67,357,65,"Garagem",0.6 },
	{ -2030.01,-465.97,11.60,357,65,"Garagem",0.6 },
	{ -1184.92,-1510.00,4.64,357,65,"Garagem",0.6 },
	{ 214.02,-808.44,31.01,357,65,"Garagem",0.6 },
	{ -348.88,-874.02,31.31,357,65,"Garagem",0.6 },
	{ 67.74,12.27,69.21,357,65,"Garagem",0.6 },
	{ 361.90,297.81,103.88,357,65,"Garagem",0.6 },
	{ 1035.89,-763.89,57.99,357,65,"Garagem",0.6 },
	{ -796.63,-2022.77,9.16,357,65,"Garagem",0.6 },
	{ 453.27,-1146.76,29.52,357,65,"Garagem",0.6 },
	{ 528.66,-146.3,58.38,357,65,"Garagem",0.6 },
	{ -1159.48,-739.32,19.89,357,65,"Garagem",0.6 },
	{ 101.22,-1073.68,29.38,357,65,"Garagem",0.6 },
	{ -907.26,-2046.19,9.3,60,29,"Departamento Policial",0.6 },
	{ 1851.45,3686.71,34.26,60,29,"Departamento Policial",0.6 },
	{ -448.18,6011.68,31.71,60,29,"Departamento Policial",0.6 },
	{ 25.68,-1346.6,29.5,52,36,"Loja de Departamento",0.5 },
	{ 2556.47,382.05,108.63,52,36,"Loja de Departamento",0.5 },
	{ 1163.55,-323.02,69.21,52,36,"Loja de Departamento",0.5 },
	{ -707.31,-913.75,19.22,52,36,"Loja de Departamento",0.5 },
	{ -47.72,-1757.23,29.43,52,36,"Loja de Departamento",0.5 },
	{ 373.89,326.86,103.57,52,36,"Loja de Departamento",0.5 },
	{ -3242.95,1001.28,12.84,52,36,"Loja de Departamento",0.5 },
	{ 1729.3,6415.48,35.04,52,36,"Loja de Departamento",0.5 },
	{ 548.0,2670.35,42.16,52,36,"Loja de Departamento",0.5 },
	{ 1960.69,3741.34,32.35,52,36,"Loja de Departamento",0.5 },
	{ 2677.92,3280.85,55.25,52,36,"Loja de Departamento",0.5 },
	{ 1698.5,4924.09,42.07,52,36,"Loja de Departamento",0.5 },
	{ -1820.82,793.21,138.12,52,36,"Loja de Departamento",0.5 },
	{ 1393.21,3605.26,34.99,52,36,"Loja de Departamento",0.5 },
	{ -2967.78,390.92,15.05,52,36,"Loja de Departamento",0.5 },
	{ -3040.14,585.44,7.91,52,36,"Loja de Departamento",0.5 },
	{ 1135.56,-982.24,46.42,52,36,"Loja de Departamento",0.5 },
	{ 1166.0,2709.45,38.16,52,36,"Loja de Departamento",0.5 },
	{ -1487.21,-378.99,40.17,52,36,"Loja de Departamento",0.5 },
	{ -1222.76,-907.21,12.33,52,36,"Loja de Departamento",0.5 },
	{ 1692.62,3759.50,34.70,76,6,"Loja de Armas",0.4 },
	{ 252.89,-49.25,69.94,76,6,"Loja de Armas",0.4 },
	{ 843.28,-1034.02,28.19,76,6,"Loja de Armas",0.4 },
	{ -331.35,6083.45,31.45,76,6,"Loja de Armas",0.4 },
	{ -663.15,-934.92,21.82,76,6,"Loja de Armas",0.4 },
	{ -1305.18,-393.48,36.69,76,6,"Loja de Armas",0.4 },
	{ -1118.80,2698.22,18.55,76,6,"Loja de Armas",0.4 },
	{ 2568.83,293.89,108.73,76,6,"Loja de Armas",0.4 },
	{ -3172.68,1087.10,20.83,76,6,"Loja de Armas",0.4 },
	{ 21.32,-1106.44,29.79,76,6,"Loja de Armas",0.4 },
	{ 811.19,-2157.67,29.61,76,6,"Loja de Armas",0.4 },
	{ -815.12,-184.15,37.57,71,62,"Barbearia",0.5 },
	{ 138.13,-1706.46,29.3,71,62,"Barbearia",0.5 },
	{ -1280.92,-1117.07,7.0,71,62,"Barbearia",0.5 },
	{ 1930.54,3732.06,32.85,71,62,"Barbearia",0.5 },
	{ 1214.2,-473.18,66.21,71,62,"Barbearia",0.5 },
	{ -33.61,-154.52,57.08,71,62,"Barbearia",0.5 },
	{ -276.65,6226.76,31.7,71,62,"Barbearia",0.5 },
	{ 75.35,-1392.92,29.38,366,62,"Loja de Roupas",0.5 },
	{ -710.15,-152.36,37.42,366,62,"Loja de Roupas",0.5 },
	{ -163.73,-303.62,39.74,366,62,"Loja de Roupas",0.5 },
	{ -822.38,-1073.52,11.33,366,62,"Loja de Roupas",0.5 },
	{ -1193.13,-767.93,17.32,366,62,"Loja de Roupas",0.5 },
	{ -1449.83,-237.01,49.82,366,62,"Loja de Roupas",0.5 },
	{ 4.83,6512.44,31.88,366,62,"Loja de Roupas",0.5 },
	{ 1693.95,4822.78,42.07,366,62,"Loja de Roupas",0.5 },
	{ 125.82,-223.82,54.56,366,62,"Loja de Roupas",0.5 },
	{ 614.2,2762.83,42.09,366,62,"Loja de Roupas",0.5 },
	{ 1196.72,2710.26,38.23,366,62,"Loja de Roupas",0.5 },
	{ -3170.53,1043.68,20.87,366,62,"Loja de Roupas",0.5 },
	{ -1101.42,2710.63,19.11,366,62,"Loja de Roupas",0.5 },
	{ 425.6,-806.25,29.5,366,62,"Loja de Roupas",0.5 },
	{ -1082.22,-247.54,37.77,439,73,"Life Invader",0.6 },
	{ -1728.06,-1050.69,1.71,266,62,"Embarcações",0.5 },
	{ 1966.36,3975.86,31.51,266,62,"Embarcações",0.5 },
	{ -776.72,-1495.02,2.29,266,62,"Embarcações",0.5 },
	{ -893.97,5687.78,3.29,266,62,"Embarcações",0.5 },
	{ 452.99,-607.74,28.59,513,62,"Motorista",0.5 },
	{ 356.42,274.61,103.14,67,62,"Transportador",0.5 },
	{ -840.21,5399.25,34.61,285,62,"Lenhador",0.5 },
	{ 132.6,-1305.06,29.2,93,62,"Vanilla Unicorn",0.5 },
	{ -565.14,271.56,83.02,93,62,"Tequi-La-La",0.5 },
	{ -172.21,6385.85,31.49,403,5,"Farmácia",0.7 },
	{ 1690.07,3581.68,35.62,403,5,"Farmácia",0.7 },
	{ 315.12,-1068.58,29.39,403,5,"Farmácia",0.7 },
	{ 114.45,-4.89,67.82,403,5,"Farmácia",0.7 },
	{ 46.66,-1749.79,29.64,78,11,"Mercado Central",0.5 },
	{ 2747.28,3473.04,55.67,78,11,"Mercado Central",0.5 },
	{ 82.54,-1553.28,29.59,318,62,"Lixeiro",0.6 },
	{ -428.56,-1728.33,19.79,467,11,"Reciclagem",0.6 },
	{ -741.56,5594.94,41.66,36,62,"Teleférico",0.6 },
	{ 454.46,5571.95,781.19,36,62,"Teleférico",0.6 },
	{ -191.61,-1154.2,23.05,357,9,"Impound",0.6 },
	{ 1724.84,3715.31,34.22,357,9,"Impound",0.6 },
	{ -364.24,6071.16,31.52,357,9,"Impound",0.6 },
	{ -1178.37,-2845.97,13.93,402,26,"Mecânica",0.7 },
	{ 1144.38,-770.17,57.58,402,26,"Mecânica",0.7 },
	{ -1425.48,-436.4,35.79,402,26,"Mecânica",0.7 },
	{ -206.22,-1303.12,31.27,402,26,"Mecânica",0.7 },
	{ -359.81,-133.38,38.67,402,26,"Mecânica",0.7 },
	{ 717.04,-1087.21,22.34,402,26,"Mecânica",0.7 },
	{ -1144.02,-1989.42,13.16,402,26,"Mecânica",0.7 },
	{ 1178.0,2657.85,37.98,402,26,"Mecânica",0.7 },
	{ 116.38,6620.89,31.88,402,26,"Mecânica",0.7 },
	{ -49.34,-1041.79,28.21,402,26,"Mecânica",0.7 },
	{ -594.85,2090.27,131.6,617,62,"Minerador",0.6 },
	{ 1322.93,-1652.29,52.27,75,13,"Loja de Tatuagem",0.5 },
	{ -1154.42,-1425.9,4.95,75,13,"Loja de Tatuagem",0.5 },
	{ 322.84,180.16,103.58,75,13,"Loja de Tatuagem",0.5 },
	{ -3169.62,1075.8,20.83,75,13,"Loja de Tatuagem",0.5 },
	{ 1864.07,3747.9,33.03,75,13,"Loja de Tatuagem",0.5 },
	{ -293.57,6199.85,31.48,75,13,"Loja de Tatuagem",0.5 },
	{ 2768.92,1391.1,24.53,597,62,"Mergulhador",0.7 },
	{ 405.92,6526.12,27.73,89,62,"Colheita",0.4 },
	{ 1239.91,-3257.19,7.09,67,62,"Caminhoneiro",0.5 },
	{ -162.8,-2130.61,16.7,483,62,"Kartodromo",0.6 },
	{ -69.95,62.06,71.88,225,62,"Benefactor",0.4 },
	{ 895.36,-179.36,74.7,198,62,"Taxista",0.5 },
	{ -680.9,5832.41,17.32,141,62,"Caçador",0.7 },
	{ -3024.52,80.1,11.61,475,31,"Pacific Bluffs",0.5 },
	{ 562.36,2741.56,42.87,273,11,"Animal Park",0.5 },
	{ -1816.72,-1193.76,14.31,68,62,"Pescador",0.5 },
	{ 918.69,50.33,80.9,617,62,"Diamond Casino",0.6 },
	{ -604.39,-933.23,23.86,184,62,"Weazel News",0.6 },
	{ -585.45,-867.85,25.71,106,62,"Bullguer",0.5 },
	{ -816.05,-1346.36,5.14,597,62,"Loja do Mergulhador",0.7 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blip,v[4])
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v[5])
		SetBlipScale(blip,v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS
-----------------------------------------------------------------------------------------------------------------------------------------
local alphas = {
	{ -3418.14,967.56,8.34,20,2,175 },
	{ -4302.97,950.8,0.3,100,2,175 },
	{ 156.44,-1065.79,30.04,15,66,175 },
	{ -1188.13,-1574.47,4.35,15,66,175 },
	{ -777.44,5593.64,33.63,15,66,175 },
	{ 523.65,-1828.87,28.46,15,66,175 },
	{ 1370.35,-1520.08,57.49,15,66,175 },
	{ 102.74,-1959.16,20.79,15,66,175 },
	{ 337.63,-2036.08,21.37,15,66,175 },
	{ -161.39,-1628.59,33.63,15,66,175 },
	{ 236.22,-1702.66,29.23,15,66,175 },
	{ 1159.65,-1644.01,36.95,15,66,175 },
	{ -1073.36,-1659.74,4.38,15,66,175 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADALPHA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(alphas) do
		local blip = AddBlipForRadius(v[1],v[2],v[3],v[4] + 0.0)
		SetBlipAlpha(blip,255)
		SetBlipColour(blip,v[5])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for i = 1,25 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",true,true)
	SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
	StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
	StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
	SetAudioFlag("PoliceScannerDisabled",true)
	SetAudioFlag("DisableFlightMusic",true)
	SetPlayerCanUseCover(PlayerId(),false)
	SetRandomEventFlag(false)
	SetDeepOceanScaler(0.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		N_0xf4f2c0d4ee209e20()
		N_0x9e4cfff989258472()
		SetPlayerTargetingMode(2)
		DistantCopCarSirens(false)

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		SetVehicleModelIsSuppressed(GetHashKey("jet"),true)
		SetVehicleModelIsSuppressed(GetHashKey("blimp"),true)
		SetVehicleModelIsSuppressed(GetHashKey("polmav"),true)
		SetVehicleModelIsSuppressed(GetHashKey("buzzard2"),true)
		SetVehicleModelIsSuppressed(GetHashKey("mammatus"),true)
		SetVehicleModelIsSuppressed(GetHashKey("besra"),true)
		SetVehicleModelIsSuppressed(GetHashKey("luxor"),true)

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if IsPedArmed(PlayerPedId(),6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		end

		N_0x4757f00bc6323cfe("WEAPON_BAT",0.1)
		N_0x4757f00bc6323cfe("WEAPON_HAMMER",0.1)
		N_0x4757f00bc6323cfe("WEAPON_WRENCH",0.1)
		N_0x4757f00bc6323cfe("WEAPON_UNARMED",0.1)
		N_0x4757f00bc6323cfe("WEAPON_HATCHET",0.1)
		N_0x4757f00bc6323cfe("WEAPON_CROWBAR",0.1)
		N_0x4757f00bc6323cfe("WEAPON_MACHETE",0.1)
		N_0x4757f00bc6323cfe("WEAPON_POOLCUE",0.1)
		N_0x4757f00bc6323cfe("WEAPON_KNUCKLE",0.1)
		N_0x4757f00bc6323cfe("WEAPON_GOLFCLUB",0.1)
		N_0x4757f00bc6323cfe("WEAPON_BATTLEAXE",0.1)
		N_0x4757f00bc6323cfe("WEAPON_FLASHLIGHT",0.1)
		N_0x4757f00bc6323cfe("WEAPON_NIGHTSTICK",0.2)
		N_0x4757f00bc6323cfe("WEAPON_STONE_HATCHET",0.1)

		RemoveAllPickupsOfType("PICKUP_WEAPON_KNIFE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PISTOL")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MINISMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MICROSMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PUMPSHOTGUN")
		RemoveAllPickupsOfType("PICKUP_WEAPON_CARBINERIFLE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_SAWNOFFSHOTGUN")

		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)

		SetMaxWantedLevel(0)
		DisableVehicleDistantlights(true)
		ClearPlayerWantedLevel(PlayerId())
		DisablePlayerVehicleRewards(PlayerId())
		SetEveryoneIgnorePlayer(PlayerPedId(),true)
		SetPlayerCanBeHassledByGangs(PlayerPedId(),false)
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(),true)

		SetPedDensityMultiplierThisFrame(0.5)
		SetScenarioPedDensityMultiplierThisFrame(0.5,0.5)
		SetParkedVehicleDensityMultiplierThisFrame(0.5)
		SetRandomVehicleDensityMultiplierThisFrame(0.5)
		SetVehicleDensityMultiplierThisFrame(0.5)
		SetGarbageTrucks(false)
		SetRandomBoats(false)

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	{ 330.19,-601.21,43.29,343.65,-581.77,28.8 },
	{ 343.65,-581.77,28.8,330.19,-601.21,43.29 },

	{ 327.16,-603.53,43.29,338.97,-583.85,74.16 },
	{ 338.97,-583.85,74.16,327.16,-603.53,43.29 },

	{ -117.29,-604.52,36.29,-74.48,-820.8,243.39 },
	{ -74.48,-820.8,243.39,-117.29,-604.52,36.29 },

	{ -741.07,5593.13,41.66,446.19,5568.79,781.19 },
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66 },

	{ -740.78,5597.04,41.66,446.37,5575.02,781.19 },
	{ 446.37,5575.02,781.19,-740.78,5597.04,41.66 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local innerTable = {}

	for k,v in pairs(teleport) do
		table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Porta de Acesso","Pressione para acessar" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for _,v in pairs(teleport) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 1

					if IsControlJustPressed(1,38) then
						SetEntityCoords(ped,v[4],v[5],v[6],1,0,0,0)
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			local distance = #(coords - vector3(254.01,225.21,101.87))
			if distance <= 3.0 then
				timeDistance = 1

				if IsControlJustPressed(1,38) then
					local handle,object = FindFirstObject()
					local finished = false

					repeat
						local heading = GetEntityHeading(object)
						local coordsObj = GetEntityCoords(object)
						local distanceObjs = #(coordsObj - coords)

						if distanceObjs < 3.0 and GetEntityModel(object) == 961976194 then
							if heading > 150.0 then
								SetEntityHeading(object,0.0)
							else
								SetEntityHeading(object,160.0)
							end

							FreezeEntityPosition(object,true)
							finished = true
						end

						finished,object = FindNextObject(handle)
					until not finished

					EndFindObject(handle)
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	TriggerEvent("hoverfy:insertTable",{{ 254.01,225.21,101.87,1.5,"E","Porta do Cofre","Pressione para abrir/fechar" }})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_max = 80.0
local fov_min = 10.0
local speed_lr = 3.0
local speed_ud = 3.0
local zoomspeed = 2.0
local vehCamera = false
local fov = (fov_max + fov_min) * 0.5
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyHeli(ped) then
			timeDistance = 1

			local veh = GetVehiclePedIsUsing(ped)
			SetVehicleRadioEnabled(veh,false)

			if IsControlJustPressed(1,51) then
				TriggerEvent("hudActived",false)
				vehCamera = true
			end

			if IsControlJustPressed(1,154) then
				if GetPedInVehicleSeat(veh,1) == ped or GetPedInVehicleSeat(veh,2) == ped then
					TaskRappelFromHeli(ped,1)
				end
			end

			if vehCamera then
				SetTimecycleModifierStrength(0.3)
				SetTimecycleModifier("heliGunCam")

				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Wait(1)
				end

				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
				AttachCamToEntity(cam,veh,0.0,0.0,-1.5,true)
				SetCamRot(cam,0.0,0.0,GetEntityHeading(veh))
				SetCamFov(cam,fov)
				RenderScriptCams(true,false,0,1,0)
				PushScaleformMovieFunction(scaleform,"SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(0)
				PopScaleformMovieFunctionVoid()

				while vehCamera do
					if IsControlJustPressed(1,51) then
						TriggerEvent("hudActived",true)
						vehCamera = false
					end

					local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
					CheckInputRotation(cam,zoomvalue)
					HandleZoom(cam)
					HideHudAndRadarThisFrame()
					HideHudComponentThisFrame(19)
					PushScaleformMovieFunction(scaleform,"SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(veh).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam,2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform,255,255,255,255)

					Wait(1)
				end

				ClearTimecycleModifier()
				fov = (fov_max + fov_min) * 0.5
				RenderScriptCams(false,false,0,1,0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam,false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0,rotation.x + rightAxisY * -1.0 * (3.0) * (zoomvalue + 0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov - zoomspeed,fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov + zoomspeed,fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam,current_fov + (fov - current_fov) * 0.05)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUNNYHOP
-----------------------------------------------------------------------------------------------------------------------------------------
local bunnyHope = GetGameTimer()
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			if GetGameTimer() <= bunnyHope then
				timeDistance = 1
				DisableControlAction(1,22,true)
			else
				if IsPedJumping(ped) then
					bunnyHope = GetGameTimer() + 5000
				end
			end
		end

		Wait(timeDistance)
	end
end)