-----------------------------------------------------------------------------------------------------------------------------------------
-- USERIDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userIdentity(user_id)
	local rows = vRP.getInformation(user_id)
	return rows[1]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userGemstone(user_id)
	local identity = vRP.userIdentity(user_id)
	if identity then
		local infoAccount = vRP.infoAccount(identity["steam"])
		if infoAccount then
			return parseInt(infoAccount["gems"])
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPlate(vehPlate)
	local rows = vRP.query("vehicles/plateVehicles",{ plate = vehPlate })
	if rows[1] then
		return rows[1]["user_id"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPhone(phoneNumber)
	local rows = vRP.query("characters/getPhone",{ phone = phoneNumber })
	if rows[1] then
		return rows[1]["id"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.myPhone(source)
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)

	return identity["phone"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESTRINGNUMBER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.generateStringNumber(format)
	local abyte = string.byte("A")
	local zbyte = string.byte("0")
	local number = ""

	for i = 1,#format do
		local char = string.sub(format,i,i)
    	if char == "D" then
    		number = number..string.char(zbyte + math.random(0,9))
		elseif char == "L" then
			number = number..string.char(abyte + math.random(0,25))
		else
			number = number..char
		end
	end

	return number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.generatePlate()
	local user_id = nil
	local vehPlate = ""

	repeat
		vehPlate = vRP.generateStringNumber("DDLLLDDD")
		user_id = vRP.userPlate(vehPlate)
	until not user_id

	return vehPlate
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.generatePhone()
	local user_id = nil
	local phone = ""

	repeat
		phone = vRP.generateStringNumber("DDD-DDD")
		user_id = vRP.userPhone(phone)
	until not user_id

	return phone
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSERIAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userSerial(serialNumber)
	local rows = vRP.query("characters/getSerial",{ serial = serialNumber })
	if rows[1] then
		return rows[1]["id"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.generateSerial()
	local user = nil
	local serial = ""

	repeat
		serial = vRP.generateStringNumber("LLLDDD")
		user = vRP.userSerial(serial)
	until not user

	return serial
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInformation(user_id)
	return vRP.query("characters/getUsers",{ id = parseInt(user_id) })
end