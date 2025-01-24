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

	function takeCard(target)
        table.insert(target, table.remove(deck, 1))
    end

	discardOne = {}
	discardTwo = {}
    takeCard(discardOne)
	takeCard(discardTwo)

	handPlayerOne = {}
	handPlayerTwo = {}

	playerTurn = true
    playerActionCompleted = false
	playerDrawingCards = false
end

function shuffleDeck(deck)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function love.keypressed(key)
    if playerTurn and not playerActionCompleted then
        if key == 'q' and #discardOne > 0 then
            -- Take the first discard pile card
            table.insert(handPlayerOne, table.remove(discardOne, #discardOne))
            playerActionCompleted = true
        elseif key == 'd' and #discardTwo > 0 then
            -- Take the second discard pile card
            table.insert(handPlayerOne, table.remove(discardTwo, #discardTwo))
            playerActionCompleted = true
        elseif key == 'z' then
            -- Draw two cards from the deck
            takeCard(handPlayerOne)
            takeCard(handPlayerOne)
            playerActionCompleted = true
        end
    end

    if playerActionCompleted then
        -- Pass the turn to the next phase
        playerTurn = false
        playerActionCompleted = false

        -- For simplicity, the opponent doesn't make decisions yet
        takeCard(handPlayerTwo)
        takeCard(handPlayerTwo)

        -- Back to Player One's turn
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
        table.insert(output, '\nIt\'s your turn!')
        table.insert(output, 'Press q to take the top card from Discard n°1.')
        table.insert(output, 'Press d to take the top card from Discard n°2.')
        table.insert(output, 'Press z to draw two cards from the deck.')
    else
        table.insert(output, '\nOpponent is playing...')
    end

    -- Draw the output text on the screen
    love.graphics.print(table.concat(output, '\n'), 15, 15)
end
