-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("hunting",cRP)
vCLIENT = Tunnel.getInterface("hunting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSWITCHBLADE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkSwitchblade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if (vRP.inventoryWeight(user_id) + (itemWeight("meatA") * 3)) > vRP.getBackpack(user_id) then
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
			return false
		end

		local consultItem = vRP.getInventoryItemAmount(user_id,"switchblade")
		if consultItem[1] >= 1 then
			if vRP.checkBroken(consultItem[2]) then
				TriggerClientEvent("Notify",source,"vermelho","Item quebrado.",5000)
				return false
			end

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.animalPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local reputationValue = vRP.checkReputation(user_id,"hunting")
		if reputationValue <= 500 then
			local randomItens = math.random(100)

			if randomItens <= 70 then
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatA",math.random(3),true)
				else
					vRP.generateItem(user_id,"meatA",math.random(2),true)
					vRP.generateItem(user_id,"meatB",1,true)
				end
			elseif randomItens >= 71 and randomItens <= 90 then
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatA",math.random(2),true)
					vRP.generateItem(user_id,"meatB",1,true)
				else
					vRP.generateItem(user_id,"meatA",1,true)
					vRP.generateItem(user_id,"meatB",math.random(2),true)
				end
			else
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatB",math.random(2),true)
					vRP.generateItem(user_id,"meatC",1,true)
				else
					vRP.generateItem(user_id,"meatB",1,true)
					vRP.generateItem(user_id,"meatC",math.random(2),true)
				end
			end
		elseif reputationValue >= 501 and reputationValue <= 1000 then
			local randomItens = math.random(100)

			if randomItens <= 70 then
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatA",math.random(3),true)

					if math.random(100) <= 50 then
						vRP.generateItem(user_id,"meatB",1,true)
					end
				else
					vRP.generateItem(user_id,"meatA",math.random(2),true)
					vRP.generateItem(user_id,"meatB",1,true)

					if math.random(100) <= 50 then
						vRP.generateItem(user_id,"meatC",1,true)
					end
				end
			elseif randomItens >= 71 and randomItens <= 90 then
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatA",math.random(2),true)
					vRP.generateItem(user_id,"meatB",1,true)

					if math.random(100) <= 50 then
						vRP.generateItem(user_id,"meatC",1,true)
					end
				else
					vRP.generateItem(user_id,"meatA",1,true)
					vRP.generateItem(user_id,"meatB",math.random(2),true)

					if math.random(100) <= 50 then
						vRP.generateItem(user_id,"meatS",1,true)
					end
				end
			else
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatB",math.random(2),true)
					vRP.generateItem(user_id,"meatC",1,true)
				else
					vRP.generateItem(user_id,"meatB",1,true)
					vRP.generateItem(user_id,"meatC",math.random(2),true)
				end

				if math.random(100) <= 50 then
					vRP.generateItem(user_id,"meatS",1,true)
				end
			end
		else
			local randomItens = math.random(100)

			if randomItens <= 70 then
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatB",math.random(3),true)

					if math.random(100) <= 50 then
						vRP.generateItem(user_id,"meatC",1,true)
					end
				else
					vRP.generateItem(user_id,"meatB",math.random(2),true)
					vRP.generateItem(user_id,"meatC",1,true)

					if math.random(100) <= 50 then
						vRP.generateItem(user_id,"meatS",1,true)
					end
				end
			elseif randomItens >= 71 and randomItens <= 90 then
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatB",math.random(2),true)
					vRP.generateItem(user_id,"meatC",1,true)
				else
					vRP.generateItem(user_id,"meatB",1,true)
					vRP.generateItem(user_id,"meatC",math.random(2),true)
				end

				if math.random(100) <= 50 then
					vRP.generateItem(user_id,"meatS",1,true)
				end
			else
				if math.random(100) <= 75 then
					vRP.generateItem(user_id,"meatC",math.random(2),true)
					vRP.generateItem(user_id,"meatS",1,true)
				else
					vRP.generateItem(user_id,"meatC",1,true)
					vRP.generateItem(user_id,"meatS",math.random(2),true)
				end
			end
		end

		if math.random(1000) <= 10 then
			if (vRP.inventoryWeight(user_id) + itemWeight("horndeer")) <= vRP.getBackpack(user_id) then
				vRP.generateItem(user_id,"horndeer",1,true)
			end
		end

		if (vRP.inventoryWeight(user_id) + itemWeight("animalpelt")) <= vRP.getBackpack(user_id) then
			vRP.generateItem(user_id,"animalpelt",1,true)
		end

		vRP.insertReputation(user_id,"hunting",1)
		vRP.upgradeStress(user_id,4)
	end
end