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
Tunnel.bindInterface("robberys",cRP)
vSERVER = Tunnel.getInterface("robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local robberys = {}
local robberyId = "1"
local robberyTimer = 0
local robberySeconds = 0
local robberyActive = false
local activeTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			if not robberyActive then
				for k,v in pairs(robberys) do
					local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))

					if distance <= 1 then
						timeDistance = 1

						if IsControlJustPressed(1,38) and robberySeconds <= 0 then
							robberySeconds = 5

							if vSERVER.checkRobbery(k) then
								robberyId = k
								robberyTimer = v["timer"]
								activeTimers = GetGameTimer()
								SendNUIMessage({ show = true, timer = "AGUARDE "..robberyTimer.." SEGUNDOS" })

								robberyActive = true
							end
						end
					end
				end
			else
				local distance = #(coords - vector3(robberys[robberyId]["coords"][1],robberys[robberyId]["coords"][2],robberys[robberyId]["coords"][3]))
				if distance > robberys[robberyId]["distance"] or GetEntityHealth(ped) <= 101 then
					SendNUIMessage({ show = false })
					robberyActive = false
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if robberyActive then
			if GetGameTimer() >= activeTimers then
				robberyTimer = robberyTimer - 1
				activeTimers = GetGameTimer() + 1000
				SendNUIMessage({ timer = "AGUARDE "..robberyTimer.." SEGUNDOS" })

				if robberyTimer <= 0 then
					vSERVER.paymentRobbery(robberyId)
					SendNUIMessage({ show = false })
					robberyActive = false
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if robberySeconds > 0 then
			robberySeconds = robberySeconds - 1
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.inputRobberys(robberyTables)
	robberys = robberyTables

	local innerTable = {}
	for k,v in pairs(robberys) do
		table.insert(innerTable,{ v["coords"][1],v["coords"][2],v["coords"][3],1,"E",v["name"],"Pressione para iniciar o roubo" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end