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
Tunnel.bindInterface("dismantle",cRP)
vSERVER = Tunnel.getInterface("dismantle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local dismantleProgress = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDoors = {
	{ "handle_dside_f",0 },
	{ "handle_pside_f",1 },
	{ "handle_dside_r",2 },
	{ "handle_pside_r",3 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHTYRES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehTyres = {
	{ "wheel_lf",0 },
	{ "wheel_rf",1 },
	{ "wheel_lr",4 },
	{ "wheel_rr",5 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:CHECKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dismantle:checkVehicle")
AddEventHandler("dismantle:checkVehicle",function(vehicle)
	if not dismantleProgress then
		local ped = PlayerPedId()
		local vehName = vRP.vehicleModel(vehicle[2])
		local vehPlate = GetVehicleNumberPlateText(vehicle[1])

		if vSERVER.removeList(vehPlate,vehName) then
			dismantleProgress = true

			SetEntityInvincible(ped,true)
			FreezeEntityPosition(ped,true)
			TriggerEvent("cancelando",true)
			FreezeEntityPosition(vehicle[1],true)
			vRP.playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

			for _,v in pairs(vehDoors) do
				local objectExist = GetEntityBoneIndexByName(vehicle[1],v[1])
				if objectExist ~= -1 then
					Wait(10000)
					SetVehicleDoorBroken(vehicle[1],v[2],false)
				end
			end

			for _,v in pairs(vehTyres) do
				local objectExist = GetEntityBoneIndexByName(vehicle[1],v[1])
				if objectExist ~= -1 then
					Wait(10000)
					SetVehicleTyreBurst(vehicle[1],v[2],1,1000.01)
				end
			end

			vRP.removeObjects()
			SetEntityInvincible(ped,false)
			FreezeEntityPosition(ped,false)
			TriggerEvent("cancelando",false)
			vSERVER.paymentMethod(vehicle[1])

			dismantleProgress = false
		end
	end
end)