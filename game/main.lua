-- Definition of card types and their quantities in the deck
local cardDefinitions = require("cards")

-- Import the functions related to the deck 
local functions = require("deckFunctions")

-- global variables (temp)
deck = {}
discardOne = {}
discardTwo = {}
handPlayerOne = {}
matPlayerOne = {}
handPlayerTwo = {}
matPlayerTwo = {}
playerTurn = true
playerActionCompleted = false
playerDrawingCards = false
choosingDiscardPile = false
canPlayDuo = false
deckEmpty = false
playerPlayingDuo = false
drawnCards = {}
choosingFromDiscard = false
selectedDiscardPile = nil
discardSelectionIndex = 1


function love.load()
	-- Set random seed based on current time for true randomness
    math.randomseed(os.time())

    -- Initialize the deck
    for _, cardDef in ipairs(cardDefinitions) do
        for i = 1, cardDef.count do
            table.insert(deck, {type = cardDef.type, color = cardDef.color, nature = cardDef.nature})
        end
    end

    -- Shuffle the deck
    functions.shuffleDeck(deck)

    -- Debug: Print deck content to verify
    for i, card in ipairs(deck) do
        print('Card #' .. i .. ': type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end
    print('Total number of cards in deck: ' .. #deck)

	-- Init the discards
    functions.takeCard(discardOne)
	functions.takeCard(discardTwo)
end

function love.keypressed(key)
    if playerTurn and not playerActionCompleted then
		if choosingDiscardPile then
            -- Player chooses the discard he wants to place the card back on
            if key == '1' then
                table.insert(discardOne, table.remove(drawnCards, 1))
                choosingDiscardPile = false
				playerActionCompleted = true
            elseif key == '2' then
                table.insert(discardTwo, table.remove(drawnCards, 1))
                choosingDiscardPile = false
				playerActionCompleted = true
            end
        elseif playerDrawingCards then
            -- Player chooses which drawn card to keep
            if key == '1' then
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

function love.update()
    if deckEmpty then
        -- Stop the game and display a message
        return
    end
	canPlayDuo = functions.checkDuoPlayable(handPlayerOne)
end

function love.draw()
    
    if deckEmpty then
        love.graphics.print("Game over! The deck is empty. Nobody wins.", 15, 15)
        return
    end

    local output = {}

    -- Display discard pile 1
	table.insert(output, 'Discard n°1:')
    if #discardOne > 0 then
		local topCard = discardOne[#discardOne]
		table.insert(output, ' - type: ' .. topCard.type .. ', color: ' .. topCard.color .. ', nature: ' .. topCard.nature)
	else
		table.insert(output, 'No cards in this discard')
	end

    -- Display discard pile 2
    table.insert(output, '\nDiscard n°2:')
    if #discardTwo > 0 then
		local topCard = discardTwo[#discardTwo]
		table.insert(output, ' - type: ' .. topCard.type .. ', color: ' .. topCard.color .. ', nature: ' .. topCard.nature)
	else
		table.insert(output, 'No cards in this discard')
	end

	-- Players hand
    table.insert(output, '\nYour hand:')
    for _, card in ipairs(handPlayerOne) do
        table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end
	table.insert(output, 'Total: '..functions.getTotal(handPlayerOne))

	-- Display the player's mat
	table.insert(output, 'Your mat:')
	for _, card in ipairs(matPlayerOne) do
		table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
	end

	-- Opponent hand
    table.insert(output, '\nYour opp hand:')
    for _, card in ipairs(handPlayerTwo) do
        table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end
	table.insert(output, 'Total: '..functions.getTotal(handPlayerTwo))

	-- Display the opponent's mat
	table.insert(output, 'Your opp mat:')
	for _, card in ipairs(matPlayerTwo) do
		table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
	end

	-- Indicate whose turn it is
    if playerTurn then
        if choosingDiscardPile then
            table.insert(output, '\nChoose a discard pile for the remaining card:')
            table.insert(output, 'Press 1 to place it on Discard n°1.')
            table.insert(output, 'Press 2 to place it on Discard n°2.')
        elseif playerDrawingCards then
            table.insert(output, '\nYou drew two cards:')
            table.insert(output, '1: ' .. drawnCards[1].type .. ' (' .. drawnCards[1].color .. ')')
            table.insert(output, '2: ' .. drawnCards[2].type .. ' (' .. drawnCards[2].color .. ')')
            table.insert(output, 'Press 1 to keep the first card, or 2 to keep the second.')
		else
            table.insert(output, '\nIt\'s your turn!')
            table.insert(output, 'Press q to take the top card from Discard n°1.')
            table.insert(output, 'Press d to take the top card from Discard n°2.')
            table.insert(output, 'Press z to draw two cards from the deck.')
        end
    else
        table.insert(output, '\nOpponent is playing...')
    end

	-- Says if the player can play a duo
	if canPlayDuo then
		table.insert(output, '\nYou can play a duo! Press "p" to play two "duo" cards of the same type.')
	end

    -- Draw the output text on the screen
    love.graphics.print(table.concat(output, '\n'), 15, 15)
end
