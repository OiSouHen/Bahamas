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
Tunnel.bindInterface("homes",cRP)
vSERVER = Tunnel.getInterface("homes")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local homes = {
	["list"] = {},
	["open"] = "",
	["theft"] = "",
	["vault"] = "",
	["garage"] = 0,
	["shell"] = nil,
	["intern"] = {},
	["current"] = {},
	["locker"] = nil,
	["blips"] = false,
	["called"] = false,
	["theftCoords"] = {},
	["blipsCoords"] = {},
	["police"] = GetGameTimer(),
	["pressButton"] = GetGameTimer(),
	["hotel"] = { -3024.52,80.1,11.61 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:UPDATECALLED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:UpdateCalled")
AddEventHandler("homes:UpdateCalled",function()
	homes["called"] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v["x"] << 8) | v["y"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKERCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local lockerCoords = {
	["Middle"] = { 4.52,-1.13,1499.00,180.0 },
	["Mansion"] = { -2.37,11.14,1499.20,90.0 },
	["Trailer"] = { 3.49,-2.00,1499.00,180.0 },
	["Beach"] = { 8.76,0.49,1499.05,270.0 },
	["Simple"] = { 2.60,2.68,1500.45,0.0 },
	["Motel"] = { -5.10,2.78,1499.80,90.0 },
	["Modern"] = { 4.64,6.27,1499.10,270.0 },
	["Hotel"] = { -1.04,3.87,1499.10,0.0 },
	["Franklin"] = { 1.19,3.43,1499.00,0.0 },
	["Container"] = { 2.80,1.33,1499.9,0.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEFTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local theftCoords = {
	["Middle"] = {
		["MOBILE01"] = { 0.45,-2.87,-0.8 },
		["MOBILE02"] = { -4.26,-5.36,-0.3 },
		["MOBILE03"] = { -5.61,-5.21,-0.8 },
		["MOBILE04"] = { -7.57,2.04,-1.0 },
		["MOBILE05"] = { -3.91,2.08,-1.0 },
		["MOBILE06"] = { 0.77,2.96,0.1 },
		["MOBILE07"] = { 5.68,-1.13,-0.8 },
		["MOBILE08"] = { 7.15,-1.00,-1.0 },
		["MOBILE09"] = { 6.38,5.78,-0.3 },
		["MOBILE10"] = { 3.59,3.83,-0.9 },
		["MOBILE11"] = { 1.60,4.58,-0.7 },
		["MOBILE12"] = { -0.54,-2.46,-0.3 },
		["LOCKER"] = { 4.47,-1.00,-0.9 }
	},
	["Mansion"] = {
		["MOBILE01"] = { 0.93,-14.28,-0.2 },
		["MOBILE02"] = { -0.41,-18.88,-0.2 },
		["MOBILE03"] = { -5.93,-18.00,-0.1 },
		["MOBILE04"] = { -3.97,-13.54,0.5 },
		["MOBILE05"] = { 5.80,-11.88,0.5 },
		["MOBILE06"] = { 8.98,0.43,-0.5 },
		["MOBILE07"] = { 4.97,5.94,-0.1 },
		["MOBILE08"] = { -2.41,9.43,-0.6 },
		["MOBILE09"] = { 1.48,8.29,-0.5 },
		["MOBILE10"] = { 3.19,14.13,-0.9 },
		["MOBILE11"] = { -0.08,14.00,-0.9 },
		["MOBILE12"] = { -2.80,17.30,-0.7 },
		["LOCKER"] = { -2.37,11.14,-0.7 }
	},
	["Trailer"] = {
		["MOBILE01"] = { 5.57,-1.36,-0.7 },
		["MOBILE02"] = { 1.82,-1.79,-0.7 },
		["MOBILE03"] = { 0.22,1.70,-0.5 },
		["MOBILE04"] = { -6.10,-1.47,-0.3 },
		["MOBILE05"] = { -4.39,-1.97,-0.8 },
		["MOBILE06"] = { -3.25,-1.85,-0.2 },
		["LOCKER"] = { 3.49,-2.00,-1.0 }
	},
	["Beach"] = {
		["MOBILE01"] = { -0.62,-0.95,-0.6 },
		["MOBILE02"] = { 3.14,-3.75,-0.6 },
		["MOBILE03"] = { 8.36,-3.60,-0.1 },
		["MOBILE04"] = { 7.86,-0.49,-0.8 },
		["MOBILE05"] = { 6.47,0.34,-0.8 },
		["MOBILE06"] = { 7.80,3.72,-0.8 },
		["MOBILE07"] = { 3.63,3.00,-0.1 },
		["MOBILE08"] = { 0.78,2.10,-0.3 },
		["MOBILE09"] = { -1.07,2.79,-0.6 },
		["MOBILE10"] = { -8.31,3.55,-0.9 },
		["MOBILE11"] = { -5.39,-3.83,-0.2 },
		["MOBILE12"] = { -1.45,-2.98,-0.7 },
		["LOCKER"] = { 8.76,0.49,-0.8 }
	},
	["Simple"] = {
		["MOBILE01"] = { -5.74,-1.80,0.6 },
		["MOBILE02"] = { -5.49,2.60,0.8 },
		["MOBILE03"] = { -4.06,2.62,0.8 },
		["MOBILE04"] = { -3.30,2.63,1.2 },
		["MOBILE05"] = { 1.41,-2.15,1.2 },
		["MOBILE06"] = { 5.61,-3.89,0.5 },
		["MOBILE07"] = { 5.53,-0.58,0.5 },
		["MOBILE08"] = { 5.57,0.66,0.8 },
		["LOCKER"] = { 2.60,2.68,0.7 }
	},
	["Motel"] = {
		["MOBILE01"] = { 5.08,2.05,0.3 },
		["MOBILE02"] = { 4.89,3.40,0.6 },
		["MOBILE03"] = { 2.31,6.13,0.2 },
		["MOBILE04"] = { 1.05,6.16,0.0 },
		["MOBILE05"] = { -3.55,0.30,0.6 },
		["LOCKER"] = { -5.10,2.78,0.0 }
	},
	["Modern"] = {
		["MOBILE01"] = { -1.01,0.42,-0.6 },
		["MOBILE02"] = { 3.07,-2.66,-0.8 },
		["MOBILE03"] = { 2.14,7.27,-0.1 },
		["MOBILE04"] = { 1.02,7.27,-0.1 },
		["MOBILE05"] = { 0.05,7.27,-0.1 },
		["MOBILE06"] = { -1.98,7.26,-0.6 },
		["MOBILE07"] = { -3.46,4.33,-0.6 },
		["MOBILE08"] = { -0.56,4.34,-0.6 },
		["MOBILE09"] = { -0.59,2.92,-0.1 },
		["MOBILE10"] = { -0.59,1.53,-0.1 },
		["LOCKER"] = { 4.64,6.27,-0.8 }
	},
	["Hotel"] = {
		["MOBILE01"] = { 2.40,-1.78,-0.8 },
		["MOBILE02"] = { -1.78,2.59,-0.1 },
		["MOBILE03"] = { -2.24,0.95,-0.6 },
		["MOBILE04"] = { -2.26,-0.49,-0.7 },
		["LOCKER"] = { -1.04,3.87,-0.8 }
	},
	["Franklin"] = {
		["MOBILE01"] = { -1.81,-5.41,-0.7 },
		["MOBILE02"] = { -2.59,-5.59,-0.8 },
		["MOBILE03"] = { -5.45,-5.75,-1.0 },
		["MOBILE04"] = { -2.68,-0.50,-1.0 },
		["MOBILE05"] = { -3.74,3.31,-0.6 },
		["MOBILE06"] = { 2.01,7.33,-0.7 },
		["MOBILE07"] = { 4.40,5.50,-0.7 },
		["MOBILE08"] = { 4.31,4.59,-0.2 },
		["MOBILE09"] = { 5.15,-0.81,-0.8 },
		["MOBILE10"] = { 0.93,-0.25,-0.9 },
		["MOBILE11"] = { 4.81,-6.93,-0.8 },
		["LOCKER"] = { 1.19,3.43,-0.9 }
	},
	["Container"] = {
		["MOBILE01"] = { 1.45,-1.29,0.7 },
		["MOBILE02"] = { 4.46,-1.30,0.6 },
		["MOBILE03"] = { 4.62,0.72,0.1 },
		["MOBILE04"] = { 1.75,1.55,0.1 },
		["MOBILE05"] = { 0.59,1.44,0.7 },
		["MOBILE06"] = { -0.51,1.44,0.7 },
		["MOBILE07"] = { -1.63,1.55,0.1 },
		["MOBILE08"] = { -4.62,0.76,0.1 },
		["MOBILE09"] = { -4.44,-1.31,0.6 },
		["LOCKER"] = { 2.80,1.33,0.0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateHomes(homesTable)
	local innerTable = {}

	for k,v in pairs(homesTable) do
		local gridZone = getGridzone(v[1],v[2])

		if homes["list"][gridZone] == nil then
			homes["list"][gridZone] = {}
		end

		homes["list"][gridZone][k] = v

		table.insert(innerTable,{ v[1],v[2],v[3],1.25,"E","Porta de Acesso","Pressione para entrar" })
	end

	table.insert(innerTable,{ homes["hotel"][1],homes["hotel"][2],homes["hotel"][3],1.5,"E","Elevador","Pressione para subir" })

	TriggerEvent("hoverfy:insertTable",innerTable)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	SendNUIMessage({ action = "hideMenu" })
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(data["slot"],data["amount"],data["target"],homes["open"],homes["vault"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(data["item"],data["slot"],data["amount"],data["target"],homes["open"],homes["vault"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateChest",function(data,cb)
	vSERVER.updateChest(data["slot"],data["target"],data["amount"],homes["open"],homes["vault"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.openChest(homes["open"],homes["vault"])
	if myInventory then
		cb({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:Update")
AddEventHandler("homes:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:UPDATEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:UpdateWeight")
AddEventHandler("homes:UpdateWeight",function(invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTRANCEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.entranceHomes(homeName,v,interior,theft)
	DoScreenFadeOut(0)

	homes["current"] = v
	homes["open"] = homeName
	homes["theftCoords"] = {}
	TriggerEvent("homes:Hours",true)
	TriggerEvent("sounds:source","enterhouse",0.7)

	local ped = PlayerPedId()

	if interior == "Middle" then
		createShells(v[1],v[2],1500.0,"creative_middle")
		SetEntityCoords(ped,v[1] + 1.36,v[2] - 14.23,1500.0 - 1,1,0,0,0)
		table.insert(homes["intern"],{ v[1] + 1.36,v[2] - 14.23,1499.5,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] + 7.15,v[2] - 1.00,1499.0,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] - 0.54,v[2] - 2.46,1499.5,"fridge","ABRIR" })
		end
	elseif interior == "Mansion" then
		createShells(v[1],v[2],1499.0,"creative_mansion")
		SetEntityCoords(ped,v[1] - 8.68,v[2] - 3.43,1501.0 - 0.5,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 8.68,v[2] - 3.43,1501.0,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] - 3.97,v[2] - 13.58,1500.5,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] + 5.81,v[2] - 11.88,1500.5,"fridge","ABRIR" })
		end
	elseif interior == "Trailer" then
		createShells(v[1],v[2],1500.0,"creative_trailer")
		SetEntityCoords(ped,v[1] - 1.44,v[2] - 2.02,1500.0 - 1,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 1.44,v[2] - 2.02,1499.5,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] - 4.36,v[2] - 1.97,1499.2,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] + 0.20,v[2] + 1.70,1499.5,"fridge","ABRIR" })
		end
	elseif interior == "Beach" then
		createShells(v[1],v[2],1500.0,"creative_beach")
		SetEntityCoords(ped,v[1] + 0.11,v[2] - 3.68,1500.0 - 1,1,0,0,0)
		table.insert(homes["intern"],{ v[1] + 0.11,v[2] - 3.68,1499.5,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] + 8.36,v[2] - 3.60,1499.8,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] - 1.47,v[2] - 0.96,1499.8,"fridge","ABRIR" })
		end
	elseif interior == "Simple" then
		createShells(v[1],v[2],1500.0,"creative_simple")
		SetEntityCoords(ped,v[1] - 4.89,v[2] - 4.15,1501.0 - 0.5,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 4.89,v[2] - 4.15,1501.0,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] + 1.43,v[2] - 2.11,1501.2,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] - 3.33,v[2] + 2.63,1501.2,"fridge","ABRIR" })
		end
	elseif interior == "Motel" then
		createShells(v[1],v[2],1500.0,"creative_motel")
		SetEntityCoords(ped,v[1] + 4.6,v[2] - 6.36,1498.5 - 0.5,1,0,0,0)
		table.insert(homes["intern"],{ v[1] + 4.6,v[2] - 6.36,1498.5,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] + 5.08,v[2] + 2.05,1500.3,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] + 4.89,v[2] + 3.40,1500.5,"fridge","ABRIR" })
		end
	elseif interior == "Modern" then
		createShells(v[1],v[2],1500.0,"creative_modern")
		SetEntityCoords(ped,v[1] - 1.63,v[2] - 5.94,1500.0 - 0.75,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 1.63,v[2] - 5.94,1499.7,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] - 0.59,v[2] + 2.95,1499.8,"vault","ABRIR" })

			if homes["open"] ~= "Modern" then
				table.insert(homes["intern"],{ v[1] + 2.15,v[2] + 7.27,1499.8,"fridge","ABRIR" })
			end
		end
	elseif interior == "Hotel" then
		createShells(v[1],v[2],1500.0,"creative_hotel")
		SetEntityCoords(ped,v[1] - 1.69,v[2] - 3.91,1500.0 - 0.5,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 1.69,v[2] - 3.91,1499.8,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] - 2.25,v[2] + 0.95,1499.4,"vault","ABRIR" })
		end
	elseif interior == "Franklin" then
		createShells(v[1],v[2],1500.0,"creative_franklin")
		SetEntityCoords(ped,v[1] - 0.47,v[2] - 5.91,1500.0 - 1,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 0.47,v[2] - 5.91,1499.6,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] - 2.60,v[2] - 5.59,1499.3,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] + 4.31,v[2] + 4.58,1499.8,"fridge","ABRIR" })
		end
	elseif interior == "Container" then
		createShells(v[1],v[2],1499.0,"creative_container")
		SetEntityCoords(ped,v[1] - 1.14,v[2] - 1.38,1500.0,1,0,0,0)
		table.insert(homes["intern"],{ v[1] - 1.14,v[2] - 1.38,1500.5,"exit","SAIR" })

		if not theft then
			table.insert(homes["intern"],{ v[1] + 4.47,v[2] - 1.32,1500.5,"vault","ABRIR" })
			table.insert(homes["intern"],{ v[1] + 1.45,v[2] - 1.29,1500.5,"fridge","ABRIR" })
		end
	end

	FreezeEntityPosition(ped,true)
	Wait(1000)
	FreezeEntityPosition(ped,false)
	DoScreenFadeIn(1000)

	if theft then
		homes["theft"] = interior
		homes["police"] = GetGameTimer() + 15000

		if math.random(100) >= 90 then
			if DoesEntityExist(homes["locker"]) then
				DeleteEntity(homes["locker"])
				homes["locker"] = nil
			end

			local mHash = GetHashKey("prop_ld_int_safe_01")

			RequestModel(mHash)
			while not HasModelLoaded(mHash) do
				Wait(1)
			end

			if HasModelLoaded(mHash) then
				homes["locker"] = CreateObjectNoOffset(mHash,v[1] + lockerCoords[interior][1],v[2] + lockerCoords[interior][2],lockerCoords[interior][3],false,false,false)

				SetEntityHeading(homes["locker"],lockerCoords[interior][4])
				FreezeEntityPosition(homes["locker"],true)
				SetModelAsNoLongerNeeded(mHash)
			end
		else
			homes["theftCoords"]["LOCKER"] = true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATESHELLS
