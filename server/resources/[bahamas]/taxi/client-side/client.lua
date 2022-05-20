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
Tunnel.bindInterface("taxi",cRP)
vSERVER = Tunnel.getInterface("taxi")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local lastPosition = 1
local serviceBlip = nil
local selectPosition = 1
local lastPassenger = nil
local currentStatus = false
local serviceStatus = false
local currentPassenger = nil
local initService = { 894.97,-179.07,74.7 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local stopVehicle = {
	{ -1966.18,-500.69,11.83,232.45 },
	{ -1649.93,-451.97,38.89,138.9 },
	{ -1375.14,-966.56,9.01,28.35 },
	{ -1253.14,-1314.72,3.99,201.26 },
	{ -1106.17,-1689.41,4.31,215.44 },
	{ -609.65,-1803.2,23.32,62.37 },
	{ -390.55,-1852.9,20.99,300.48 },
	{ -224.98,-2045.15,27.62,138.9 },
	{ 82.58,-1917.2,20.88,48.19 },
	{ 496.69,-1875.78,26.25,206.93 },
	{ 280.62,-2106.97,16.09,45.36 },
	{ 784.42,-2132.83,29.28,354.34 },
	{ 953.75,-1755.3,31.19,82.21 },
	{ 1307.21,-1718.47,54.31,113.39 },
	{ 502.32,-1725.65,29.27,158.75 },
	{ 789.17,-1392.76,27.04,178.59 },
	{ 1225.93,-1345.74,34.96,170.08 },
	{ 817.56,-1083.69,28.46,87.88 },
	{ 33.58,-1520.65,29.27,136.07 },
	{ -70.78,-1084.91,26.74,340.16 },
	{ -620.99,-921.48,23.3,357.17 },
	{ -741.52,-687.9,30.25,357.17 },
	{ -1227.9,-573.09,27.45,36.86 },
	{ -1311.16,228.57,58.72,87.88 },
	{ -1527.34,440.21,108.95,280.63 },
	{ -1062.61,447.58,74.41,303.31 },
	{ -515.49,423.41,97.09,36.86 },
	{ -755.98,-35.56,37.68,113.39 },
	{ -484.83,-386.07,34.22,263.63 },
	{ -48.76,-261.29,45.81,249.45 },
	{ -105.61,-612.03,36.08,158.75 },
	{ 239.69,-370.36,44.28,252.29 },
	{ 390.37,-83.02,67.75,68.04 },
	{ 709.88,53.65,83.95,141.74 },
	{ 385.57,312.39,103.14,73.71 },
	{ 317.75,570.27,154.45,221.11 },
	{ 247.24,-833.74,29.77,68.04 },
	{ 1150.78,-983.26,46.03,184.26 },
	{ 985.68,-688.99,57.39,204.1 },
	{ 1275.91,-420.3,69.05,206.93 },
	{ 1178.63,-286.08,69.0,218.27 },
	{ 917.39,48.98,80.9,325.99 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnPeds = {
	{ -1978.03,-509.14,11.85,235.28 },
	{ -1667.57,-441.15,40.36,51.03 },
	{ -1359.63,-963.53,9.69,306.15 },
	{ -1256.22,-1330.9,4.08,110.56 },
	{ -1097.49,-1673.1,8.39,306.15 },
	{ -614.88,-1787.1,23.69,36.86 },
	{ -399.23,-1885.84,21.74,127.56 },
	{ -248.08,-2025.52,29.94,229.61 },
	{ 126.73,-1930.0,21.38,212.6 },
	{ 484.66,-1876.23,26.13,116.23 },
	{ 289.85,-2077.23,17.66,294.81 },
	{ 799.38,-2086.64,29.49,130.4 },
	{ 951.99,-1734.68,31.09,175.75 },
	{ 1287.91,-1697.01,55.08,212.6 },
	{ 480.4,-1724.63,29.2,172.92 },
	{ 757.15,-1400.33,26.52,184.26 },
	{ 1204.51,-1367.64,35.37,266.46 },
	{ 828.89,-1067.89,28.19,274.97 },
	{ 20.66,-1505.68,31.85,48.19 },
	{ -40.66,-1082.03,26.61,252.29 },
	{ -598.49,-929.96,23.86,272.13 },
	{ -727.85,-690.97,30.31,5.67 },
	{ -1213.56,-567.34,27.35,158.75 },
	{ -1306.03,240.33,58.99,90.71 },
	{ -1539.98,420.77,110.01,0.0 },
	{ -1052.05,432.44,77.26,11.34 },
	{ -516.68,433.26,97.8,314.65 },
	{ -766.74,-23.56,41.08,25.52 },
	{ -486.25,-401.03,34.54,351.5 },
	{ -83.39,-282.18,45.54,170.08 },
	{ -117.37,-605.81,36.28,70.87 },
	{ 233.12,-410.45,48.11,158.75 },
	{ 390.24,-75.59,68.17,175.75 },
	{ 678.12,74.08,83.14,85.04 },
	{ 380.72,323.91,103.56,192.76 },
	{ 318.48,561.37,154.83,204.1 },
	{ 273.59,-833.14,29.4,19.85 },
	{ 1130.35,-981.46,46.4,158.75 },
	{ 970.84,-701.24,58.49,348.67 },
	{ 1262.68,-429.67,70.01,110.56 },
	{ 1169.03,-291.63,69.02,136.07 },
	{ 935.95,47.06,81.1,328.82 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnModels = {
	{ "ig_abigail",0x400AEC41 },
	{ "a_m_m_afriamer_01",0xD172497E },
	{ "ig_mp_agent14",0xFBF98469 },
	{ "csb_agent",0xD770C9B4 },
	{ "ig_amandatownley",0x6D1E15F7 },
	{ "s_m_y_ammucity_01",0x9E08633D },
	{ "u_m_y_antonb",0xCF623A2C },
	{ "g_m_m_armboss_01",0xF1E823A2 },
	{ "g_m_m_armgoon_01",0xFDA94268 },
	{ "g_m_m_armlieut_01",0xE7714013 },
	{ "ig_ashley",0x7EF440DB },
	{ "s_m_m_autoshop_01",0x040EABE3 },
	{ "ig_money",0x37FACDA6 },
	{ "g_m_y_ballaeast_01",0xF42EE883 },
	{ "g_f_y_ballas_01",0x158C439C },
	{ "g_m_y_ballasout_01",0x23B88069 },
	{ "s_m_y_barman_01",0xE5A11106 },
	{ "u_m_y_baygor",0x5244247D },
	{ "a_m_o_beach_01",0x8427D398 },
	{ "ig_bestmen",0x5746CD96 },
	{ "a_f_y_bevhills_01",0x445AC854 },
	{ "a_m_m_bevhills_02",0x3FB5C3D3 },
	{ "u_m_m_bikehire_01",0x76474545 },
	{ "u_f_y_bikerchic",0xFA389D4F },
	{ "mp_f_boatstaff_01",0x3293B9CE },
	{ "s_m_m_bouncer_01",0x9FD4292D },
	{ "ig_brad",0xBDBB4922 },
	{ "ig_bride",0x6162EC47 },
	{ "u_m_y_burgerdrug_01",0x8B7D3766 },
	{ "a_m_m_business_01",0x7E6A64B7 },
	{ "a_m_y_business_02",0xB3B3F5E6 },
	{ "s_m_o_busker_01",0xAD9EF1BB },
	{ "ig_car3guy2",0x75C34ACA },
	{ "cs_carbuyer",0x8CCE790F },
	{ "g_m_m_chiboss_01",0xB9DD0300 },
	{ "g_m_m_chigoon_01",0x7E4F763F },
	{ "g_m_m_chigoon_02",0xFF71F826 },
	{ "u_f_y_comjane",0xB6AA85CE },
	{ "ig_dale",0x467415E9 },
	{ "ig_davenorton",0x15CD4C33 },
	{ "s_m_y_dealer_01",0xE497BBEF },
	{ "ig_denise",0x820B33BD },
	{ "ig_devin",0x7461A0B0 },
	{ "a_m_y_dhill_01",0xFF3E88AB },
	{ "ig_dom",0x9C2DB088 },
	{ "a_m_y_downtown_01",0x2DADF4AA },
	{ "ig_dreyfuss",0xDA890932 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(initService[1],initService[2],initService[3]))
			if distance <= 2 then
				timeDistance = 1

				if serviceStatus then
					DrawText3D(initService[1],initService[2],initService[3],"~g~E~w~   FINALIZAR")
				else
					DrawText3D(initService[1],initService[2],initService[3],"~g~E~w~   INICIAR")
				end

				if IsControlJustPressed(1,38) then
					if serviceStatus then
						if vSERVER.initService(false) then
							serviceStatus = false

							if DoesBlipExist(serviceBlip) then
								RemoveBlip(serviceBlip)
								serviceBlip = nil
							end

							if currentPassenger ~= nil then
								TriggerServerEvent("tryDeleteObject",PedToNet(currentPassenger))
								currentPassenger = nil
							end

							if lastPassenger ~= nil then
								TriggerServerEvent("tryDeleteObject",lastPassenger)
								lastPassenger = nil
							end
						end
					else
						if vSERVER.initService(true) then
							repeat
								if lastPosition == selectPosition then
									selectPosition = math.random(#stopVehicle)
								end
							until lastPosition ~= selectPosition

							currentPassenger = nil
							currentStatus = false
							serviceStatus = true
							lastPassenger = nil
							blipPassenger()
						end
					end
				end
			end
		else
			if serviceStatus then
				local coords = GetEntityCoords(ped)
				local vehicle = GetVehiclePedIsUsing(ped)
				local distance = #(coords - vector3(stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3]))
				if distance <= 100 then
					timeDistance = 1

					DrawMarker(1,stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3] - 3,0,0,0,0,0,0,5.0,5.0,3.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3],0,0,0,0,180.0,130.0,1.5,1.5,1.0,42,137,255,100,0,0,0,1)

					if IsControlJustPressed(1,38) and distance <= 2.5 and GetEntityModel(vehicle) == -956048545 then
						if currentStatus then
							FreezeEntityPosition(vehicle,true)

							if DoesEntityExist(currentPassenger) then
								vSERVER.paymentService()
								Wait(1000)
								TaskLeaveVehicle(currentPassenger,vehicle,262144)
								TaskWanderStandard(currentPassenger,10.0,10)
								Wait(1000)
								SetVehicleDoorShut(vehicle,3,0)
								Wait(1000)
							end

							FreezeEntityPosition(vehicle,false)

							lastPassenger = PedToNet(currentPassenger)
							lastPosition = selectPosition
							currentStatus = false

							repeat
								if lastPosition == selectPosition then
									selectPosition = math.random(#stopVehicle)
								end
							until lastPosition ~= selectPosition

							blipPassenger()

							SetTimeout(10000,function()
								if lastPassenger ~= nil then
									TriggerServerEvent("tryDeleteObject",lastPassenger)
									lastPassenger = nil
								end
							end)
						else
							generatePassenger(vehicle)
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function generatePassenger(vehicle)
	if lastPassenger ~= nil then
		TriggerServerEvent("tryDeleteObject",lastPassenger)
		lastPassenger = nil
	end

	local randModels = math.random(#spawnModels)
	local mHash = GetHashKey(spawnModels[randModels][1])

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	if HasModelLoaded(mHash) then
		currentPassenger = CreatePed(4,spawnModels[randModels][2],spawnPeds[selectPosition][1],spawnPeds[selectPosition][2],spawnPeds[selectPosition][3],3374176,true,false)
		TaskEnterVehicle(currentPassenger,vehicle,-1,2,1.0,1,0)
		SetEntityAsMissionEntity(currentPassenger,true,true)
		SetEntityInvincible(currentPassenger,true)
		SetModelAsNoLongerNeeded(mHash)

		while true do
			Wait(1)

			if IsPedSittingInVehicle(currentPassenger,vehicle) then
				break
			end
		end

		lastPosition = selectPosition
		repeat
			if lastPosition == selectPosition then
				selectPosition = math.random(#stopVehicle)
			end
		until lastPosition ~= selectPosition

		currentStatus = true
		blipPassenger()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function blipPassenger()
	if DoesBlipExist(serviceBlip) then
		RemoveBlip(serviceBlip)
		serviceBlip = nil
	end

	serviceBlip = AddBlipForCoord(stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3])
	SetBlipSprite(serviceBlip,12)
	SetBlipColour(serviceBlip,5)
	SetBlipScale(serviceBlip,0.9)
	SetBlipRoute(serviceBlip,true)
	SetBlipAsShortRange(serviceBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Taxista")
	EndTextCommandSetBlipName(serviceBlip)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end