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
Tunnel.bindInterface("admin",cRP)
vSERVER = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.teleportWay()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		ped = GetVehiclePedIsUsing(ped)
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09,waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped,x,y,height,1,0,0)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(ped) do
			Wait(1)
		end

		Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(ped,0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(ped) do
		Wait(1)
	end

	SetEntityCoordsNoOffset(ped,x,y,z,1,0,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.teleportLimbo()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local _,xCoords = GetNthClosestVehicleNode(coords["x"],coords["y"],coords["z"],1,0,0,0)

	SetEntityCoordsNoOffset(ped,xCoords["x"],xCoords["y"],xCoords["z"] + 1,1,0,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:vehicleTuning")
AddEventHandler("admin:vehicleTuning",function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)

		SetVehicleModKit(vehicle,0)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11)-1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12)-1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13)-1,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15)-1,false)
		ToggleVehicleMod(vehicle,18,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			local ped = PlayerPedId()
-- 			local vehicle = GetVehiclePedIsUsing(ped)
-- 			local vehCoords = GetEntityCoords(vehicle)
-- 			local leftCoords = GetOffsetFromEntityInWorldCoords(vehicle,5.0,0.0,0.0)
-- 			local rightCoords = GetOffsetFromEntityInWorldCoords(vehicle,-5.0,0.0,0.0)

-- 			vSERVER.raceCoords(vehCoords,leftCoords,rightCoords)
-- 		end

-- 		Wait(1)
-- 	end
-- end)