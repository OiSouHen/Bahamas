-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addBank(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		vRP.execute("characters/addBank",{ id = parseInt(user_id), bank = amount })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.delBank(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		vRP.execute("characters/removeBank",{ id = parseInt(user_id), bank = amount })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getBank(user_id)
	local consult = vRP.getInformation(user_id)
	if consult[1] then
		return parseInt(consult[1]["bank"])
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getFines(user_id)
	local consult = vRP.getInformation(user_id)
	if consult[1] then
		return parseInt(consult[1]["fines"])
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addFines(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		vRP.execute("characters/addFines",{ id = parseInt(user_id), fines = amount })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.delFines(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		vRP.execute("characters/removeFines",{ id = parseInt(user_id), fines = amount })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.paymentGems(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local identity = vRP.userIdentity(user_id)
		local infoAccount = vRP.infoAccount(identity["steam"])
		if infoAccount then
			if infoAccount["gems"] >= amount then
				vRP.execute("accounts/removeGems",{ steam = identity["steam"], gems = amount })
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.paymentBank(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local consult = vRP.getInformation(user_id)
		if consult[1] then
			if consult[1]["bank"] >= amount then
				vRP.execute("characters/removeBank",{ id = parseInt(user_id), bank = amount })

				local source = vRP.userSource(user_id)
				if source then
					TriggerClientEvent("itensNotify",source,{ "pagou","dollars",parseFormat(amount),"Dólares" })
				end

				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.paymentFull(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		if vRP.tryGetInventoryItem(user_id,"dollars",amount,true) then
			return true
		else
			local consult = vRP.getInformation(user_id)
			if consult[1] then
				if consult[1]["bank"] >= amount then
					vRP.execute("characters/removeBank",{ id = parseInt(user_id), bank = amount })

					local source = vRP.userSource(user_id)
					if source then
						TriggerClientEvent("itensNotify",source,{ "pagou","dollars",parseFormat(amount),"Dólares" })
					end

					return true
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.withdrawCash(user_id,amount)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		if vRP.getBank(user_id) >= amount then
			vRP.generateItem(user_id,"dollars",amount,true)
			vRP.execute("characters/removeBank",{ id = parseInt(user_id), bank = amount })

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPremium(user_id)
	local identity = vRP.userIdentity(user_id)
	if identity then
		local infoAccount = vRP.infoAccount(identity["steam"])
		if infoAccount and os.time() <= (infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEAMPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.steamPremium(steam)
	local infoAccount = vRP.infoAccount(steam)
	if infoAccount then
		if os.time() <= (infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
			return true
		end
	end

	return false
end