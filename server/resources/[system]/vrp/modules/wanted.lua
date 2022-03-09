-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userWanted = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.wantedReturn(user_id)
	if userWanted[user_id] then
		if GetGameTimer() < userWanted[user_id] then
			return true
		else
			userWanted[user_id] = nil
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.wantedTimer(user_id,timeSet)
	if userWanted[user_id] then
		userWanted[user_id] = userWanted[user_id] + (timeSet * 1000)
	else
		userWanted[user_id] = GetGameTimer() + (timeSet * 1000)
	end

	local source = vRP.userSource(user_id)
	local calTimers = parseInt((userWanted[user_id] - GetGameTimer()) / 1000)
	TriggerClientEvent("vrp:wantedTimer",source,calTimers)
	TriggerClientEvent("vrp:wantedUpdate",source,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDRESET
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.wantedReset()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and userWanted[user_id] then
		userWanted[user_id] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	if vRP.wantedReturn(user_id) then
		local calTimers = parseInt((userWanted[user_id] - GetGameTimer()) / 1000)
		TriggerClientEvent("vrp:wantedTimer",source,calTimers)
		TriggerClientEvent("vrp:wantedUpdate",source,true)
	end
end)