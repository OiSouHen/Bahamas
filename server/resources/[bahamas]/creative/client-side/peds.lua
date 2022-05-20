-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local localPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local pedList = {
	{ -- AirForce
		distance = 50,
		coords = { -940.79,-2960.2,13.93,59.53 },
		model = { 0x3AE4A33B,"ig_fbisuit_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Weapons
		distance = 10,
		coords = { 840.77,-2885.63,11.44,269.3 },
		model = { 0xB9DD0300,"g_m_m_chiboss_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ballas
		distance = 10,
		coords = { 106.37,-1993.93,14.88,164.41 },
		model = { 0xE52E126C,"ig_ramp_gang" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Vagos
		distance = 10,
		coords = { 426.4,-2052.29,18.74,323.15 },
		model = { 0xE52E126C,"ig_ramp_gang" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- DaNang
		distance = 10,
		coords = { 228.49,-1755.92,25.24,48.19 },
		model = { 0xE52E126C,"ig_ramp_gang" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Families
		distance = 10,
		coords = { -196.56,-1700.45,29.39,130.4 },
		model = { 0xE52E126C,"ig_ramp_gang" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Aztecas
		distance = 10,
		coords = { 468.74,-1742.5,25.54,249.45 },
		model = { 0xE52E126C,"ig_ramp_gang" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Crips
		distance = 10,
		coords = { -1120.62,-1555.22,0.98,308.98 },
		model = { 0xE52E126C,"ig_ramp_gang" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 24.49,-1346.08,29.49,272.13 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 2556.04,380.89,108.61,0.0 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1164.82,-323.63,69.2,99.22 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -706.16,-914.55,19.21,90.71 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -47.39,-1758.63,29.42,51.03 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 372.86,327.53,103.56,257.96 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { -3243.38,1000.11,12.82,0.0 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1728.39,6416.21,35.03,246.62 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 549.2,2670.22,42.16,96.38 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1959.54,3741.01,32.33,303.31 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 2677.07,3279.95,55.23,334.49 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1697.35,4923.46,42.06,328.82 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { -1819.55,793.51,138.08,133.23 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1392.03,3606.1,34.98,204.1 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -2966.41,391.59,15.05,85.04 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -3040.04,584.22,7.9,19.85 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1134.33,-983.09,46.4,277.8 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1165.26,2710.79,38.15,178.59 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -1486.77,-377.56,40.15,133.23 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -1221.42,-907.91,12.32,31.19 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 1692.28,3760.94,34.69,229.61 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 253.79,-50.5,69.94,68.04 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 842.41,-1035.28,28.19,0.0 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -331.62,6084.93,31.46,226.78 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -662.29,-933.62,21.82,181.42 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -1304.17,-394.62,36.7,73.71 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -1118.95,2699.73,18.55,223.94 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 2567.98,292.65,108.73,0.0 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -3173.51,1088.38,20.84,249.45 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 22.59,-1105.54,29.79,155.91 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 810.22,-2158.99,29.62,0.0 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Premium Store
		distance = 20,
		coords = { -1083.15,-245.88,37.76,209.77 },
		model = { 0x2F8845A3,"ig_barry" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 30,
		coords = { -171.53,6386.55,31.49,133.23 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 30,
		coords = { 1690.07,3581.68,35.62,212.6 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 15,
		coords = { 326.5,-1074.43,29.47,0.0 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 15,
		coords = { 114.39,-4.85,67.82,204.1 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central
		distance = 30,
		coords = { 46.67,-1749.79,29.62,48.19 },
		model = { 0xE6631195,"ig_cletus" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central
		distance = 30,
		coords = { 2747.29,3473.06,55.67,252.29 },
		model = { 0xE6631195,"ig_cletus" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling Sell
		distance = 15,
		coords = { -428.54,-1728.29,19.78,70.87 },
		model = { 0xEE75A00F,"s_m_y_garbage" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Bar
		distance = 15,
		coords = { 129.71,-1284.65,29.27,119.06 },
		model = { 0x780C01BD,"s_f_y_bartender_01" },
		anim = { "amb@prop_human_bum_shopping_cart@male@base","base" }
	},
	{ -- Bar
		distance = 15,
		coords = { -561.75,286.7,82.18,266.46 },
		model = { 0xE11A9FB4,"ig_josef" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Jewelry
		distance = 15,
		coords = { -622.25,-229.95,38.05,308.98 },
		model = { 0xC314F727,"cs_gurk" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Oxy Store
		distance = 30,
		coords = { -1636.74,-1092.17,13.08,320.32 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Moto Club
		distance = 12,
		coords = { 987.46,-95.61,74.85,226.78 },
		model = { 0x6CCFE08A,"ig_clay" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Transportador
		distance = 30,
		coords = { 354.14,270.56,103.02,345.83 },
		model = { 0xE0FA2554,"ig_casey" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lenhador
		distance = 30,
		coords = { -840.64,5398.94,34.61,303.31 },
		model = { 0x1536D95A,"a_m_o_ktown_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lenhador
		distance = 30,
		coords = { -842.92,5403.49,34.61,300.48 },
		model = { 0x1C95CB0B,"u_m_m_markfost" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Minerador
		distance = 30,
		coords = { 2832.97,2797.6,57.46,99.22 },
		model = { 0xD7DA9E99,"s_m_y_construct_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mergulhador
		distance = 30,
		coords = { 2768.92,1391.19,24.53,82.21 },
		model = { 0xC79F6928,"a_f_y_beach_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Colheita
		distance = 30,
		coords = { 406.08,6526.17,27.75,87.88 },
		model = { 0x94562DD7,"a_m_m_farmer_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Motorista
		distance = 30,
		coords = { 452.97,-607.75,28.59,266.46 },
		model = { 0x2A797197,"u_m_m_edtoh" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lixeiro
		distance = 50,
		coords = { 82.98,-1553.55,29.59,51.03 },
		model = { 0xEE75A00F,"s_m_y_garbage" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 73.96,-1393.01,29.37,274.97 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -709.23,-151.35,37.41,119.06 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -165.08,-303.46,39.73,249.45 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -823.12,-1072.36,11.32,209.77 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -1194.6,-767.56,17.3,215.44 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -1448.61,-237.61,49.81,51.03 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 5.82,6511.47,31.88,42.52 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 1695.3,4823.0,42.06,93.55 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 127.23,-223.39,54.56,65.2 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 613.09,2761.8,42.09,274.97 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 1196.64,2711.62,38.22,181.42 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -3169.1,1044.04,20.86,65.2 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { -1102.41,2711.57,19.11,221.11 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 426.97,-806.17,29.49,87.88 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 73.96,-1393.01,29.37,274.97 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { 1324.38,-1650.09,52.27,127.56 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { -1152.27,-1423.81,4.95,124.73 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { 319.84,180.89,103.58,246.62 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { -3170.41,1073.06,20.83,334.49 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { 1862.58,3748.52,33.03,28.35 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { -292.02,6199.72,31.49,223.94 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caminhoneiro
		distance = 30,
		coords = { 1239.87,-3257.2,7.09,274.97 },
		model = { 0x59511A6C,"s_m_m_trucker_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Restocador
		distance = 30,
		coords = { 920.04,-1256.84,25.51,36.86 },
		model = { 0x59511A6C,"s_m_m_trucker_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Taxista
		distance = 30,
		coords = { 894.9,-179.15,74.7,240.95 },
		model = { 0x24604B2B,"u_m_y_chip" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Minerador
		distance = 30,
		coords = { -594.77,2090.0,131.65,19.85 },
		model = { 0xB1B196B2,"ig_floyd" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caçador
		distance = 10,
		coords = { -679.13,5839.52,17.32,226.78 },
		model = { 0xCE1324DE,"ig_hunter" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caçador
		distance = 30,
		coords = { -695.56,5802.12,17.32,65.2 },
		model = { 0x1536D95A,"a_m_o_ktown_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Animal Park
		distance = 15,
		coords = { 563.19,2752.92,42.87,187.09 },
		model = { 0x51C03FA4,"a_f_y_eastsa_03" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Animal Park
		distance = 50,
		coords = { -1816.76,-1193.97,14.31,334.49 },
		model = { 0x51C03FA4,"a_f_y_eastsa_03" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja do Mergulhador
		distance = 50,
		coords = { -815.31,-1346.84,5.14,51.03 },
		model = { 0x4A8E5536,"s_f_y_baywatch_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1112.46,228.33,-49.64,147.41 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1117.62,221.35,-49.44,65.2 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1117.24,220.07,-49.44,87.88 },
		model = { 0x1422D45B,"s_m_y_casino_01" },
		anim = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
		casino = "male"
	},
	{ -- Casino
		distance = 30,
		coords = { 1117.59,218.72,-49.44,107.72 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1111.85,209.98,-49.44,0.0 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1110.24,207.1,-49.44,127.56 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1113.6,207.06,-49.44,243.78 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" },
		casino = "female"
	},
	{ -- Casino - Loja de Roupas
		distance = 45,
		coords = { 1100.7,195.55,-49.44,317.49 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1103.13,223.72,-49.0,323.15 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1096.98,216.23,-49.0,138.9 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 934.87,48.02,81.1,147.41 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 937.17,46.49,81.1,144.57 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1087.14,221.11,-49.2,181.42 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@heists@prison_heiststation@cop_reactions","cop_b_idle" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1088.6,221.11,-49.2,147.41 },
		model = { 0x1422D45B,"s_m_y_casino_01" },
		anim = { "anim@heists@prison_heiststation@cop_reactions","cop_b_idle" },
		casino = "male"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(pedList) do
			local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
			if distance <= v["distance"] then
				if not IsPedInAnyVehicle(ped) then
					if localPeds[k] == nil then
						local mHash = GetHashKey(v["model"][2])

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							Wait(1)
						end

						if HasModelLoaded(mHash) then
							localPeds[k] = CreatePed(4,v["model"][1],v["coords"][1],v["coords"][2],v["coords"][3] - 1,v["coords"][4],false,true)
							SetPedArmour(localPeds[k],100)
							SetEntityInvincible(localPeds[k],true)
							FreezeEntityPosition(localPeds[k],true)
							SetBlockingOfNonTemporaryEvents(localPeds[k],true)

							if v["casino"] then
								if v["casino"] == "male" then
									SetPedDefaultComponentVariation(localPeds[k])
									SetPedComponentVariation(localPeds[k],0,3,0,0)
									SetPedComponentVariation(localPeds[k],1,1,0,0)
									SetPedComponentVariation(localPeds[k],2,3,0,0)
									SetPedComponentVariation(localPeds[k],3,1,0,0)
									SetPedComponentVariation(localPeds[k],4,0,0,0)
									SetPedComponentVariation(localPeds[k],6,1,0,0)
									SetPedComponentVariation(localPeds[k],7,2,0,0)
									SetPedComponentVariation(localPeds[k],8,3,0,0)
									SetPedComponentVariation(localPeds[k],10,1,0,0)
									SetPedComponentVariation(localPeds[k],11,1,0,0)
								elseif v["casino"] == "female" then
									SetPedDefaultComponentVariation(localPeds[k])
									SetPedComponentVariation(localPeds[k],0,3,0,0)
									SetPedComponentVariation(localPeds[k],1,0,0,0)
									SetPedComponentVariation(localPeds[k],2,3,0,0)
									SetPedComponentVariation(localPeds[k],3,0,1,0)
									SetPedComponentVariation(localPeds[k],4,1,0,0)
									SetPedComponentVariation(localPeds[k],6,1,0,0)
									SetPedComponentVariation(localPeds[k],7,1,0,0)
									SetPedComponentVariation(localPeds[k],8,0,0,0)
									SetPedComponentVariation(localPeds[k],10,0,0,0)
									SetPedComponentVariation(localPeds[k],11,0,0,0)
									SetPedPropIndex(localPeds[k],1,0,0,false)
								end
							end

							SetModelAsNoLongerNeeded(mHash)

							if v["anim"][1] ~= nil then
								if v["anim"][1] == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
									TaskStartScenarioAtPosition(localPeds[k],"PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",v["coords"][1],v["coords"][2],v["coords"][3],v["coords"][4],-1,1,false)
								else
									RequestAnimDict(v["anim"][1])
									while not HasAnimDictLoaded(v["anim"][1]) do
										Wait(1)
									end

									TaskPlayAnim(localPeds[k],v["anim"][1],v["anim"][2],8.0,0.0,-1,1,0,0,0,0)
								end
							end
						end
					end
				end
			else
				if localPeds[k] then
					DeleteEntity(localPeds[k])
					localPeds[k] = nil
				end
			end
		end

		Wait(1000)
	end
end)