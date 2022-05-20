-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehMenu = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vehControl",function(source,args)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not vehMenu then
		local ped = PlayerPedId()
		if not IsEntityInWater(ped) and GetEntityHealth(ped) > 101 then
			local vehicle = vRP.vehList(7)
			if vehicle then
				SendNUIMessage({ show = true })
				SetCursorLocation(0.5,0.8)
				SetNuiFocus(true,true)
				vehMenu = true
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("vehControl","Abrir o menu rapido.","keyboard","f4")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	SendNUIMessage({ show = false })
	SetCursorLocation(0.5,0.5)
	SetNuiFocus(false,false)
	vehMenu = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENUACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("menuActive",function(data)
	local ped = PlayerPedId()
	if GetVehiclePedIsTryingToEnter(ped) <= 0 then
		if data["active"] == "chest" then
			TriggerServerEvent("trunkchest:openTrunk")

			SendNUIMessage({ show = false })
			SetCursorLocation(0.5,0.5)
			SetNuiFocus(false,false)
			vehMenu = false
		elseif data["active"] == "door1" then
			TriggerServerEvent("vehmenu:doors","1")
		elseif data["active"] == "door2" then
			TriggerServerEvent("vehmenu:doors","2")
		elseif data["active"] == "door3" then
			TriggerServerEvent("vehmenu:doors","3")
		elseif data["active"] == "door4" then
			TriggerServerEvent("vehmenu:doors","4")
		elseif data["active"] == "trunk" then
			TriggerServerEvent("vehmenu:doors","5")
		elseif data["active"] == "hood" then
			TriggerServerEvent("vehmenu:doors","6")
			
			SendNUIMessage({ show = false })
			SetCursorLocation(0.5,0.5)
			SetNuiFocus(false,false)
			vehMenu = false
		elseif data["active"] == "vtuning" then
			TriggerEvent("engine:vehTuning")

			SendNUIMessage({ show = false })
			SetCursorLocation(0.5,0.5)
			SetNuiFocus(false,false)
			vehMenu = false
		end
	end
end)