-----------------------------------------------------------------------------------------------------------------------------------------
function createShells(x,y,z,hash)
	if DoesEntityExist(homes["shell"]) then
		DeleteEntity(homes["shell"])
		homes["shell"] = nil
	end

	homes["shell"] = CreateObjectNoOffset(GetHashKey(hash),x,y,z,false,false,false)
	FreezeEntityPosition(homes["shell"],true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		if homes["theft"] ~= "" and homes["open"] ~= "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local speed = GetEntitySpeed(ped)
				local coords = GetEntityCoords(ped)

				if speed > 2 and GetGameTimer() >= homes["police"] and not homes["called"] then
					homes["police"] = GetGameTimer() + 15000
					vSERVER.callPolice()
				end

				if theftCoords[homes["theft"]] then
					for k,v in pairs(theftCoords[homes["theft"]]) do
						if not homes["theftCoords"][k] then
							local distance = #(coords - vector3(homes["current"][1] + v[1],homes["current"][2] + v[2],1500.0))

							if distance <= 1.25 then
								timeDistance = 1
								DrawText3D(homes["current"][1] + v[1],homes["current"][2] + v[2],1500.0 + v[3],"~g~E~w~   VASCULHAR")

								if IsControlJustPressed(1,38) then
									if k == "LOCKER" then
										local safeCracking = exports["safecrack"]:safeCraking(3)
										if safeCracking then
											vSERVER.paymentTheft("LOCKER",GetPedStealthMovement(ped))
										end

										homes["theftCoords"][k] = true
									else
										TriggerEvent("cancelando",true)

										local taskBar = exports["taskbar"]:taskHomes()
										if taskBar then
											vSERVER.paymentTheft("MOBILE",GetPedStealthMovement(ped))
											homes["theftCoords"][k] = true
										end

										TriggerEvent("cancelando",false)
									end
								end
							end
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTERN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if homes["open"] ~= "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)

				for k,v in pairs(homes["intern"]) do
					if coords["z"] <= 1450 and v[4] == "exit" then
						SetEntityCoords(ped,v[1],v[2],v[3],1,0,0,0)
					end

					local distance = #(coords - vector3(v[1],v[2],v[3]))
					if distance <= 1.25 then
						timeDistance = 1
						DrawText3D(v[1],v[2],v[3],"~g~E~w~   "..v[5])

						if IsControlJustPressed(1,38) then
							if v[4] == "exit" then
								if distance <= 1 then
									DoScreenFadeOut(0)

									if homes["open"] == "Modern" then
										SetEntityCoords(ped,homes["hotel"][1],homes["hotel"][2],homes["hotel"][3] - 0.75,1,0,0,0)
									else
										SetEntityCoords(ped,homes["current"][1],homes["current"][2],homes["current"][3] - 0.75,1,0,0,0)
									end

									TriggerEvent("sounds:source","outhouse",0.5)
									vSERVER.removeNetwork(homes["open"])
									TriggerEvent("homes:Hours",false)
									homes["theftCoords"] = {}
									homes["called"] = false
									homes["intern"] = {}
									homes["theft"] = ""
									homes["open"] = ""

									if DoesEntityExist(homes["shell"]) then
										DeleteEntity(homes["shell"])
										homes["shell"] = nil
									end

									if DoesEntityExist(homes["locker"]) then
										DeleteEntity(homes["locker"])
										homes["locker"] = nil
									end

									FreezeEntityPosition(ped,true)
									Wait(1000)
									FreezeEntityPosition(ped,false)
									DoScreenFadeIn(1000)
								end
							elseif v[4] == "vault" or v[4] == "fridge" then
								if vSERVER.checkPermissions(homes["open"]) then
									TriggerEvent("sounds:source","chest",0.7)
									SendNUIMessage({ action = "showMenu" })
									SetNuiFocus(true,true)
									homes["vault"] = v[4]
								end
							end
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:TOGGLEPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:togglePropertys")
AddEventHandler("homes:togglePropertys",function()
	if homes["blips"] then
		homes["blips"] = false
		TriggerEvent("Notify","amarelo","Marcações desativadas.",3000)

		for k,v in pairs(homes["blipsCoords"]) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end
	else
		homes["blips"] = true
		local result = vSERVER.homeBlips()
		TriggerEvent("Notify","amarelo","Marcações ativadas.",3000)

		for k,v in pairs(result) do
			homes["blipsCoords"][k] = AddBlipForCoord(v["x"],v["y"],v["z"])
			SetBlipSprite(homes["blipsCoords"][k],v["id"])
			SetBlipAsShortRange(homes["blipsCoords"][k],true)
			SetBlipScale(homes["blipsCoords"][k],v["scale"])
			SetBlipColour(homes["blipsCoords"][k],v["color"])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMEGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.homeGarage(homeName)
	homes["garage"] = 0
	local homeCoords = {}
	homeCoords[homeName] = {}
	homeCoords[homeName]["1"] = {}

	CreateThread(function()
		while true do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			if homes["garage"] >= 2 then
				TriggerServerEvent("garages:updateGarages",homeName,homeCoords[homeName])
				break
			end

			if IsControlJustPressed(1,38) then
				homes["garage"] = homes["garage"] + 1

				if homes["garage"] <= 1 then
					TriggerEvent("Notify","amarelo","Fique no <b>local olhando</b> pra onde deseja que o veículo<br>apareça e pressione a tecla <b>E</b> novamente.",10000)
					homeCoords[homeName] = { x = mathLegth(coords["x"]), y = mathLegth(coords["y"]), z = mathLegth(coords["z"]) }
				else
					TriggerEvent("Notify","verde","Garagem adicionada.",10000)
					homeCoords[homeName]["1"] = { mathLegth(coords["x"]),mathLegth(coords["y"]),mathLegth(coords["z"]),mathLegth(heading) }
				end
			end

			Wait(1)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOTEL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if homes["open"] == "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)
				local distance = #(coords - vector3(homes["hotel"][1],homes["hotel"][2],homes["hotel"][3]))

				if distance <= 1.5 then
					timeDistance = 1

					if IsControlJustPressed(1,38) and vSERVER.checkHotel() then
						vSERVER.initHotel()
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENTER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if homes["open"] == "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)
				local gridZone = getGridzone(coords["x"],coords["y"])

				if homes["list"][gridZone] then
					for k,v in pairs(homes["list"][gridZone]) do
						local distance = #(coords - vector3(v[1],v[2],v[3]))

						if distance <= 1.25 then
							timeDistance = 1

							if IsControlJustPressed(1,38) and GetGameTimer() >= homes["pressButton"] then
								homes["pressButton"] = GetGameTimer() + 3000
								vSERVER.enterPropertys(k)
							end
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
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