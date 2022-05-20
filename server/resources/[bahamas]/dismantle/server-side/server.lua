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
Tunnel.bindInterface("dismantle",cRP)
vGARAGE = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeList = 1
local vehListActived = {}
local modelListVehicles = {}
local itensList = { "plastic","glass","rubber","aluminum","copper" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local vehList = {
	"bison",
	"journey",
	"regina",
	"dominator",
	"alpha",
	"mule",
	"gauntlet",
	"prairie",
	"glendale",
	"schwarzer",
	"feltzer2",
	"fq2",
	"baller",
	"asea",
	"rancherxl",
	"dubsta",
	"pigalle",
	"premier",
	"youga",
	"panto",
	"bus",
	"cavalcade",
	"cavalcade2",
	"dilettante",
	"tornado",
	"tornado2",
	"tornado3",
	"huntley",
	"asterope",
	"buffalo",
	"blista",
	"taco",
	"trash",
	"utillitruck",
	"utillitruck2",
	"utillitruck3",
	"picador",
	"emperor",
	"oracle",
	"oracle2",
	"hauler",
	"zion2",
	"coach",
	"burrito",
	"burrito3",
	"pony",
	"speedo",
	"bulldozer",
	"warrener",
	"bobcatxl",
	"patriot",
	"bjxl",
	"rapidgt2",
	"banshee",
	"serrano",
	"tiptruck",
	"tiptruck2",
	"baller2",
	"sentinel",
	"bfinjection",
	"sadler",
	"surfer",
	"surfer2",
	"mesa",
	"gresley",
	"stratum",
	"landstalker",
	"forklift",
	"minivan",
	"radi",
	"felon",
	"washington",
	"tractor2",
	"firetruk",
	"habanero",
	"furoregt",
	"massacro",
	"rapidgt",
	"f620",
	"dukes",
	"coquette",
	"jester",
	"bullet",
	"sultan",
	"futo",
	"fugitive",
	"fusilade",
	"issi2",
	"granger",
	"peyote",
	"penumbra",
	"ruiner",
	"rumpo",
	"sabregt",
	"seminole",
	"carbonizzare",
	"jackal",
	"ninef",
	"ninef2",
	"comet2",
	"exemplar",
	"rocoto",
	"superd",
	"schafter2",
	"sentinel2",
	"voltic",
	"benson",
	"flatbed",
	"mixer",
	"mixer2",
	"packer",
	"thrust",
	"faggio",
	"faggio2",
	"faggio3",
	"biff",
	"phantom",
	"pounder",
	"rubble",
	"scrap",
	"camper",
	"towtruck",
	"towtruck2",
	"stalion",
	"stanier",
	"surge"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if timeList > 0 then
			timeList = timeList - 1

			if timeList <= 0 then
				timeList = 60
				vehListActived = {}
				local amountVehs = 0
				local vehSelected = 0
				modelListVehicles = {}

				repeat
					vehSelected = math.random(#vehList)
					if vehListActived[vehList[vehSelected]] == nil then
						table.insert(modelListVehicles,GetHashKey(vehList[vehSelected]))
						vehListActived[vehList[vehSelected]] = true
						amountVehs = amountVehs + 1
					end
				until amountVehs >= 15

				TriggerClientEvent("target:dismantleList",-1,modelListVehicles)
			end
		end

		Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeList(vehPlate,vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local plateUser = vRP.userPlate(vehPlate)
		if not plateUser then
			if vehListActived[vehName] then
				TriggerClientEvent("target:dismantleClear",-1,GetHashKey(vehName))
				vehListActived[vehName] = nil
				return true
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Veículo é protegido pela seguradora.",1000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod(vehicle)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,10)
		vGARAGE.deleteVehicle(source,vehicle)
		TriggerClientEvent("player:applyGsr",source)
		vRP.generateItem(user_id,"dollarsz",math.random(625,725),true)
		vRP.generateItem(user_id,itensList[math.random(#itensList)],math.random(35,45),true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:INVOKELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dismantle:invokeList")
AddEventHandler("dismantle:invokeList",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and timeList > 0 then
		local vehListNames = ""
		for k,v in pairs(vehListActived) do
			vehListNames = vehListNames.."<b>"..vehicleName(k).."</b>, "
		end

		if vehListNames ~= "" then
			TriggerClientEvent("Notify",source,"azul",vehListNames.." a lista é atualizada em <b>"..parseInt(timeList).." minutos</b>, cada veículo entregue é removido da lista.",60000)
		else
			TriggerClientEvent("Notify",source,"amarelo","Nenhum veículo encontrado na lista, aguarde <b>"..parseInt(timeList).." minutos</b>, até que esteja cheio de veículos novos.",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("target:dismantleList",source,modelListVehicles)
end)