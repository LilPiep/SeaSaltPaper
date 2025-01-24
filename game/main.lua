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
    table.insert(discardOne, table.remove(deck, 1))
    table.insert(discardTwo, table.remove(deck, 1))
end

function shuffleDeck(deck)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
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

    -- Draw the output text on the screen
    love.graphics.print(table.concat(output, '\n'), 15, 15)
end
