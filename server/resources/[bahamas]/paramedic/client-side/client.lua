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
Tunnel.bindInterface("paramedic",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userDamage = {}
local userBleeding = 0
local myInjuries = false
local playerActive = false
local showDiagnostic = false
local timeInjuries = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local bones = {
	[11816] = "Pelvis",
	[58271] = "Coxa Esquerda",
	[63931] = "Panturrilha Esquerda",
	[14201] = "Pe Esquerdo",
	[2108] = "Dedo do Pe Esquerdo",
	[65245] = "Pe Esquerdo",
	[57717] = "Pe Esquerdo",
	[46078] = "Joelho Esquerdo",
	[51826] = "Coxa Direita",
	[36864] = "Panturrilha Direita",
	[52301] = "Pe Direito",
	[20781] = "Dedo do Pe Direito",
	[35502] = "Pe Direito",
	[24806] = "Pe Direito",
	[16335] = "Joelho Direito",
	[23639] = "Coxa Direita",
	[6442] = "Coxa Direita",
	[57597] = "Espinha Cervical",
	[23553] = "Espinha Toraxica",
	[24816] = "Espinha Lombar",
	[24817] = "Espinha Sacral",
	[24818] = "Espinha Cocciana",
	[64729] = "Escapula Esquerda",
	[45509] = "Braco Esquerdo",
	[61163] = "Antebraco Esquerdo",
	[18905] = "Mao Esquerda",
	[18905] = "Mao Esquerda",
	[26610] = "Dedo Esquerdo",
	[4089] = "Dedo Esquerdo",
	[4090] = "Dedo Esquerdo",
	[26611] = "Dedo Esquerdo",
	[4169] = "Dedo Esquerdo",
	[4170] = "Dedo Esquerdo",
	[26612] = "Dedo Esquerdo",
	[4185] = "Dedo Esquerdo",
	[4186] = "Dedo Esquerdo",
	[26613] = "Dedo Esquerdo",
	[4137] = "Dedo Esquerdo",
	[4138] = "Dedo Esquerdo",
	[26614] = "Dedo Esquerdo",
	[4153] = "Dedo Esquerdo",
	[4154] = "Dedo Esquerdo",
	[60309] = "Mao Esquerda",
	[36029] = "Mao Esquerda",
	[61007] = "Antebraco Esquerdo",
	[5232] = "Antebraco Esquerdo",
	[22711] = "Cotovelo Esquerdo",
	[10706] = "Escapula Direita",
	[40269] = "Braco Direito",
	[28252] = "Antebraco Direito",
	[57005] = "Mao Direita",
	[58866] = "Dedo Direito",
	[64016] = "Dedo Direito",
	[64017] = "Dedo Direito",
	[58867] = "Dedo Direito",
	[64096] = "Dedo Direito",
	[64097] = "Dedo Direito",
	[58868] = "Dedo Direito",
	[64112] = "Dedo Direito",
	[64113] = "Dedo Direito",
	[58869] = "Dedo Direito",
	[64064] = "Dedo Direito",
	[64065] = "Dedo Direito",
	[58870] = "Dedo Direito",
	[64080] = "Dedo Direito",
	[64081] = "Dedo Direito",
	[28422] = "Mao Direita",
	[6286] = "Mao Direita",
	[43810] = "Antebraço Direito",
	[37119] = "Antebraço Direito",
	[2992] = "Cotovelo Direito",
	[39317] = "Pescoco",
	[31086] = "Cabeca",
	[12844] = "Cabeca",
	[65068] = "Rosto"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:playerActive")
AddEventHandler("paramedic:playerActive",function()
	playerActive = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(name,args)
	if name == "CEventNetworkEntityDamage" then
		if PlayerPedId() == args[1] and playerActive and GetGameTimer() >= timeInjuries then
			if not IsPedInAnyVehicle(args[1]) and GetEntityHealth(args[1]) > 101 then
				local ped = PlayerPedId()
				timeInjuries = GetGameTimer() + 2500

				if not userDamage["vehicle"] and HasEntityBeenDamagedByAnyVehicle(ped) then
					userBleeding = userBleeding + 1
					userDamage["vehicle"] = true
				end

				if not userDamage["tazer"] and IsPedAPlayer(args[2]) and IsPedArmed(args[2],6) and GetSelectedPedWeapon(args[2]) ~= GetHashKey("WEAPON_STUNGUN") then
					userDamage["tazer"] = true
				end

				if not IsPedBeingStunned(ped) then
					userBleeding = userBleeding + 1
				end

				local hit,bone = GetPedLastDamageBone(ped)
				if hit and not userDamage[bone] and bone ~= 0 then
					TriggerServerEvent("evidence:dropEvidence","yellow")
					userDamage[bone] = true
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local bleedingTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= bleedingTimers then
			bleedingTimers = GetGameTimer() + 15000

			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 and userBleeding >= 3 then
				if userBleeding >= 7 then
					ApplyDamageToPed(ped,5,false)
				else
					ApplyDamageToPed(ped,userBleeding - 2,false)
				end

				TriggerEvent("Notify","blood","Sangramento encontrado.",3000)
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetDiagnostic")
AddEventHandler("resetDiagnostic",function()
	ClearPedBloodDamage(PlayerPedId())
	userBleeding = 0
	userDamage = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetBleeding")
AddEventHandler("resetBleeding",function()
	userBleeding = 0
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWINJURIES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drawInjuries")
AddEventHandler("drawInjuries",function(ped,injuries)
	local serverId = GetPlayerFromServerId(ped)
	local playerPed = GetPlayerPed(serverId)
	showDiagnostic = not showDiagnostic
	local countDiagnostic = 0

	while true do
		if countDiagnostic >= 1000 or not showDiagnostic then
			showDiagnostic = false
			break
		end

		for k,v in pairs(injuries) do
			if bones[k] then
				local coords = GetPedBoneCoords(playerPed,k)
				DrawText3D(coords["x"],coords["y"],coords["z"],"~w~"..string.upper(bones[k]))
			end
		end

		countDiagnostic = countDiagnostic + 1

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYINJURIES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:myInjuries")
AddEventHandler("paramedic:myInjuries",function()
	myInjuries = not myInjuries
	local countDiagnostic = 0

	while true do
		if countDiagnostic >= 1000 or not myInjuries then
			myInjuries = false
			break
		end

		for k,v in pairs(userDamage) do
			if bones[k] then
				local coords = GetPedBoneCoords(PlayerPedId(),k)
				DrawText3D(coords["x"],coords["y"],coords["z"],"~w~"..string.upper(bones[k]))
			end
		end

		countDiagnostic = countDiagnostic + 1

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getDiagnostic()
	return userDamage,userBleeding
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getBleeding()
	return userBleeding
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

		local width = (string.len(text) + 4) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,45,39,64,200)
	end
end