function love.load()
	-- Set random seed based on current time for true randomness
    math.randomseed(os.time())

    -- Definition of card types and their quantities in the deck
    local cardDefinitions = require("cards")

    deck = {}

    -- Initialize the deck
    for _, cardDef in ipairs(cardDefinitions) do
        for i = 1, cardDef.count do
            table.insert(deck, {type = cardDef.type, color = cardDef.color, nature = cardDef.nature})
        end
    end

    -- Shuffle the deck
    shuffleDeck(deck)

    -- Debug: Print deck content to verify
    for i, card in ipairs(deck) do
        print('Card #' .. i .. ': type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end
    print('Total number of cards in deck: ' .. #deck)

	discardOne = {}
	discardTwo = {}
    takeCard(discardOne)
	takeCard(discardTwo)

	handPlayerOne = {}
	matPlayerOne = {}

	handPlayerTwo = {}
	matPlayerTwo = {}

	playerTurn = true
    playerActionCompleted = false
	playerDrawingCards = false
	choosingDiscardPile = false
	canPlayDuo = false
	playerPlayingDuo = false
	drawnCards = {}
end

function shuffleDeck(deck)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function takeCard(target)
	table.insert(target, table.remove(deck, 1))
end

function playFromHand(target, hand)
	table.insert(target, table.remove(hand, 1))
end

function checkDuoPlayable(hand)
    local duoCards = {}
    for _, card in ipairs(hand) do
        if card.nature == "duo" then
            if not duoCards[card.type] then
                duoCards[card.type] = 0
            end
            duoCards[card.type] = duoCards[card.type] + 1
        end
    end

    for _, count in pairs(duoCards) do
        if count >= 2 then
            return true
        end
    end
    return false
end

function playDuoCards(hand, mat, typeToPlay)
    local cardsPlayed = 0
	local isCrabDuo = (typeToPlay == "crab")
	local isFishDuo = (typeToPlay == "fish")
    for i = #hand, 1, -1 do
        if hand[i].nature == "duo" and hand[i].type == typeToPlay then
            table.insert(mat, table.remove(hand, i))
            cardsPlayed = cardsPlayed + 1
            if cardsPlayed == 2 then
                break
            end
        end
    end
	return isFishDuo
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
                takeCard(drawnCards)
                takeCard(drawnCards)
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
					local isFishDuo = playDuoCards(handPlayerOne, matPlayerOne, cardType)
					playDuoCards(handPlayerOne, matPlayerOne, cardType)
					print("You played a duo of type: " .. cardType)
					
					if isFishDuo then
						print("You played a fish duo! Take a bonus card.")
						takeCard(handPlayerOne)
						isFishDuo = false
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
		takeCard(drawnCards)
		takeCard(drawnCards)
		table.insert(handPlayerTwo, table.remove(drawnCards, 1))
		table.insert(discardOne, table.remove(drawnCards, 1))

		-- Return to Player One's turn
		playerTurn = true
    end
end

function getTotal(hand)
	local total = 0
	-- TODO : Implement the logic to calculate the total value of the hand
	return total
end

function love.update()
	canPlayDuo = checkDuoPlayable(handPlayerOne)
end

function love.draw()
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
	table.insert(output, 'Total: '..getTotal(handPlayerOne))

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
	table.insert(output, 'Total: '..getTotal(handPlayerTwo))

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
