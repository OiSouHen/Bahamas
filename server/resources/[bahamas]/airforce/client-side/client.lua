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
Tunnel.bindInterface("airforce",cRP)
vSERVER = Tunnel.getInterface("airforce")
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
local initService = { -940.79,-2960.2,13.93 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local stopVehicle = {
	{ -1582.19,-569.64,116.33,263.63 },
	{ -1391.65,-477.78,91.24,306.15 },
	{ -913.5,-378.44,137.9,300.48 },
	{ -144.6,-593.35,211.77,175.75 },
	{ -75.19,-818.86,326.18,150.24 },
	{ 476.81,-1106.55,43.07,87.88 },
	{ 965.82,42.03,123.12,331.66 },
	{ 910.34,-1681.39,51.12,172.92 },
	{ 2510.72,-342.05,118.18,42.52 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnPeds = {
	{ -1570.2,-576.56,114.44,215.44 },
	{ -1382.29,-471.03,89.44,121.89 },
	{ -902.96,-369.95,136.28,300.48 },
	{ -138.98,-584.7,211.75,235.28 },
	{ -69.56,-810.19,326.18,218.27 },
	{ 484.59,-1094.01,43.07,0.0 },
	{ 977.99,61.59,120.24,331.66 },
	{ 915.82,-1699.71,51.12,175.75 },
	{ 2507.44,-336.83,115.84,320.32 }
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
					else
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
		else
			if serviceStatus then
				local coords = GetEntityCoords(ped)
				local vehicle = GetVehiclePedIsUsing(ped)
				local distance = #(coords - vector3(stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3]))
				if distance <= 100 then
					timeDistance = 1

					DrawMarker(1,stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3] - 3,0,0,0,0,0,0,5.0,5.0,3.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,stopVehicle[selectPosition][1],stopVehicle[selectPosition][2],stopVehicle[selectPosition][3],0,0,0,0,180.0,130.0,1.5,1.5,1.0,42,137,255,100,0,0,0,1)

					if IsControlJustPressed(1,38) and distance <= 5 then
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
	AddTextComponentString("Passageiro")
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