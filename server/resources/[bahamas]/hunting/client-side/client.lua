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
Tunnel.bindInterface("hunting",cRP)
vSERVER = Tunnel.getInterface("hunting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blipHunting = {}
local inHunting = false
local animalHunting = {}
local huntCoords = { -672.76,5837.39,17.32 }
local animalHahs = { "a_c_deer","a_c_coyote","a_c_mtlion","a_c_pig","a_c_panther","a_c_boar" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local animalCoords = {
	{ -2600.58,2753.33,2.83,36.86 },
	{ -2566.56,2772.45,2.83,0.0 },
	{ -2508.77,2768.44,2.85,272.13 },
	{ -2481.99,2812.92,3.25,306.15 },
	{ -2431.88,2820.82,3.5,257.96 },
	{ -2451.83,2746.61,2.04,79.38 },
	{ -2480.1,2723.28,2.88,85.04 },
	{ -2519.84,2689.44,2.91,107.72 },
	{ -2531.52,2650.37,2.86,110.56 },
	{ -2555.39,2641.24,3.29,110.56 },
	{ -2513.15,2603.4,1.58,178.59 },
	{ -2571.17,2541.05,1.67,133.23 },
	{ -2599.8,2521.69,2.86,130.4 },
	{ -2620.31,2501.24,3.1,130.4 },
	{ -2636.67,2462.38,2.95,136.07 },
	{ -2629.41,2433.28,3.37,147.41 },
	{ -2605.91,2416.7,3.17,150.24 },
	{ -2570.54,2412.76,3.82,189.93 },
	{ -2539.29,2422.79,5.0,215.44 },
	{ -2532.6,2443.68,1.94,246.62 },
	{ -2529.87,2474.35,3.23,272.13 },
	{ -2570.21,2506.12,1.87,323.15 },
	{ -2533.66,2518.96,3.17,320.32 },
	{ -2471.84,2506.26,2.06,260.79 },
	{ -2441.16,2494.87,2.91,246.62 },
	{ -2397.46,2471.4,1.65,240.95 },
	{ -2376.63,2464.34,3.0,243.78 },
	{ -2362.65,2442.33,2.98,240.95 },
	{ -2390.09,2433.09,4.33,221.11 },
	{ -2365.22,2419.05,8.09,221.11 },
	{ -2333.43,2393.44,3.71,223.94 },
	{ -2337.15,2371.75,4.9,215.44 },
	{ -2324.5,2345.46,3.49,212.6 },
	{ -2282.75,2359.19,3.17,240.95 },
	{ -2286.18,2392.09,3.45,291.97 },
	{ -2272.33,2426.31,3.0,314.65 },
	{ -2252.86,2426.85,7.19,291.97 },
	{ -2233.67,2418.82,10.46,274.97 },
	{ -2225.9,2440.46,9.17,283.47 },
	{ -2207.86,2473.88,7.55,303.31 },
	{ -2189.09,2483.45,5.59,303.31 },
	{ -2167.19,2481.3,3.56,300.48 },
	{ -2150.87,2473.6,2.9,297.64 },
	{ -2127.81,2467.3,1.62,289.14 },
	{ -2101.22,2470.62,1.55,286.3 },
	{ -2091.09,2482.82,3.08,286.3 },
	{ -2068.98,2511.14,3.1,294.81 },
	{ -2108.37,2546.4,3.07,345.83 },
	{ -2130.56,2566.09,2.98,357.17 },
	{ -2208.79,2540.51,1.38,96.38 },
	{ -2237.06,2554.91,3.03,90.71 },
	{ -2265.4,2568.24,1.4,73.71 },
	{ -2284.37,2552.39,2.78,73.71 },
	{ -2347.83,2635.46,1.68,39.69 },
	{ -2341.18,2644.3,1.65,19.85 },
	{ -2327.44,2672.71,2.75,14.18 },
	{ -2319.79,2688.99,3.25,14.18 },
	{ -2308.14,2709.82,3.37,11.34 },
	{ -2304.96,2731.71,2.75,8.51 },
	{ -2301.4,2745.26,2.81,8.51 },
	{ -2292.4,2767.53,2.78,5.67 },
	{ -2275.8,2774.44,3.37,0.0 },
	{ -2273.11,2747.64,2.63,328.82 },
	{ -2275.06,2706.98,1.63,266.46 },
	{ -2275.6,2672.31,1.63,243.78 },
	{ -2247.7,2680.05,2.58,252.29 },
	{ -2220.88,2697.13,2.9,280.63 },
	{ -2204.75,2711.9,2.75,280.63 },
	{ -2188.31,2741.77,5.02,277.8 },
	{ -2170.72,2732.31,4.95,272.13 },
	{ -2163.94,2706.15,3.27,260.79 },
	{ -2166.39,2675.21,2.85,240.95 },
	{ -2146.08,2640.93,2.65,232.45 },
	{ -2112.92,2636.46,3.13,235.28 },
	{ -2100.89,2658.4,2.8,249.45 },
	{ -2087.47,2691.83,3.47,280.63 },
	{ -2054.42,2693.45,3.44,280.63 },
	{ -2039.01,2680.92,3.25,277.8 },
	{ -2008.02,2652.41,2.86,249.45 },
	{ -1998.18,2629.39,2.88,240.95 },
	{ -2006.14,2594.99,3.34,206.93 },
	{ -2024.53,2579.7,3.29,204.1 },
	{ -1986.56,2577.0,3.02,221.11 },
	{ -1965.13,2575.26,2.7,223.94 },
	{ -1931.41,2615.28,1.82,255.12 },
	{ -1924.23,2626.75,3.56,255.12 },
	{ -1906.18,2626.33,2.93,257.96 },
	{ -1865.65,2625.31,1.89,263.63 },
	{ -1845.91,2636.79,2.76,283.47 },
	{ -1822.98,2649.1,2.68,283.47 },
	{ -1816.06,2631.38,2.8,266.46 },
	{ -1800.18,2640.74,3.12,266.46 },
	{ -1774.23,2657.87,2.91,274.97 },
	{ -1766.99,2696.1,4.13,308.98 },
	{ -1745.92,2732.25,5.39,311.82 },
	{ -1712.98,2741.2,4.99,303.31 },
	{ -1678.32,2721.29,4.26,280.63 },
	{ -1658.26,2701.38,3.79,272.13 },
	{ -1635.07,2676.06,3.25,255.12 },
	{ -1642.2,2641.77,2.48,229.61 },
	{ -1678.21,2635.11,1.92,170.08 },
	{ -1696.6,2619.51,2.51,147.41 },
	{ -1661.27,2568.66,3.12,195.6 },
	{ -1674.17,2547.47,4.01,192.76 },
	{ -1708.62,2541.78,3.59,175.75 },
	{ -1734.71,2549.06,1.87,155.91 },
	{ -1760.41,2572.73,3.35,121.89 },
	{ -1772.01,2585.87,1.7,119.06 },
	{ -1787.11,2537.56,3.71,136.07 },
	{ -1779.69,2508.66,4.9,141.74 },
	{ -1793.73,2495.83,5.63,141.74 },
	{ -1821.32,2492.91,4.75,138.9 },
	{ -1841.82,2482.61,5.14,136.07 },
	{ -1867.81,2481.0,5.31,130.4 },
	{ -1879.39,2492.06,3.54,127.56 },
	{ -1888.73,2509.57,4.33,116.23 },
	{ -1892.36,2539.32,2.65,87.88 },
	{ -1903.23,2549.68,2.66,87.88 },
	{ -1927.05,2546.46,2.8,87.88 },
	{ -1945.06,2530.36,1.5,93.55 },
	{ -1962.06,2528.72,1.25,93.55 },
	{ -1982.01,2517.06,2.29,93.55 },
	{ -2010.17,2505.76,1.97,96.38 },
	{ -2037.3,2494.66,1.26,104.89 },
	{ -2048.79,2461.55,3.54,121.89 },
	{ -2063.55,2455.34,3.69,121.89 },
	{ -2089.66,2454.91,1.82,119.06 },
	{ -2113.67,2448.11,3.0,116.23 },
	{ -2130.75,2456.37,2.93,116.23 },
	{ -2155.14,2441.21,3.1,116.23 },
	{ -2162.13,2426.88,4.33,116.23 },
	{ -2179.08,2396.55,6.64,127.56 },
	{ -2203.79,2410.09,7.16,116.23 },
	{ -2211.07,2444.35,6.05,79.38 },
	{ -2209.99,2473.32,7.87,62.37 },
	{ -2188.81,2497.28,5.54,22.68 },
	{ -2208.81,2538.15,1.45,22.68 },
	{ -2240.28,2554.88,2.97,31.19 },
	{ -2270.17,2548.42,3.15,62.37 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(huntCoords[1],huntCoords[2],huntCoords[3]))

			if distance <= 2 then
				timeDistance = 1

				if inHunting then
					DrawText3D(huntCoords[1],huntCoords[2],huntCoords[3],"~g~E~w~   FINALIZAR")
				else
					DrawText3D(huntCoords[1],huntCoords[2],huntCoords[3],"~g~E~w~   INICIAR")
				end

				if IsControlJustPressed(1,38) and distance <= 1 then
					for k,v in pairs(blipHunting) do
						if DoesBlipExist(blipHunting[k]) then
							RemoveBlip(blipHunting[k])
							blipHunting[k] = nil
						end
					end

					for k,v in pairs(animalHunting) do
						if DoesEntityExist(animalHunting[k]) then
							DeleteEntity(animalHunting[k])
							animalHunting[k] = nil
						end
					end

					if inHunting then
						inHunting = false
					else
						inHunting = true

						for i = 1,25 do
							newHunting(i)
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNTING:ANIMALCUTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hunting:animalCutting")
AddEventHandler("hunting:animalCutting",function()
	local ped = PlayerPedId()
	if inHunting and animalHunting then
		local coords = GetEntityCoords(ped)
		for k,v in pairs(animalHunting) do
			local deerCoords = GetEntityCoords(animalHunting[k])
			local distance = #(coords - deerCoords)

			if distance <= 1.5 then
				if IsPedDeadOrDying(animalHunting[k]) and not IsPedAPlayer(animalHunting[k]) then
					if vSERVER.checkSwitchblade() and GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
						TaskTurnPedToFaceEntity(ped,animalHunting[k],-1)
						TriggerEvent("player:blockCommands",true)
						local targetEntity = animalHunting[k]
						TriggerEvent("cancelando",true)
						animalHunting[k] = nil

						Wait(1000)

						vRP.playAnim(true,{"anim@gangops@facility@servers@bodysearch@","player_search"},true)
						vRP.playAnim(false,{"amb@medic@standing@kneel@base","base"},true)

						Wait(15000)

						TriggerEvent("player:blockCommands",false)
						TriggerEvent("cancelando",false)
						vSERVER.animalPayment()
						vRP.removeObjects()

						if DoesBlipExist(blipHunting[k]) then
							RemoveBlip(blipHunting[k])
							blipHunting[k] = nil
						end

						if DoesEntityExist(targetEntity) then
							DeleteEntity(targetEntity)
						end

						newHunting(k)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWHUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
function newHunting(i)
	local rand = math.random(#animalHahs)
	local mHash = GetHashKey(animalHahs[rand])

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	if HasModelLoaded(mHash) then
		local spawnX = math.random(-250,250)
		local spawnY = math.random(-250,250)
		local inLocate = math.random(#animalCoords)

		animalHunting[i] = CreatePed(28,mHash,animalCoords[inLocate][1],animalCoords[inLocate][2],animalCoords[inLocate][3] - 1,false,false,false)
		TaskGoStraightToCoord(animalHunting[i],animalCoords[inLocate][1] + spawnX,animalCoords[inLocate][2] + spawnY,animalCoords[inLocate][3],0.5,-1,0.0,0.0)
		SetPedKeepTask(animalHunting[i],true)
		SetPedCombatMovement(animalHunting[i],3)
		SetPedCombatAbility(animalHunting[i],100)
		SetPedCombatAttributes(animalHunting[i],46,1)

		blipAnimal(i)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
function blipAnimal(i)
	if DoesBlipExist(blipHunting[i]) then
		RemoveBlip(blipHunting[i])
		blipHunting[i] = nil
	end

	blipHunting[i] = AddBlipForEntity(animalHunting[i])
	SetBlipSprite(blipHunting[i],141)
	SetBlipColour(blipHunting[i],41)
	SetBlipScale(blipHunting[i],0.8)
	SetBlipAsShortRange(blipHunting[i],true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Cervo")
	EndTextCommandSetBlipName(blipHunting[i])
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