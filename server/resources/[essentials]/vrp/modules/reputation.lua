local reputationList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.insertReputation(user_id,reputation,amount)
	local user_id = parseInt(user_id)

	if reputationList[user_id][reputation] == nil then
		reputationList[user_id][reputation] = 0
	end

	reputationList[user_id][reputation] = reputationList[user_id][reputation] + amount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.checkReputation(user_id,reputation)
	local user_id = parseInt(user_id)

	if reputationList[user_id][reputation] == nil then
		reputationList[user_id][reputation] = 0
	end

	return parseInt(reputationList[user_id][reputation])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	reputationList[user_id] = vRP.userData(user_id,"Reputation")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if reputationList[user_id] then
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Reputation", value = json.encode(reputationList[user_id]) })
		reputationList[user_id] = nil
	end
end)