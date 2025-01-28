-- Import the functions related to the deck 
local functions = require("deckFunctions")

function interactions(key)
	if playerTurn and not playerActionCompleted then
		if choosingDiscardPile then
			-- Player chooses the discard he wants to place the card back on
			if key == '1' then
				functions.takeCardFrom(discardOne, drawnCards)
				choosingDiscardPile = false
				playerActionCompleted = true
			elseif key == '2' then
				functions.takeCardFrom(discardTwo, drawnCards)
				choosingDiscardPile = false
				playerActionCompleted = true
			end
		elseif playerDrawingCards then
			-- Player chooses which drawn card to keep
			if key == '1' then
				functions.takeCardFrom(handPlayerOne, drawnCards)
				table.insert(handPlayerOne, table.remove(drawnCards, 1))
				choosingDiscardPile = true
				playerDrawingCards = false
			elseif key == '2' then
				table.insert(handPlayerOne, table.remove(drawnCards, 2))
				choosingDiscardPile = true
				playerDrawingCards = false
			end
		else
			-- Player decides their action
			if key == 'q' and #discardOne > 0 then
				-- Take the top card from discard pile 1
				table.insert(handPlayerOne, table.remove(discardOne, #discardOne))
				playerActionCompleted = true
			elseif key == 'd' and #discardTwo > 0 then
				-- Take the top card from discard pile 2
				table.insert(handPlayerOne, table.remove(discardTwo, #discardTwo))
				playerActionCompleted = true
			elseif key == 'z' then
				-- Draw two cards from the deck
				functions.takeCard(drawnCards)
				functions.takeCard(drawnCards)
				playerDrawingCards = true
			end
		end
	end
	
	-- Phase 2 of a turn : Playing duo cards (not mendatory)
	if playerTurn and canPlayDuo then
		-- Permet au joueur de poser des cartes "duo"
		if key == 'p' then
			-- Trouve le type pour lequel poser les cartes
			local duoCards = {}
			for _, card in ipairs(handPlayerOne) do
				if card.nature == "duo" then
					if not duoCards[card.type] then
						duoCards[card.type] = 0
					end
					duoCards[card.type] = duoCards[card.type] + 1
				end
			end
	
			for cardType, count in pairs(duoCards) do
				if count >= 2 then
					local isCrabDuo, isBoatDuo, isFishDuo = functions.playDuoCards(handPlayerOne, matPlayerOne, cardType)
					functions.playDuoCards(handPlayerOne, matPlayerOne, cardType)
					print("You played a duo of type: " .. cardType)
					
					if isCrabDuo then
						print("You played a crab duo! Select a discard and choose a card in it")
					elseif isBoatDuo then
						print("You played a boat duo! play again !")
						-- TODO : boat logic
					elseif isFishDuo then
						print("You played a fish duo! Take a bonus card.")
						functions.takeCard(handPlayerOne)
					end
					
					canPlayDuo = false
					playerActionCompleted = true
					break
				end
			end
		end
	end
	
	-- Phase 3 of a turn : End the round 
	--[[
	TODO
	]]
	
	if playerActionCompleted then
		-- End the player's turn
		playerTurn = false
		playerActionCompleted = false
	
		-- Opponent's turn (simplified logic : it always take 2 cards, chooses the left one and put the second back on the left discard)
		functions.takeCard(drawnCards)
		functions.takeCard(drawnCards)
		table.insert(handPlayerTwo, table.remove(drawnCards, 1))
		table.insert(discardOne, table.remove(drawnCards, 1))
	
		-- Return to Player One's turn
		playerTurn = true
	end
end

return interactions
