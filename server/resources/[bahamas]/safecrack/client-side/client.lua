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
Tunnel.bindInterface("safecrack",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
animsIdle = {}
animsIdle[1] = "idle_base"
animsIdle[2] = "idle_heavy_breathe"
animsIdle[3] = "idle_look_around"

animsSucceed = {}
animsSucceed[1] = "dial_turn_succeed_1"
animsSucceed[2] = "dial_turn_succeed_2"
animsSucceed[3] = "dial_turn_succeed_3"
animsSucceed[4] = "dial_turn_succeed_4"
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function safeCraking(numbers)
	vRP.removeObjects()

	FreezeEntityPosition(PlayerPedId(),true)
	RequestAmbientAudioBank("SAFE_CRACK",false)
	RequestStreamedTextureDict("MPSafeCracking",false)
	while not HasStreamedTextureDictLoaded("MPSafeCracking") do
		Citizen.Wait(1)
	end

	difficultySetting = {}
	difficulty = parseInt(numbers)
	for i = 1,difficulty do
		difficultySetting[i] = 1
	end

	desirednum = math.floor(math.random(99))
	if desirednum == 0 then
		desirednum = 1
	end

	i = 0.0
	dicks = 1
	safelock = 0
	currentLock = 1
	cracking = true
	factor = difficulty
	local pinfall = false
	openString = "lock_open"
	closedString = "lock_closed"

	crackingAnim(1)

	while cracking do
		Citizen.Wait(1)
		dwText("~g~F~w~  GIRA PARA ESQUERDA     |     ~g~H~w~  GIRA PARA DIREITA     |     ~y~G~w~  TENTATIVA",4,0.5,0.93,0.38,255,255,255,255)

		DisableControlAction(1,257,true)
		DisableControlAction(1,140,true)
		DisableControlAction(1,142,true)
		DisableControlAction(1,38,true)
		DisablePlayerFiring(ped,true)

		if IsControlPressed(1,49) then
			if dicks > 1 then
				i = i + 1.8
				PlaySoundFrontend(0,"TUMBLER_TURN","SAFE_CRACK_SOUNDSET",true)

				dicks = 0
				crackingAnim(1)
			end
		end

		if IsControlPressed(1,304) then
			if dicks > 1 then
				i = i - 1.8
				PlaySoundFrontend(0,"TUMBLER_TURN","SAFE_CRACK_SOUNDSET",true)

				dicks = 0
				crackingAnim(1)
			end
		end

		dicks = dicks + 0.2

		if i < 0.0 then
			i = 360.0
		end

		if i > 360.0 then
			i = 0.0
		end

		safelock = math.floor(100 - (i/3.6))

		if currentLock > difficulty then
			break
		end

		if safelock == desirednum then
			if not pinfall then
				PlaySoundFrontend(0,"TUMBLER_PIN_FALL","SAFE_CRACK_SOUNDSET",true)
				pinfall = true
			end

			if IsControlJustPressed(1,47) then
				pinfall = false
				PlaySoundFrontend(0,"TUMBLER_RESET","SAFE_CRACK_SOUNDSET",true)
				factor = factor / 2
				i = 0.0
				safelock = 0
				desirednum = math.floor(math.random(99))
				crackingAnim(2)
				if desirednum == 0 then
					desirednum = 1
				end

				difficultySetting[currentLock] = 0
				currentLock = currentLock + 1
			end
		else
			pinfall = false

			if IsControlJustPressed(1,47) then
				break
			end
		end

		DrawSprite("MPSafeCracking","Dial_BG",0.65,0.5,0.18,0.32,0,255,255,211,255)
		DrawSprite("MPSafeCracking","Dial",0.65,0.5,0.09,0.16,i,255,255,211,255)

		addition = 0.45
		xaddition = 0.58

		for x = 1,difficulty do
			if difficultySetting[x] ~= 1 then
				DrawSprite("MPSafeCracking",openString,xaddition,addition,0.012,0.024,0,255,255,211,255)
			else
				DrawSprite("MPSafeCracking",closedString,xaddition,addition,0.012,0.024,0,255,255,211,255)
			end

			addition = addition + 0.05

			if x == 10 or x == 20 or x == 30 then
				addition = 0.25
				xaddition = xaddition + 0.05
			end
		end
	end

	FreezeEntityPosition(PlayerPedId(),false)
	vRP.removeObjects()

	if currentLock > difficulty then
		PlaySoundFrontend(0,"SAFE_DOOR_OPEN","SAFE_CRACK_SOUNDSET",true)
		return true
	end

	PlaySoundFrontend(0,"SAFE_DOOR_CLOSE","SAFE_CRACK_SOUNDSET",true)

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function loadAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAKINGANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function crackingAnim(animType)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)

	if GetEntityHealth(ped) > 101 then
		loadAnim("mini@safe_cracking")

		if animType == 1 then
			if not IsEntityPlayingAnim(ped,"mini@safe_cracking","dial_turn_anti_fast_1",3) then
				TaskPlayAnim(ped,"mini@safe_cracking","dial_turn_anti_fast_1",8.0,-8,-1,49,0,0,0,0)
			end
		end

		if animType == 2 then
			TaskPlayAnim(ped,"mini@safe_cracking",animsSucceed[math.floor(math.ceil(4))],8.0,1.0,-1,49,0,0,0,0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("safeCraking",safeCraking)