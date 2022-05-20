-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("radio",cRP)
vSERVER = Tunnel.getInterface("radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local activeRadio = false
local activeFrequencys = 0
local timeCheck = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("radioClose",function(data,cb)
	SetNuiFocus(false,false)
	vRP.removeObjects("one")
    SendNUIMessage({ action = "hideMenu" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:openSystem")
AddEventHandler("radio:openSystem",function()
	if not exports["police"]:checkPrison() then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showMenu" })

		if not IsPedInAnyVehicle(PlayerPedId()) then
			vRP.createObjects("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("activeFrequency",function(data)
	if parseInt(data["freq"]) >= 1 and parseInt(data["freq"]) <= 999 then
		vSERVER.activeFrequency(data["freq"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("inativeFrequency",function(data)
	TriggerEvent("radio:outServers")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startFrequency(frequency)
	if activeFrequencys ~= 0 then
		exports["pma-voice"]:removePlayerFromRadio()
	end

	exports["pma-voice"]:setRadioChannel(frequency)
	activeFrequencys = frequency
	activeRadio = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:outServers")
AddEventHandler("radio:outServers",function()
	if activeFrequencys ~= 0 then
		TriggerEvent("Notify","amarelo","Rádio desativado.",5000)
		exports["pma-voice"]:removePlayerFromRadio()
		TriggerEvent("hud:RadioDisplay",0)
		activeFrequencys = 0
		activeRadio = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:THREADCHECKRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		if GetGameTimer() >= timeCheck and activeRadio then
			timeCheck = GetGameTimer() + 60000

			local ped = PlayerPedId()
			if vSERVER.checkRadio() or IsPedSwimming(ped) then
				TriggerEvent("radio:outServers")
			end
		end

		Wait(10000)
	end
end)