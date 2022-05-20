local Tunnel = module("vrp","lib/Tunnel")
vINVENTORY = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local object = nil
local point = false
local animDict = nil
local animName = nil
local crouch = false
local celular = false
local cancelando = false
local animActived = false
local casinoActive = false
local cdBtns = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CASINOACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("casinoActive")
AddEventHandler("casinoActive",function(status)
	casinoActive = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUS:CELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	celular = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cancelando")
AddEventHandler("cancelando",function(status)
	cancelando = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if cancelando then
			timeDistance = 1
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,38,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,137,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if celular or animActived or casinoActive then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.request(id,text,time)
	SendNUIMessage({ act = "request", id = id, text = tostring(text), time = time })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUIPROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("prompt",function(data,cb)
	if data["act"] == "close" then
		SetNuiFocus(false,false)
		vRPS.promptResult(data["result"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.prompt(title,default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("request",function(data,cb)
	if data["act"] == "response" then
		vRPS.requestResult(data["id"],data["ok"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIMSET
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.loadAnimSet(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.createObjects(dict,anim,prop,flag,mao,altura,pos1,pos2,pos3,pos4,pos5)
	if DoesEntityExist(object) then
		TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(object))
		object = nil
	end

	local ped = PlayerPedId()
	local mHash = GetHashKey(prop)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	if HasModelLoaded(mHash) then
		if anim ~= "" then
			tvRP.loadAnimSet(dict)
			TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
		end

		if altura then
			local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
			object = CreateObject(mHash,coords["x"],coords["y"],coords["z"],true,true,false)
			AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,mao),altura,pos1,pos2,pos3,pos4,pos5,true,true,false,true,1,true)
		else
			local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
			object = CreateObject(mHash,coords["x"],coords["y"],coords["z"],true,true,false)
			AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,mao),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		end

		SetEntityAsMissionEntity(object,true,true)
		SetEntityAsNoLongerNeeded(object)
		SetModelAsNoLongerNeeded(mHash)

		animActived = true
		animFlags = flag
		animDict = dict
		animName = anim
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if animActived then
			if not IsEntityPlayingAnim(ped,animDict,animName,3) then
				TaskPlayAnim(ped,animDict,animName,3.0,3.0,-1,animFlags,0,0,0,0)
				timeDistance = 1
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeObjects(status)
	if status == "one" then
		tvRP.stopAnim(true)
	elseif status == "two" then
		tvRP.stopAnim(false)
	else
		tvRP.stopAnim(true)
		tvRP.stopAnim(false)
	end

	animActived = false
	TriggerEvent("camera")
	TriggerEvent("binoculos")
	if DoesEntityExist(object) then
		TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(object))
		object = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local blockDrunk = false
RegisterNetEvent("vrp:blockDrunk")
AddEventHandler("vrp:blockDrunk",function(status)
	blockDrunk = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 100
		if point then
			timeDistance = 1
			local ped = PlayerPedId()
			local camPitch = GetGameplayCamRelativePitch()

			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local nn = 0
			local blocked = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped,(cosCamHeading*-0.2)-(sinCamHeading*(0.4*camHeading+0.3)),(sinCamHeading*-0.2)+(cosCamHeading*(0.4*camHeading+0.3)),0.6)
			local ray = Cast_3dRayPointToPoint(coords["x"],coords["y"],coords["z"]-0.2,coords.x,coords.y,coords.z+0.2,0.4,95,ped,7);
			nn,blocked,coords,coords = GetRaycastResult(ray)

			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Pitch",camPitch)
			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Heading",camHeading * -1.0 + 1.0)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isBlocked",blocked)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isFirstPerson",Citizen.InvokeNative(0xEE778F8C7E1142E2,Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		DisableControlAction(1,37,false)
		DisableControlAction(1,99,false)
		DisableControlAction(1,100,false)
		DisableControlAction(1,157,false)
		DisableControlAction(1,158,false)
		DisableControlAction(1,160,false)
		DisableControlAction(1,164,false)
		DisableControlAction(1,165,false)
		DisableControlAction(1,159,false)
		DisableControlAction(1,161,false)
		DisableControlAction(1,162,false)
		DisableControlAction(1,163,false)
		DisableControlAction(1,261,false)
		DisableControlAction(1,262,false)
		DisableControlAction(1,204,false)
		DisableControlAction(1,211,false)
		DisableControlAction(1,349,false)
		DisableControlAction(1,192,false)

		Wait(4)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELF6
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRcancelf6",function(source,args)
	if GetGameTimer() >= cdBtns then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not casinoActive and GetEntityHealth(ped) > 101 and not celular and not cancelando then
			TriggerServerEvent("inventory:Cancel")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDSUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRhandsup",function(source,args)
	local ped = PlayerPedId()
	if not IsPauseMenuActive() and not exports["inventory"]:blockInvents() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not IsPedInAnyVehicle(ped) and not celular and GetEntityHealth(ped) > 101 and not cancelando then
		if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
			StopAnimTask(ped,"random@mugging3","handsup_standing_base",2.0)
			tvRP.stopActived()
		else
			tvRP.playAnim(true,{"random@mugging3","handsup_standing_base"},true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRpoint",function(source,args)
	local ped = PlayerPedId()
	if not IsPauseMenuActive() and not exports["inventory"]:blockInvents() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not casinoActive and not cancelando and not celular and not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 then
		tvRP.loadAnimSet("anim@mp_point")

		if not point then
			tvRP.stopActived()
			SetPedConfigFlag(ped,36,1)
			TaskMoveNetwork(ped,"task_mp_pointing",0.5,0,"anim@mp_point",24)
			point = true
		else
			Citizen.InvokeNative(0xD01015C7316AE176,ped,"Stop")
			if not IsPedInjured(ped) then
				ClearPedSecondaryTask(ped)
			end

			SetPedConfigFlag(ped,36,0)
			ClearPedSecondaryTask(ped)
			point = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGARVEH / AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRenginecrouch",function(source,args)
	if GetGameTimer() >= cdBtns then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not exports["inventory"]:blockInvents() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not casinoActive and not celular and GetEntityHealth(ped) > 101 and not cancelando then
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				if GetPedInVehicleSeat(vehicle,-1) == ped then
					tvRP.removeObjects("two")

					local running = GetIsVehicleEngineRunning(vehicle)
					SetVehicleEngineOn(vehicle,not running,true,true)
					if running then
						SetVehicleUndriveable(vehicle,true)
					else
						SetVehicleUndriveable(vehicle,false)
					end
				end
			elseif not blockDrunk then
				RequestAnimSet("move_ped_crouched")
				while not HasAnimSetLoaded("move_ped_crouched") do
					Wait(1)
				end

				if crouch then
					ResetPedMovementClipset(ped,0.25)
					crouch = false
				else
					SetPedMovementClipset(ped,"move_ped_crouched",0.25)
					crouch = true
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRbind",function(source,args)
	if GetGameTimer() >= cdBtns then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not exports["inventory"]:blockInvents() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not casinoActive and not celular and GetEntityHealth(ped) > 101 and not cancelando then
			if parseInt(args[1]) >= 1 and parseInt(args[1]) <= 5 then
				vINVENTORY.useItem(args[1])
			elseif args[1] == "6" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",3) then
						StopAnimTask(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",2.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"anim@heists@heist_corona@single_team","single_team_loop_boss"},true)
					end
				end
			elseif args[1] == "7" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"mini@strip_club@idles@bouncer@base","base",3) then
						StopAnimTask(ped,"mini@strip_club@idles@bouncer@base","base",2.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"mini@strip_club@idles@bouncer@base","base"},true)
					end
				end
			elseif args[1] == "8" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
						StopAnimTask(ped,"anim@mp_player_intupperfinger","idle_a_fp",2.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"anim@mp_player_intupperfinger","idle_a_fp"},true)
					end
				end
			elseif args[1] == "9" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
						StopAnimTask(ped,"random@arrests@busted","idle_a",2.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"random@arrests@busted","idle_a"},true)
					end
				end
			elseif args[1] == "left" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intupperthumbs_up","enter"},false)
				end
			elseif args[1] == "right" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intcelebrationmale@face_palm","face_palm"},false)
				end
			elseif args[1] == "up" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intcelebrationmale@salute","salute"},false)
				end
			elseif args[1] == "down" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"rcmnigel1c","hailing_whistle_waive_a"},false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCEPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRaccept",function(source,args)
	SendNUIMessage({ act = "event", event = "Y" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRreject",function(source,args)
	SendNUIMessage({ act = "event", event = "U" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lockVehicles",function(source,args)
	if GetGameTimer() >= cdBtns then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not exports["inventory"]:blockInvents() and not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not casinoActive and not IsPedSwimming(ped) and GetEntityHealth(ped) > 101 then
			local vehicle,vehNet,vehPlate,vehName,vehLock = tvRP.vehList(5)
			if vehicle then
				TriggerServerEvent("garages:lockVehicle",vehNet,vehPlate,vehLock)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("cRcancelf6","Cancelar animações","keyboard","F6")
RegisterKeyMapping("cRhandsup","Levantar as mãos","keyboard","X")
RegisterKeyMapping("cRpoint","Apontar os dedos","keyboard","B")
RegisterKeyMapping("cRenginecrouch","Agachar / Ligar veículo","keyboard","Z")
RegisterKeyMapping("cRbind 1","Bind 1","keyboard","1")
RegisterKeyMapping("cRbind 2","Bind 2","keyboard","2")
RegisterKeyMapping("cRbind 3","Bind 3","keyboard","3")
RegisterKeyMapping("cRbind 4","Bind 4","keyboard","4")
RegisterKeyMapping("cRbind 5","Bind 5","keyboard","5")
RegisterKeyMapping("cRbind 6","Bind 6","keyboard","6")
RegisterKeyMapping("cRbind 7","Bind 7","keyboard","7")
RegisterKeyMapping("cRbind 8","Bind 8","keyboard","8")
RegisterKeyMapping("cRbind 9","Bind 9","keyboard","9")
RegisterKeyMapping("cRbind left","Bind Left","keyboard","LEFT")
RegisterKeyMapping("cRbind right","Bind Right","keyboard","RIGHT")
RegisterKeyMapping("cRbind up","Bind Up","keyboard","UP")
RegisterKeyMapping("cRbind down","Bind Down","keyboard","DOWN")
RegisterKeyMapping("cRaccept","Aceitar chamado","keyboard","Y")
RegisterKeyMapping("cRreject","Rejeitar chamado","keyboard","U")
RegisterKeyMapping("lockVehicles","Trancar veículo","keyboard","L")