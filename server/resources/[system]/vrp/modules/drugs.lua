-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local weed = {}
local alcohol = {}
local chemical = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEEDRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.weedReturn(user_id)
	if weed[user_id] then
		if GetGameTimer() < weed[user_id] then
			return parseInt((weed[user_id] - GetGameTimer()) / 60000)
		else
			weed[user_id] = nil
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEEDTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.weedTimer(user_id,timeSet)
	if weed[user_id] then
		weed[user_id] = weed[user_id] + (timeSet * 60000)
	else
		weed[user_id] = GetGameTimer() + (timeSet * 60000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEMICALRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.chemicalReturn(user_id)
	if chemical[user_id] then
		if GetGameTimer() < chemical[user_id] then
			return parseInt((chemical[user_id] - GetGameTimer()) / 60000)
		else
			chemical[user_id] = nil
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEMICALTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.chemicalTimer(user_id,timeSet)
	if chemical[user_id] then
		chemical[user_id] = chemical[user_id] + (timeSet * 60000)
	else
		chemical[user_id] = GetGameTimer() + (timeSet * 60000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALCOHOLRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.alcoholReturn(user_id)
	if alcohol[user_id] then
		if GetGameTimer() < alcohol[user_id] then
			return parseInt((alcohol[user_id] - GetGameTimer()) / 60000)
		else
			alcohol[user_id] = nil
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEMICALTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.alcoholTimer(user_id,timeSet)
	if alcohol[user_id] then
		alcohol[user_id] = alcohol[user_id] + (timeSet * 60000)
	else
		alcohol[user_id] = GetGameTimer() + (timeSet * 60000)
	end
end