-----------------------------------------------------------------------------------------------------------------------------------------
-- SAFEPARAMETERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function safeParameters(parameters)
	if parameters == nil then
		return { [''] = '' }
	end

	return parameters
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTESYNC
-----------------------------------------------------------------------------------------------------------------------------------------
exports("executeSync",function(query,parameters)
	local res = {}
	local finishedQuery = false

	exports.ghmattimysql:execute(query,safeParameters(parameters),function(result)
		res = result
		finishedQuery = true
	end,GetInvokingResource())

	repeat
		Citizen.Wait(0)
	until finishedQuery

	return res
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCALARSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
exports("scalarSync",function(query,parameters)
	local res = {}
	local finishedQuery = false

	exports.ghmattimysql:scalar(query,safeParameters(parameters),function(result)
		res = result
		finishedQuery = true
	end,GetInvokingResource())

	repeat
		Citizen.Wait(0)
	until finishedQuery

	return res
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
exports("transactionSync",function(query,parameters)
	local res = {}
	local finishedTransaction = false

	exports.ghmattimysql:transaction(query,safeParameters(parameters),function(result)
		res = result
		finishedTransaction = true
	end,GetInvokingResource())

	repeat
		Citizen.Wait(0)
	until finishedTransaction

	return res
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORESYNC
-----------------------------------------------------------------------------------------------------------------------------------------
exports("storeSync",function(query)
	local res = {}
	local finishedStore = false

	exports.ghmattimysql:store(query,function(result)
		res = result
		finishedStore = true
	end,GetInvokingResource())

	repeat
		Citizen.Wait(0)
	until finishedStore

	return res
end)