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
Tunnel.bindInterface("inspect",cRP)
vSERVER = Tunnel.getInterface("inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	SendNUIMessage({ action = "hideMenu" })
	SetNuiFocus(false,false)
	vSERVER.resetInspect()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(data.item,data.slot,data.amount,data.target)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(data.item,data.slot,data.amount,data.target)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateChest",function(data,cb)
	vSERVER.updateChest(data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.openChest()
	if myInventory then
		cb({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSPECT:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inspect:Update")
AddEventHandler("inspect:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openInspect()
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "showMenu" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false
function cRP.toggleCarry(source)
	uCarry = source
	iCarry = not iCarry

	local ped = PlayerPedId()
	if iCarry and uCarry then
		Citizen.InvokeNative(0x6B9BBD38AB0796DF,PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(uCarry)),4103,11816,0.5,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped,false,false)
			sCarry = false
		end
	end
end