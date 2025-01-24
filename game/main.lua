function love.load()
	-- Set random seed based on current time for true randomness
    math.randomseed(os.time())

    -- Definition of card types and their quantities in the deck
    local cardDefinitions = {
        -- Duo cards
		-- Crabs
		{type = "crab", count = 2, color = "dark blue", nature = "duo"},
		{type = "crab", count = 2, color = "light blue", nature = "duo"},
		{type = "crab", count = 2, color = "yellow", nature = "duo"},
		{type = "crab", count = 1, color = "gray", nature = "duo"},
		{type = "crab", count = 1, color = "green", nature = "duo"},
		{type = "crab", count = 1, color = "black", nature = "duo"},
		-- Boats
		{type = "boat", count = 2, color = "dark blue", nature = "duo"},
		{type = "boat", count = 2, color = "light blue", nature = "duo"},
		{type = "boat", count = 2, color = "yellow", nature = "duo"},
		{type = "boat", count = 2, color = "black", nature = "duo"},
		-- Fishes
		{type = "fish", count = 2, color = "dark blue", nature = "duo"},
		{type = "fish", count = 2, color = "black", nature = "duo"},
		{type = "fish", count = 1, color = "light blue", nature = "duo"},
		{type = "fish", count = 1, color = "yellow", nature = "duo"},
		{type = "fish", count = 1, color = "green", nature = "duo"},
		-- Swimmers
        {type = "swimmer", count = 1, color = "dark blue", nature = "duo"},
		{type = "swimmer", count = 1, color = "light blue", nature = "duo"},
		{type = "swimmer", count = 1, color = "yellow", nature = "duo"},
		{type = "swimmer", count = 1, color = "black", nature = "duo"},
		{type = "swimmer", count = 1, color = "orange", nature = "duo"},
		-- Sharks
        {type = "shark", count = 1, color = "dark blue", nature = "duo"},
		{type = "shark", count = 1, color = "light blue", nature = "duo"},
		{type = "shark", count = 1, color = "black", nature = "duo"},
		{type = "shark", count = 1, color = "purple", nature = "duo"},
		{type = "shark", count = 1, color = "green", nature = "duo"},
		-- Mermaids
		{type = "mermaid", count = 4, color = "white", nature = "duo"},
		-- Collector cards
		-- Shells
        {type = "shell", count = 1, color = "dark blue", nature = "collection"},
		{type = "shell", count = 1, color = "light blue", nature = "collection"},
		{type = "shell", count = 1, color = "green", nature = "collection"},
		{type = "shell", count = 1, color = "gray", nature = "collection"},
		{type = "shell", count = 1, color = "black", nature = "collection"},
		{type = "shell", count = 1, color = "yellow", nature = "collection"},
		-- Octopuses
		{type = "octopus", count = 1, color = "light blue", nature = "collection"},
		{type = "octopus", count = 1, color = "purple", nature = "collection"},
		{type = "octopus", count = 1, color = "gray", nature = "collection"},
		{type = "octopus", count = 1, color = "green", nature = "collection"},
		{type = "octopus", count = 1, color = "yellow", nature = "collection"},
		-- Penguins
		{type = "penguin", count = 1, color = "purple", nature = "collection"},
		{type = "penguin", count = 1, color = "pink", nature = "collection"},
		{type = "penguin", count = 1, color = "orange", nature = "collection"},
		-- Sailors
		{type = "sailor", count = 1, color = "ocre", nature = "collection"},
		{type = "sailor", count = 1, color = "pink", nature = "collection"},
		-- Point Multiplier cards
		{type = "lighthouse", count = 1, color = "purple", nature = "mult"},
		{type = "shoal", count = 1, color = "gray", nature = "mult"},
		{type = "colony", count = 1, color = "green", nature = "mult"},
		{type = "captain", count = 1, color = "orange", nature = "mult"},
    }

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
