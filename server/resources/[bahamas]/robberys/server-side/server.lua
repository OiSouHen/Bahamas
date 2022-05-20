-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("robberys",cRP)
vCLIENT = Tunnel.getInterface("robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYAVAILABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local robberyAvailable = {
	["departament"] = GetGameTimer(),
	["ammunation"] = GetGameTimer(),
	["fleecas"] = GetGameTimer(),
	["barbershop"] = GetGameTimer(),
	["banks"] = GetGameTimer(),
	["jewelry"] = GetGameTimer()
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
local robberys = {
	["1"] = {
		["coords"] = { 28.24,-1338.832,29.5 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["2"] = {
		["coords"] = { 2548.883,384.850,108.63 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["3"] = {
		["coords"] = { 1159.156,-314.055,69.21 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 20,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["4"] = {
		["coords"] = { -710.067,-904.091,19.22 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["5"] = {
		["coords"] = { -43.652,-1748.122,29.43 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["6"] = {
		["coords"] = { 378.291,333.712,103.57 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["7"] = {
		["coords"] = { -3250.385,1004.504,12.84 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["8"] = {
		["coords"] = { 1734.968,6421.161,35.04 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["9"] = {
		["coords"] = { 546.450,2662.45,42.16 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["10"] = {
		["coords"] = { 1959.113,3749.239,32.35 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["11"] = {
		["coords"] = { 2672.457,3286.811,55.25 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["12"] = {
		["coords"] = { 1708.095,4920.711,42.07 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["13"] = {
		["coords"] = { -1829.422,798.491,138.2 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["14"] = {
		["coords"] = { -2959.66,386.765,14.05 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["15"] = {
		["coords"] = { -3048.155,585.519,7.91 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["16"] = {
		["coords"] = { 1126.75,-979.760,45.42 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["17"] = {
		["coords"] = { 1169.631,2717.833,37.16 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["18"] = {
		["coords"] = { -1478.67,-375.675,39.17 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["19"] = {
		["coords"] = { -1221.126,-916.213,11.33 },
		["name"] = "Loja de Departamento",
		["type"] = "departament",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card01",
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["20"] = {
		["coords"] = { 1693.374,3761.669,34.71 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["21"] = {
		["coords"] = { 253.061,-51.643,69.95 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["22"] = {
		["coords"] = { 841.128,-1034.951,28.2 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["23"] = {
		["coords"] = { -330.467,6085.647,31.46 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["24"] = {
		["coords"] = { -660.987,-933.901,21.83 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["25"] = {
		["coords"] = { -1304.775,-395.832,36.7 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["26"] = {
		["coords"] = { -1117.765,2700.388,18.56 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["27"] = {
		["coords"] = { 2566.632,292.945,108.74 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["28"] = {
		["coords"] = { -3172.701,1089.462,20.84 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["29"] = {
		["coords"] = { 23.733,-1106.27,29.8 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["30"] = {
		["coords"] = { 808.914,-2158.684,29.62 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["item"] = "card02",
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",30000,45000 }
		}
	},
	["31"] = {
		["coords"] = { -1210.409,-336.485,38.29 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "goldbar",100,125 }
		}
	},
	["32"] = {
		["coords"] = { -353.519,-55.518,49.54 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "goldbar",100,125 }
		}
	},
	["33"] = {
		["coords"] = { 311.525,-284.649,54.67 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "goldbar",100,125 }
		}
	},
	["34"] = {
		["coords"] = { 147.210,-1046.292,29.87 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "goldbar",100,125 }
		}
	},
	["35"] = {
		["coords"] = { -2956.449,482.090,16.2 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "goldbar",100,125 }
		}
	},
	["36"] = {
		["coords"] = { 1175.66,2712.939,38.59 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "goldbar",100,125 }
		}
	},
	["37"] = {
		["coords"] = { -810.15,-179.57,37.57 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["38"] = {
		["coords"] = { 134.4,-1707.81,29.28 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["39"] = {
		["coords"] = { -1284.26,-1115.11,6.99 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["40"] = {
		["coords"] = { 1930.61,3727.97,32.84 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["41"] = {
		["coords"] = { 1211.45,-470.7,66.2 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["42"] = {
		["coords"] = { -30.56,-151.83,57.07 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["43"] = {
		["coords"] = { -277.75,6230.6,31.69 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["44"] = {
		["coords"] = { -104.386,6477.150,31.83 },
		["name"] = "Saving Bank",
		["type"] = "banks",
		["distance"] = 12.0,
		["cooldown"] = 360,
		["item"] = "card05",
		["timer"] = 900,
		["cops"] = 20,
		["payment"] = {
			{ "goldbar",150,175 }
		}
	},
	["45"] = {
		["coords"] = { 265.336,220.184,102.09 },
		["name"] = "Vinewood Vault",
		["type"] = "banks",
		["distance"] = 20.0,
		["cooldown"] = 360,
		["item"] = "card05",
		["timer"] = 900,
		["cops"] = 20,
		["payment"] = {
			{ "goldbar",150,175 }
		}
	},
	["46"] = {
		["coords"] = { 3559.93,3675.97,28.12 },
		["name"] = "Humane Labs",
		["type"] = "banks",
		["distance"] = 20.0,
		["cooldown"] = 360,
		["timer"] = 1200,
		["cops"] = 12,
		["lock"] = 6,
		["payment"] = {
			{ "goldbar",150,175 }
		}
	},
	["47"] = {
		["coords"] = { -622.0,-230.82,38.05 },
		["name"] = "Joalheria",
		["type"] = "jewelry",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["item"] = "pendrive",
		["timer"] = 600,
		["cops"] = 10,
		["payment"] = {
			{ "watch",400,600 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if robberys[robberyId] then
			local prev = robberys[robberyId]

			if GetGameTimer() >= robberyAvailable[prev["type"]] then
				local policeResult = vRP.numPermission("Police")
				if parseInt(#policeResult) > parseInt(prev["cops"]) then
					local consultItem = vRP.getInventoryItemAmount(user_id,prev["item"])
					if consultItem[1] <= 0 then
						TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName(prev["item"]).."</b> para roubar.",5000)
						return false
					end

					if vRP.checkBroken(consultItem[2]) then
						return false
					end

					if vRP.tryGetInventoryItem(user_id,consultItem[2],1) then
						TriggerClientEvent("player:applyGsr",source)
						robberyAvailable[prev["type"]] = GetGameTimer() + (prev["cooldown"] * 60000)

						for k,v in pairs(policeResult) do
							async(function()
								TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = prev["name"], x = prev["coords"][1], y = prev["coords"][2], z = prev["coords"][3], time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
								vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
							end)
						end

						return true
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.wantedTimer(user_id,900)

		for k,v in pairs(robberys[robberyId]["payment"]) do
			local value = math.random(v[2],v[3])
			vRP.generateItem(user_id,v[1],parseInt(value),true)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.inputRobberys(source,robberys)
end)