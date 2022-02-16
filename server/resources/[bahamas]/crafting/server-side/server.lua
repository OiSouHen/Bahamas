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
Tunnel.bindInterface("crafting",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local craftList = {
	["dirtyMoneys"] = {
		["list"] = {
			["dollars"] = {
				["amount"] = 1000,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 2000
				}
			}
		}
	},
	["lixeiroShop"] = {
		["list"] = {
			["glass"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["glassbottle"] = 1
				}
			},
			["plastic"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["plasticbottle"] = 1
				}
			},
			["rubber"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["elastic"] = 1
				}
			},
			["aluminum"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["metalcan"] = 1
				}
			},
			["copper"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["battery"] = 1
				}
			}
		}
	},
	["fuelShop"] = {
		["list"] = {
			["WEAPON_PETROLCAN"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 50
				}
			},
			["WEAPON_PETROLCAN_AMMO"] = {
				["amount"] = 4500,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 200
				}
			}
		}
	},
	["dressMaker"] = {
		["list"] = {
			["backpack"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["fabric"] = 25
				}
			},
			["fabric"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["animalpelt"] = 4,
					["rubber"] = 3
				}
			}
		}
	},
	["makeFoods"] = {
		["list"] = {
			["hamburger2"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatA"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["hamburger3"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatB"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["hamburger4"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatC"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["hamburger5"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatS"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["orangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["orange"] = 9
				}
			},
			["tangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["tange"] = 9
				}
			},
			["grapejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["grape"] = 9
				}
			},
			["strawberryjuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["strawberry"] = 9
				}
			},
			["bananajuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["banana"] = 9
				}
			},
			["passionjuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["passion"] = 9
				}
			},
			["ketchup"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["emptybottle"] = 1,
					["tomato"] = 6
				}
			}
		}
	},
	["Fleeca"] = {
		["perm"] = "Fleeca",
		["list"] = {
			["dollars"] = {
				["amount"] = 1700,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 2000
				}
			}
		}
	},
	["Triads"] = {
		["perm"] = "Triads",
		["list"] = {
			["TOKEN_WEAPON_PISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_APPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 55,
					["copper"] = 55,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35
				}
			},
			["TOKEN_WEAPON_MACHINEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 55,
					["copper"] = 55,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35
				}
			},
			["TOKEN_WEAPON_MICROSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SNSPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 35,
					["copper"] = 35,
					["plastic"] = 15,
					["glass"] = 15,
					["rubber"] = 15
				}
			},
			["TOKEN_WEAPON_PISTOL50"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 75,
					["copper"] = 75,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_MINISMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_PISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_SNSPISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_REVOLVER"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35
				}
			},
			["TOKEN_WEAPON_VINTAGEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 25,
					["copper"] = 25,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			}
		}
	},
	["EastSide"] = {
		["perm"] = "EastSide",
		["list"] = {
			["TOKEN_WEAPON_PISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_APPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 55,
					["copper"] = 55,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35
				}
			},
			["TOKEN_WEAPON_MACHINEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 55,
					["copper"] = 55,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35
				}
			},
			["TOKEN_WEAPON_MICROSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SNSPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 35,
					["copper"] = 35,
					["plastic"] = 15,
					["glass"] = 15,
					["rubber"] = 15
				}
			},
			["TOKEN_WEAPON_PISTOL50"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 75,
					["copper"] = 75,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_MINISMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_PISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_SNSPISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			},
			["TOKEN_WEAPON_REVOLVER"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 45,
					["copper"] = 45,
					["plastic"] = 35,
					["glass"] = 35,
					["rubber"] = 35
				}
			},
			["TOKEN_WEAPON_VINTAGEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 25,
					["copper"] = 25,
					["plastic"] = 25,
					["glass"] = 25,
					["rubber"] = 25
				}
			}
		}
	},
	["Marabunta"] = {
		["perm"] = "Marabunta",
		["list"] = {
			["TOKEN_WEAPON_COMPACTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ADVANCEDRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_BULLPUPRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_BULLPUPRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SPECIALCARBINE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_PUMPSHOTGUN_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 175,
					["copper"] = 175,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SAWNOFFSHOTGUN"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 125,
					["copper"] = 125,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SMG_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ASSAULTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ASSAULTSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_GUSENBERG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			}
		}
	},
	["Rednecks"] = {
		["perm"] = "Rednecks",
		["list"] = {
			["TOKEN_WEAPON_COMPACTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ADVANCEDRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_BULLPUPRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_BULLPUPRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SPECIALCARBINE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_PUMPSHOTGUN_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 175,
					["copper"] = 175,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SAWNOFFSHOTGUN"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 125,
					["copper"] = 125,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_SMG_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ASSAULTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 200,
					["copper"] = 200,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 225,
					["copper"] = 225,
					["plastic"] = 125,
					["glass"] = 125,
					["rubber"] = 125,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_ASSAULTSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			},
			["TOKEN_WEAPON_GUSENBERG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 150,
					["copper"] = 150,
					["plastic"] = 75,
					["glass"] = 75,
					["rubber"] = 75,
					["titanium"] = 1
				}
			}
		}
	},
	["Ballas"] = {
		["perm"] = "Ballas",
		["list"] = {
			["c4"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["plastic"] = 2,
					["glass"] = 2,
					["rubber"] = 2
				}
			},
			["meth"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["cocaine"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["handcuff"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 100,
					["copper"] = 50,
					["fabric"] = 5
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 250
				}
			},
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1,
					["rubber"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 3,
					["glass"] = 1
				}
			}
		}
	},
	["Vagos"] = {
		["perm"] = "Vagos",
		["list"] = {
			["c4"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["plastic"] = 2,
					["glass"] = 2,
					["rubber"] = 2
				}
			},
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 10,
					["copper"] = 10,
					["plastic"] = 7,
					["glass"] = 7,
					["rubber"] = 7
				}
			},
			["lean"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["cocaine"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 250
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1,
					["glass"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 3,
					["glass"] = 1
				}
			}
		}
	},
	["Families"] = {
		["perm"] = "Families",
		["list"] = {
			["c4"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2,
					["copper"] = 2,
					["plastic"] = 2,
					["glass"] = 2,
					["rubber"] = 2
				}
			},
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 10,
					["copper"] = 10,
					["plastic"] = 7,
					["glass"] = 7,
					["rubber"] = 7
				}
			},
			["joint"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["ecstasy"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 250
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1,
					["plastic"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 3,
					["glass"] = 1
				}
			}
		}
	},
	["DaNang"] = {
		["perm"] = "DaNang",
		["list"] = {
			["hood"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 100,
					["plastic"] = 75,
					["fabric"] = 5
				}
			},
			["meth"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["joint"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 250
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1,
					["plastic"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 3,
					["glass"] = 1
				}
			}
		}
	},
	["Aztecas"] = {
		["perm"] = "Aztecas",
		["list"] = {
			["vest"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 10,
					["copper"] = 10,
					["plastic"] = 7,
					["glass"] = 7,
					["rubber"] = 7
				}
			},
			["lean"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["ecstasy"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 250
				}
			},
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1,
					["rubber"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 3,
					["glass"] = 1
				}
			}
		}
	},
	["Crips"] = {
		["perm"] = "Crips",
		["list"] = {
			["hood"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 100,
					["plastic"] = 75,
					["fabric"] = 5
				}
			},
			["meth"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["joint"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["wheatflour"] = 1
				}
			},
			["credential"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 250
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 1,
					["glass"] = 1
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 3,
					["glass"] = 1
				}
			}
		}
	},
	["ilegalWeapons"] = {
		["list"] = {
			["WEAPON_PISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_PISTOL"] = 1
				}
			},
			["WEAPON_APPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_APPISTOL"] = 1
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_MACHINEPISTOL"] = 1
				}
			},
			["WEAPON_MICROSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_MICROSMG"] = 1
				}
			},
			["WEAPON_SNSPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_SNSPISTOL"] = 1
				}
			},
			["WEAPON_PISTOL50"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_PISTOL50"] = 1
				}
			},
			["WEAPON_MINISMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_MINISMG"] = 1
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_PISTOL_MK2"] = 1
				}
			},
			["WEAPON_SNSPISTOL_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_SNSPISTOL_MK2"] = 1
				}
			},
			["WEAPON_REVOLVER"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_REVOLVER"] = 1
				}
			},
			["WEAPON_VINTAGEPISTOL"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_VINTAGEPISTOL"] = 1
				}
			},
			["WEAPON_COMPACTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_COMPACTRIFLE"] = 1
				}
			},
			["WEAPON_ADVANCEDRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_ADVANCEDRIFLE"] = 1
				}
			},
			["WEAPON_BULLPUPRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_BULLPUPRIFLE"] = 1
				}
			},
			["WEAPON_BULLPUPRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_BULLPUPRIFLE_MK2"] = 1
				}
			},
			["WEAPON_SPECIALCARBINE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_SPECIALCARBINE"] = 1
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_SPECIALCARBINE_MK2"] = 1
				}
			},
			["WEAPON_PUMPSHOTGUN_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_PUMPSHOTGUN_MK2"] = 1
				}
			},
			["WEAPON_SAWNOFFSHOTGUN"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_SAWNOFFSHOTGUN"] = 1
				}
			},
			["WEAPON_SMG_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_SMG_MK2"] = 1
				}
			},
			["WEAPON_ASSAULTRIFLE"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_ASSAULTRIFLE"] = 1
				}
			},
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_ASSAULTRIFLE_MK2"] = 1
				}
			},
			["WEAPON_ASSAULTSMG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_ASSAULTSMG"] = 1
				}
			},
			["WEAPON_GUSENBERG"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["TOKEN_WEAPON_GUSENBERG"] = 1
				}
			}
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"vermelho","Multas pendentes encontradas.",3000)
			return false
		end

		if vRP.wantedReturn(user_id) then
			return false
		end

		if craftList[craftType]["perm"] ~= nil then
			if not vRP.hasPermission(user_id,craftList[craftType]["perm"]) then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestCrafting(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(craftList[craftType]["list"]) do
			local craftList = {}
			for k,v in pairs(v["require"]) do
				table.insert(craftList,{ name = itemName(k), amount = v })
			end

			table.insert(inventoryShop,{ name = itemName(k), index = itemIndex(k), key = k, peso = itemWeight(k), list = craftList, amount = parseInt(v["amount"]), desc = itemDescription(k) })
		end

		local inventoryUser = {}
		local inventory = vRP.userInventory(user_id)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				v["durability"] = parseInt(os.time() - splitName[2])
				v["days"] = itemDurability(v["item"])
				v["serial"] = splitName[3]
			else
				v["durability"] = 0
				v["days"] = 1
			end

			inventoryUser[k] = v
		end

		return inventoryShop,inventoryUser,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionCrafting(shopItem,shopType,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consumePendrive = ""
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		if shopType == "dirtyMoneys" then
			local consultItem = vRP.getInventoryItemAmount(user_id,"pendrive")
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Pendrive não encontrado.",5000)
				return
			end

			if vRP.checkBroken(consultItem[2]) then
				TriggerClientEvent("Notify",source,"vermelho","Pendrive quebrado.",5000)
				return
			end

			consumePendrive = consultItem[2]
		end

		if craftList[shopType]["list"][shopItem] then
			if vRP.checkMaxItens(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount) then
				TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
				TriggerClientEvent("crafting:Update",source,"requestCrafting")
				return
			end

			if (vRP.inventoryWeight(user_id) + (itemWeight(shopItem) * parseInt(shopAmount))) <= vRP.getBackpack(user_id) then
				for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
					local consultItem = vRP.getInventoryItemAmount(user_id,k)
					if consultItem[1] < parseInt(v * shopAmount) then
						return
					end

					if vRP.checkBroken(consultItem[2]) then
						TriggerClientEvent("Notify",source,"vermelho","Item quebrado.",5000)
						return
					end
				end

				for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
					local consultItem = vRP.getInventoryItemAmount(user_id,k)
					vRP.removeInventoryItem(user_id,consultItem[2],parseInt(v * shopAmount))
				end

				vRP.generateItem(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount,false,slot)

				if shopType == "dirtyMoneys" then
					vRP.removeInventoryItem(user_id,consumePendrive,1,true)
				end
			end
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionDestroy(shopItem,shopType,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end
		local splitName = splitString(shopItem,"-")

		if craftList[shopType]["list"][splitName[1]] then
			if craftList[shopType]["list"][splitName[1]]["destroy"] then
				if vRP.checkBroken(shopItem) then
					TriggerClientEvent("Notify",source,"vermelho","Itens quebrados reciclados.",5000)
					TriggerClientEvent("crafting:Update",source,"requestCrafting")
					return
				end

				if vRP.tryGetInventoryItem(user_id,shopItem,craftList[shopType]["list"][splitName[1]]["amount"]) then
					for k,v in pairs(craftList[shopType]["list"][splitName[1]]["require"]) do
						if parseInt(v) <= 1 then
							vRP.generateItem(user_id,k,1)
						else
							vRP.generateItem(user_id,k,v / 2)
						end
					end
				end
			end
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:populateSlot")
AddEventHandler("crafting:populateSlot",function(nameItem,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
			vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			TriggerClientEvent("crafting:Update",source,"requestCrafting")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:updateSlot")
AddEventHandler("crafting:updateSlot",function(nameItem,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inventory = vRP.userInventory(user_id)
		if inventory[tostring(slot)] and inventory[tostring(target)] and inventory[tostring(slot)]["item"] == inventory[tostring(target)]["item"] then
			if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
				vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			end
		else
			vRP.swapSlot(user_id,slot,target)
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
end)