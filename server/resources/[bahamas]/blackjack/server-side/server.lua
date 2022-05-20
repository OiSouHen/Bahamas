-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKJACKTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blackjackTables = {}
local blackjackGameData = {}
local blackjackGameInProgress = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKJACKTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
for i = 0,127,1 do
	blackjackTables[i] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKJACKTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	local source = source
	for k,v in pairs(blackjackTables) do
		if v == source then
			blackjackTables[k] = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("Blackjack:sendBlackjackTableData",source,blackjackTables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:requestSitAtBlackjackTable")
AddEventHandler("Blackjack:requestSitAtBlackjackTable", function(chairId)
	local source = source

	if source ~= nil then
		for k,v in pairs(blackjackTables) do 
			if v == source then 
				blackjackTables[k] = false
				return
			end
		end

		blackjackTables[chairId] = source
		TriggerClientEvent("Blackjack:sendBlackjackTableData",-1,blackjackTables)
		TriggerClientEvent("Blackjack:sitAtBlackjackTable",source,chairId)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVEBLACKJACKTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:leaveBlackjackTable")
AddEventHandler("Blackjack:leaveBlackjackTable", function(chairId)
	local source = source

	if source ~= nil then 
		for k,v in pairs(blackjackTables) do 
			if v == source then 
				blackjackTables[k] = false
			end
		end

		TriggerClientEvent("Blackjack:sendBlackjackTableData",-1,blackjackTables)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBLACKJACKBET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:setBlackjackBet")
AddEventHandler("Blackjack:setBlackjackBet",function(gameId,betAmount,chairId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if gameId ~= nil and betAmount ~= nil and chairId ~= nil then 
			if blackjackGameData[gameId] == nil then
				blackjackGameData[gameId] = {}
			end

			if not blackjackGameInProgress[gameId] then
				if parseInt(betAmount) then
					betAmount = parseInt(betAmount)

					if betAmount > 0 then
						if vRP.tryGetInventoryItem(user_id,"chips",betAmount) then
							if blackjackGameData[gameId][source] == nil then
								blackjackGameData[gameId][source] = {}
							end

							blackjackGameData[gameId][source][1] = betAmount
							TriggerClientEvent("Blackjack:successBlackjackBet",source)
							TriggerClientEvent("Blackjack:syncChipsPropBlackjack",-1,betAmount,chairId)
						else
							TriggerClientEvent("Notify",source,"vermelho","Fichas insuficientes.",5000)
						end
					end
				end
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Aposta indisponível.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HITBLACKJACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:hitBlackjack")
AddEventHandler("Blackjack:hitBlackjack",function(gameId,nextCardCount)
	local source = source

	if blackjackGameData[gameId] == nil then
		blackjackGameData[gameId] = {}
	end

	if blackjackGameData[gameId][source] == nil then
		blackjackGameData[gameId][source] = {}
	end

	if blackjackGameData[gameId][source][2] == nil then
		blackjackGameData[gameId][source][2] = {}
	end

	blackjackGameData[gameId][source][2][nextCardCount] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STANDBLACKJACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:standBlackjack")
AddEventHandler("Blackjack:standBlackjack",function(gameId,nextCardCount)
	local source = source

	if blackjackGameData[gameId] == nil then
		blackjackGameData[gameId] = {}
	end

	if blackjackGameData[gameId][source] == nil then
		blackjackGameData[gameId][source] = {}
	end

	if blackjackGameData[gameId][source][2] == nil then
		blackjackGameData[gameId][source][2] = {}
	end

	blackjackGameData[gameId][source][2][nextCardCount] = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADWHILE
-----------------------------------------------------------------------------------------------------------------------------------------
for i = 0,31,1 do
	CreateThread(function()
		math.randomseed(os.clock() * 100000000000)

		while true do
			math.random()
			math.random()
			math.random()

			local tableId = i
			local game_ready = false
			local players_ready = {}
			local chairIdInitial = i * 4
			local chairIdFinal = (i * 4) + 3

			for chairID = chairIdInitial,chairIdFinal do
				if blackjackTables[chairID] ~= false then   
					table.insert(players_ready,blackjackTables[chairID])
					game_ready = true
				end
			end

			if game_ready then
				local gameId = math.random(1000,10000000)
				blackjackGameData[gameId] = {}
				blackjackGameInProgress[gameId] = false

				for k,v in pairs(players_ready) do
					local source = v
					blackjackGameData[gameId][source] = {}

					if source ~= nil then
						TriggerClientEvent("Blackjack:beginBetsBlackjack",source,gameId,tableId)
					end
				end

				Wait(21000)

				if blackjackGameData[gameId] ~= nil then
					for k,v in pairs(blackjackGameData[gameId]) do
						if v ~= nil then
							local betAmount = v[1]
							local playerBetted = false

							if betAmount ~= nil and betAmount > 0 then
								playerBetted = true
							end

							if not playerBetted then
								blackjackGameData[gameId][k] = nil
							end
						end
					end

					if not isTableEmpty(blackjackGameData[gameId]) then
						blackjackGameInProgress[gameId] = true

						for cardIndex = 0,1,1 do
							for chairID = chairIdInitial,chairIdFinal do
								if blackjackTables[chairID] ~= false then
									local source = blackjackTables[chairID]
									if blackjackGameData[gameId] == nil then
										blackjackGameData[gameId] = {}
									end

									if blackjackGameData[gameId][source] == nil then
										blackjackGameData[gameId][source] = {}
									end

									if blackjackGameData[gameId][source][1] ~= nil then
										if blackjackGameData[gameId][source][1] > 0 then
											if blackjackGameData[gameId][source]["cardData"] == nil then
												blackjackGameData[gameId][source]["cardData"] = {}
											end

											local randomCard = math.random(52)
											table.insert(blackjackGameData[gameId][source]["cardData"],randomCard)
											TriggerClientEvent("Blackjack:beginCardGiveOut",-1,gameId,blackjackGameData[gameId][source]["cardData"],chairID,cardIndex,getCurrentHand(gameId,source),tableId)
											Wait(3500)
										else 
											blackjackGameData[gameId][source] = nil
										end
									else 
										blackjackGameData[gameId][source] = nil
									end
								end
							end

							if blackjackGameData[gameId]["dealer"] == nil then 
								blackjackGameData[gameId]["dealer"] = {}
							end

							if blackjackGameData[gameId]["dealer"]["cardData"] == nil then 
								blackjackGameData[gameId]["dealer"]["cardData"] = {}
							end

							if cardIndex == 0 then
								local randomCard = math.random(52)
								table.insert(blackjackGameData[gameId]["dealer"]["cardData"],randomCard) 
								TriggerClientEvent("Blackjack:beginCardGiveOut",-1,gameId,blackjackGameData[gameId]["dealer"]["cardData"],gameId,cardIndex,getCurrentHand(gameId,"dealer"),tableId)
							end

							Wait(1500)
						end

						for chairID = chairIdInitial,chairIdFinal do
							if blackjackTables[chairID] ~= false then
								local source = blackjackTables[chairID]

								if blackjackGameData[gameId][source] ~= nil then 
									local nextCardCount = 1
									local currentHand = getCurrentHand(gameId,source)

									if currentHand < 21 then
										TriggerClientEvent("Blackjack:standOrHit",-1,gameId,chairID,nextCardCount,tableId)                            
										blackjackGameData[gameId][source][2] = {}

										while nextCardCount >= 1 do
											secondsWaited = 0

											while blackjackGameData[gameId][source][2][nextCardCount] == nil and secondsWaited < 20 do
												Wait(100)
												secondsWaited = secondsWaited + 0.1
											end

											if blackjackGameData[gameId][source][2][nextCardCount] == true then
												nextCardCount = nextCardCount + 1
												local randomCard = math.random(52)
												table.insert(blackjackGameData[gameId][source]["cardData"],randomCard)
												TriggerClientEvent("Blackjack:singleCard",-1,gameId,randomCard,chairID,nextCardCount,getCurrentHand(gameId,source),tableId) 

												Wait(2000)

												local currentHand = getCurrentHand(gameId,source)
												if currentHand > 21 then
													nextCardCount = 0
													TriggerClientEvent("Blackjack:bustBlackjack",-1,chairID,tableId)
													blackjackGameData[gameId][source]["status"] = "bust"
												elseif currentHand < 21 then
													TriggerClientEvent("Blackjack:standOrHit",-1,gameId,chairID,nextCardCount,tableId)  
												else
													nextCardCount = 0
													blackjackGameData[gameId][source]["status"] = "stand"
												end
											elseif blackjackGameData[gameId][source][2][nextCardCount] == false then
												nextCardCount = 0
												blackjackGameData[gameId][source]["status"] = "stand"
											else 
												nextCardCount = 0
												blackjackGameData[gameId][source]["status"] = "stand"
											end
										end
									else
										if currentHand == 21 then
											local user_id = vRP.getUserId(source)
											if user_id then
												vRP.giveInventoryItem(user_id,"chips",blackjackGameData[gameId][source][1] * 0.5,true)
											end
										end

										blackjackGameData[gameId][source]["status"] = "stand"
									end
								end

								TriggerClientEvent("Blackjack:endStandOrHitPhase",-1,chairID,tableId) 
							end
						end

						local randomCard = math.random(52)
						table.insert(blackjackGameData[gameId]["dealer"]["cardData"],randomCard)
						TriggerClientEvent("Blackjack:beginCardGiveOut",-1,gameId,blackjackGameData[gameId]["dealer"]["cardData"],gameId,1,getCurrentHand(gameId,"dealer"),tableId)

						Wait(2800)

						dealerHand = getCurrentHand(gameId,"dealer")
						TriggerClientEvent("Blackjack:flipDealerCard",-1,dealerHand,tableId,gameId)

						Wait(2800)

						local allPlayersHaveBusted = true
						for k,v in pairs(blackjackGameData[gameId]) do
							local betStatus = v["status"]

							if betStatus ~= nil then
								if betStatus == "stand" then
									allPlayersHaveBusted = false
								end
							end
						end

						dealerHand = getCurrentHand(gameId,"dealer")
						if not allPlayersHaveBusted then
							if dealerHand < 17 then
								local nextCardCount = 2
								local highestPlayerHand = 0

								for k,v in pairs(blackjackGameData[gameId]) do 
									if k ~= "dealer" then
										playerHand = getCurrentHand(gameId,k)

										if playerHand ~= nil then
											if playerHand > highestPlayerHand and playerHand <= 21 then
												highestPlayerHand = playerHand
											end
										end
									end
								end

								while dealerHand < 17 do 
									local randomCard = math.random(52)
									table.insert(blackjackGameData[gameId]["dealer"]["cardData"],randomCard)
									TriggerClientEvent("Blackjack:singleDealerCard",-1,gameId,randomCard,nextCardCount,getCurrentHand(gameId,"dealer"),tableId)

									Wait(2800)

									nextCardCount = nextCardCount + 1

									dealerHand = getCurrentHand(gameId,"dealer")
								end
							end
						end

						for k,v in pairs(blackjackGameData[gameId]) do
							if k ~= "dealer" then
								local source = k

								if blackjackGameData[gameId][source] ~= nil then
									if blackjackGameData[gameId][source]["status"] ~= "bust" then 
										local currentHand = getCurrentHand(gameId,source)
										if currentHand ~= nil then
											if currentHand <= 21 then
												if dealerHand > 21 then
													local user_id = vRP.getUserId(source)
													if user_id then
														local potentialWinAmount = 100
														if blackjackGameData[gameId] then
															if blackjackGameData[gameId][source] then
																potentialWinAmount = blackjackGameData[gameId][source][1] * 2
															end
														end

														vRP.giveInventoryItem(user_id,"chips",potentialWinAmount,true)
														TriggerClientEvent("Blackjack:blackjackWin",source,tableId)
													end

													TriggerClientEvent("Blackjack:dealerBusts",-1,tableId)
												elseif currentHand > dealerHand and currentHand <= 21 then
													local user_id = vRP.getUserId(source)
													if user_id then
														local potentialWinAmount = 100
														if blackjackGameData[gameId] then
															if blackjackGameData[gameId][source] then
																potentialWinAmount = blackjackGameData[gameId][source][1] * 2
															end
														end

														vRP.giveInventoryItem(user_id,"chips",potentialWinAmount,true)
														TriggerClientEvent("Blackjack:blackjackWin",source,tableId)
													end
												elseif currentHand == dealerHand then
													local user_id = vRP.getUserId(source)
													if user_id then
														local potentialWinAmount = 100
														if blackjackGameData[gameId] then
															if blackjackGameData[gameId][source] then
																potentialWinAmount = blackjackGameData[gameId][source][1]
															end
														end

														vRP.giveInventoryItem(user_id,"chips",potentialWinAmount,true)
														TriggerClientEvent("Blackjack:blackjackWin",source,tableId)
													end
												else
													TriggerClientEvent("Blackjack:blackjackLose",source,tableId)
												end
											end
										end
									end
								end
							end
						end

						for chairID = chairIdInitial,chairIdFinal do
							if blackjackTables[chairID] ~= false then
								local source = blackjackTables[chairID]

								if blackjackGameData[gameId][source] ~= nil then
									TriggerClientEvent("Blackjack:chipsCleanup",-1,chairID,tableId)
									TriggerClientEvent("Blackjack:chipsCleanup",-1,tostring(chairID).."chips",tableId)
									Wait(3500)
								end
							end
						end

						TriggerClientEvent("Blackjack:chipsCleanup",-1,gameId,tableId)

						for chairID = chairIdInitial,chairIdFinal do
							TriggerClientEvent("Blackjack:chipsCleanupNoAnim",-1,chairID,tableId) 
							TriggerClientEvent("Blackjack:chipsCleanupNoAnim",-1,tostring(chairID).."chips",tableId)
						end

						blackjackGameInProgress[gameId] = false
					end
				end
			else
				Wait(1000)
			end

			Wait(1000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTHAND
-----------------------------------------------------------------------------------------------------------------------------------------
function getCurrentHand(gameId,userId)
	if gameId ~= nil and userId ~= nil then
		if blackjackGameData[gameId] ~= nil then
			if blackjackGameData[gameId] ~= nil then
				if blackjackGameData[gameId][userId] ~= nil then
					if blackjackGameData[gameId][userId]["cardData"] ~= nil then 
						local hand = 0
						local numberOfAces = 0

						for k,v in pairs(blackjackGameData[gameId][userId]["cardData"]) do
							local nextCard = getCardNumberFromCardId(v)
							if nextCard == 11 then
								numberOfAces = numberOfAces + 1
							else
								hand = hand + nextCard
							end
						end

						for i = 1,numberOfAces,1 do
							if i == 1 then
								if hand + 11 > 21 then
									nextCard = 1
								else
									nextCard = 11
								end
							else
								nextCard = 1
							end

							hand = hand + nextCard
						end

						return hand
					end
				end
			end
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAIRIDTOTABLEID
-----------------------------------------------------------------------------------------------------------------------------------------
function chairIdToTableId(chairId)
	if chairId <= 3 then
		return 0
	end

	if chairId <= 7 then
		return 1
	end

	if chairId <= 11 then
		return 2
	end

	if chairId <= 15 then
		return 3
	end

	if chairId <= 19 then
		return 4
	end

	if chairId <= 23 then
		return 5
	end

	if chairId <= 27 then
		return 6
	end

	if chairId <= 31 then
		return 7
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCARDNUMBERFROMCARDID
-----------------------------------------------------------------------------------------------------------------------------------------
function getCardNumberFromCardId(cardId)
	if cardId == 1 then
		return 11
	elseif cardId == 2 then
		return 2
	elseif cardId == 3 then
		return 3
	elseif cardId == 4 then
		return 4
	elseif cardId == 5 then
		return 5
	elseif cardId == 6 then
		return 6
	elseif cardId == 7 then
		return 7
	elseif cardId == 8 then
		return 8
	elseif cardId == 9 then
		return 9
	elseif cardId == 10 then
		return 10
	elseif cardId == 11 then
		return 10
	elseif cardId == 12 then
		return 10
	elseif cardId == 13 then
		return 10
	elseif cardId == 14 then
		return 11
	elseif cardId == 15 then
		return 2
	elseif cardId == 16 then
		return 3
	elseif cardId == 17 then
		return 4        
	elseif cardId == 18 then
		return 5
	elseif cardId == 19 then
		return 6
	elseif cardId == 20 then
		return 7
	elseif cardId == 21 then
		return 8
	elseif cardId == 22 then
		return 9
	elseif cardId == 23 then
		return 10
	elseif cardId == 24 then
		return 10
	elseif cardId == 25 then
		return 10
	elseif cardId == 26 then
		return 10
	elseif cardId == 27 then
		return 11
	elseif cardId == 28 then
		return 2
	elseif cardId == 29 then
		return 3
	elseif cardId == 30 then
		return 4
	elseif cardId == 31 then
		return 5
	elseif cardId == 32 then
		return 6
	elseif cardId == 33 then
		return 7
	elseif cardId == 34 then
		return 8
	elseif cardId == 35 then
		return 9
	elseif cardId == 36 then
		return 10
	elseif cardId == 37 then
		return 10
	elseif cardId == 38 then
		return 10
	elseif cardId == 39 then
		return 10
	elseif cardId == 40 then
		return 11
	elseif cardId == 41 then
		return 2
	elseif cardId == 42 then
		return 3
	elseif cardId == 43 then
		return 4
	elseif cardId == 44 then
		return 5
	elseif cardId == 45 then
		return 6
	elseif cardId == 46 then
		return 7
	elseif cardId == 47 then
		return 8
	elseif cardId == 48 then
		return 9
	elseif cardId == 49 then
		return 10
	elseif cardId == 50 then
		return 10
	elseif cardId == 51 then
		return 10
	elseif cardId == 52 then
		return 10
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISTABLEEMPTY
-----------------------------------------------------------------------------------------------------------------------------------------
function isTableEmpty(self)
	for _,_ in pairs(self) do
		return false
	end

	return true
end