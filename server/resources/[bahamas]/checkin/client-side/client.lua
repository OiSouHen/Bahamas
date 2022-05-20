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
Tunnel.bindInterface("checkin",cRP)
vSERVER = Tunnel.getInterface("checkin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
local checkIn = {
	{ 1139.78,-1536.89,35.38,"Santos" },
	{ 1832.08,3677.19,34.28,"Sandy" },
	{ -254.32,6330.47,32.55,"Paleto" },
	{ 1768.75,2570.56,45.73,"Bolingbroke" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDSIN
-----------------------------------------------------------------------------------------------------------------------------------------
local bedsIn = {
	["Santos"] = {
		{ 1120.41,-1547.11,35.89,0.0 },
		{ 1123.56,-1547.11,35.89,0.0 },
		{ 1126.65,-1547.11,35.89,0.0 },
		{ 1127.46,-1538.37,35.89,178.59 },
		{ 1124.31,-1538.37,35.89,178.59 },
		{ 1121.23,-1538.37,35.89,181.42 },
		{ 1120.92,-1562.3,35.89,0.0 },
		{ 1124.0,-1562.3,35.89,0.0 },
		{ 1126.96,-1562.3,35.89,0.0 },
		{ 1127.52,-1553.64,35.89,175.75 },
		{ 1124.75,-1553.65,35.89,181.42 },
		{ 1121.78,-1553.65,35.89,181.42 }
	},
	["Sandy"] = {
		{ 1823.36,3680.79,35.2,212.6 },
		{ 1821.66,3679.81,35.2,212.6 },
		{ 1819.97,3678.84,35.2,212.6 },
		{ 1818.27,3677.85,35.2,212.6 },
		{ 1817.13,3674.7,35.2,300.48 },
		{ 1818.11,3672.99,35.2,300.48 },
		{ 1819.09,3671.29,35.2,300.48 },
		{ 1820.08,3669.61,35.2,300.48 },
		{ 1823.29,3672.23,35.2,119.06 },
		{ 1822.24,3674.05,35.2,119.06 }
	},
	["Paleto"] = {
		{ -252.15,6323.11,33.35,133.23 },
		{ -246.98,6317.95,33.35,133.23 },
		{ -245.27,6316.22,33.35,133.23 },
		{ -251.03,6310.51,33.35,317.49 },
		{ -252.63,6312.12,33.35,317.49 },
		{ -254.39,6313.88,33.35,317.49 },
		{ -256.1,6315.58,33.35,317.49 }
	},
	["Bolingbroke"] = {
		{ 1771.98,2591.79,46.66,87.88 },
		{ 1771.98,2594.88,46.66,87.88 },
		{ 1771.98,2597.95,46.66,87.88 },
		{ 1761.87,2597.73,46.66,272.13 },
		{ 1761.87,2594.64,46.66,272.13 },
		{ 1761.87,2591.56,46.66,272.13 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("checkin:initCheck")
AddEventHandler("checkin:initCheck",function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for _,v in pairs(checkIn) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 2 then
			local checkBusy = 0
			local checkSelected = v[4]

			for _,v in pairs(bedsIn[checkSelected]) do
				checkBusy = checkBusy + 1

				local checkPos = nearestPlayer(v[1],v[2],v[3])
				if not checkPos then
					if vSERVER.paymentCheckin() then
						TriggerEvent("player:blockCommands",true)
						TriggerEvent("inventory:preventWeapon",true)

						if GetEntityHealth(ped) <= 101 then
							vRP.revivePlayer(102)
						end

						DoScreenFadeOut(0)
						Wait(1000)

						SetEntityCoords(ped,v[1],v[2],v[3],1,0,0,0)

						Wait(1000)
						TriggerEvent("emotes","checkinskyz")

						Wait(1000)
						DoScreenFadeIn(1000)
					end

					break
				end
			end

			if checkBusy >= #bedsIn[checkSelected] then
				TriggerEvent("Notify","amarelo","Macas ocupadas, aguarde um momento.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function nearestPlayers(x,y,z)
	local userList = {}
	local ped = PlayerPedId()
	local userPlayers = GetPlayers()

	for k,v in pairs(userPlayers) do
		local uPlayer = GetPlayerFromServerId(k)
		if uPlayer ~= PlayerId() and NetworkIsPlayerConnected(uPlayer) then
			local uPed = GetPlayerPed(uPlayer)
			local uCoords = GetEntityCoords(uPed)
			local distance = #(uCoords - vector3(x,y,z))
			if distance <= 2 then
				userList[uPlayer] = distance
			end
		end
	end

	return userList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function nearestPlayer(x,y,z)
	local userSelect = false
	local minRadius = 2.0001
	local userList = nearestPlayers(x,y,z)

	for _,_Infos in pairs(userList) do
		if _Infos <= minRadius then
			minRadius = _Infos
			userSelect = true
		end
	end

	return userSelect
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
	local pedList = {}

	for _,_player in ipairs(GetActivePlayers()) do
		pedList[GetPlayerServerId(_player)] = true
	end

	return pedList
end