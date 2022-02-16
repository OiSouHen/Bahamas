-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userRepose = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSERETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.reposeReturn(user_id)
	if userRepose[user_id] then
		if GetGameTimer() < userRepose[user_id] then
			return true
		else
			userRepose[user_id] = nil
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSETIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.reposeTimer(user_id,timeSet)
	if userRepose[user_id] then
		userRepose[user_id] = userRepose[user_id] + (timeSet * 60000)
	else
		userRepose[user_id] = GetGameTimer() + (timeSet * 60000)
	end

	local source = vRP.userSource(user_id)
	local calTimers = parseInt((userRepose[user_id] - GetGameTimer()) / 1000)
	TriggerClientEvent("vrp:reposeTimer",source,calTimers)
	TriggerClientEvent("vrp:reposeUpdate",source,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSERESET
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.reposeReset()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and userRepose[user_id] then
		userRepose[user_id] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	if vRP.reposeReturn(user_id) then
		local calTimers = parseInt((userRepose[user_id] - GetGameTimer()) / 1000)
		TriggerClientEvent("vrp:reposeTimer",source,calTimers)
		TriggerClientEvent("vrp:reposeUpdate",source,true)
	end
end)