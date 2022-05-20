-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local noclip = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.noClip()
	noclip = not noclip
	local ped = PlayerPedId()

	if noclip then
		SetEntityInvincible(ped,true)
		SetEntityVisible(ped,false,false)
	else
		SetEntityInvincible(ped,false)
		SetEntityVisible(ped,true,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADNOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999

		if noclip then
			timeDistance = 1
			local speed = 1.0
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local dx,dy,dz = tvRP.getCamDirection()

			SetEntityVelocity(ped,0.0001,0.0001,0.0001)

			if IsControlPressed(1,21) then
				speed = 5.0
			end

			if IsControlPressed(1,32) then
				x = x + speed * dx
				y = y + speed * dy
				z = z + speed * dz
			end

			if IsControlPressed(1,269) then
				x = x - speed * dx
				y = y - speed * dy
				z = z - speed * dz
			end

			if IsControlPressed(1,10) then
				z = z + 0.5
			end

			if IsControlPressed(1,11) then
				z = z - 0.5
			end

			SetEntityCoordsNoOffset(ped,x,y,z,1,0,0)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCAMDIRECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getCamDirection()
	local ped = PlayerPedId()
	local pitch = GetGameplayCamRelativePitch()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(ped)
	local x = -math.sin(heading * math.pi / 180.0)
	local y = math.cos(heading * math.pi / 180.0)
	local z = math.sin(pitch * math.pi / 180.0)
	local len = math.sqrt(x*x + y*y + z*z)
	if len ~= 0 then
		x = x / len
		y = y / len
		z = z / len
	end

	return x,y,z
end