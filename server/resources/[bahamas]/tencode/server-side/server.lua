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
Tunnel.bindInterface("tencode",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local codes = {
	[1] = {
		tag = "QTI",
		text = "Deslocamento",
		blip = 77
	},
	[2] = {
		tag = "QTH",
		text = "Localização",
		blip = 1
	},
	[3] = {
		tag = "QRR",
		text = "Reforço solicitado",
		blip = 38
	},
	[4] = {
		tag = "QRT",
		text = "Oficial ferido",
		blip = 6
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDCODE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.sendCode(code)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		local identity = vRP.userIdentity(user_id)

		local policeResult = vRP.numPermission("Police")
		for k,v in pairs(policeResult) do
			async(function()
				if code ~= "4" then
					vRPC.playSound(v,"Event_Start_Text","GTAO_FM_Events_Soundset")
				end

				TriggerClientEvent("NotifyPush",v,{ code = codes[parseInt(code)]["tag"], title = codes[parseInt(code)]["text"], x = coords["x"], y = coords["y"], z = coords["z"], name = identity["name"].." "..identity["name2"], time = "Recebido às "..os.date("%H:%M"), blipColor = codes[parseInt(code)]["blip"] })
			end)
		end
	end
end