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
	handPlayerTwo = {}

	playerTurn = true
    playerActionCompleted = false
	playerDrawingCards = false
	choosingDiscardPile = false
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

function love.keypressed(key)
    if playerTurn and not playerActionCompleted then
		if choosingDiscardPile then
            -- Playe chooses the discard he wants to place the card back on
            if key == '1' then
                table.insert(discardOne, table.remove(drawnCards, 1))
                playerActionCompleted = true
            elseif key == '2' then
                table.insert(discardTwo, table.remove(drawnCards, 1))
                playerActionCompleted = true
            end
        elseif playerDrawingCards then
            -- Player chooses which drawn card to keep
            if key == '1' then
                -- Keep the first card
                table.insert(handPlayerOne, table.remove(drawnCards, 1))
                -- Place the remaining card in the appropriate discard pile
                if #discardOne == 0 then
                    table.insert(discardOne, table.remove(drawnCards, 1))
                else
                    table.insert(discardTwo, table.remove(drawnCards, 1))
                end
                playerActionCompleted = true
            elseif key == '2' then
                -- Keep the second card
                table.insert(handPlayerOne, table.remove(drawnCards, 2))
                -- Place the remaining card in the appropriate discard pile
                if #discardOne == 0 then
                    table.insert(discardOne, table.remove(drawnCards, 1))
                else
                    table.insert(discardTwo, table.remove(drawnCards, 1))
                end
                playerActionCompleted = true
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

    if playerActionCompleted then
        -- End the player's turn
        playerTurn = false
        playerActionCompleted = false
		choosingDiscardPile = false
		playerDrawingCards = false

        -- Opponent's turn (simplified logic)
        takeCard(handPlayerTwo)
        takeCard(handPlayerTwo)

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
end

function love.draw()
    local output = {}

    -- Display discard pile 1
    table.insert(output, 'Discard n°1:')
    for _, card in ipairs(discardOne) do
        table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end

    -- Display discard pile 2
    table.insert(output, 'Discard n°2:')
    for _, card in ipairs(discardTwo) do
        table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end

	-- Players hand
    table.insert(output, 'Your hand:')
    for _, card in ipairs(handPlayerOne) do
        table.insert(output, ' - type: ' .. card.type .. ', color: ' .. card.color .. ', nature: ' .. card.nature)
    end
	table.insert(output, 'Total: '..getTotal(handPlayerOne))

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

    -- Draw the output text on the screen
    love.graphics.print(table.concat(output, '\n'), 15, 15)
end
