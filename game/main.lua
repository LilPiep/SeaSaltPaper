function love.load()
    -- Definition of card types and their quantities in the deck
    local cardDefinitions = {
        -- Duo cards
		{type = "crab", count = 9},         -- 9 "Crab" cards
		{type = "boat", count = 8},         -- 8 "Boat" cards
		{type = "fish", count = 7},         -- and so on
        {type = "swimmer", count = 5},
        {type = "shark", count = 5},
		{type = "mermaid", count = 4},
		-- Collector cards
        {type = "shell", count = 6},
		{type = "octopus", count = 5},
		{type = "penguin", count = 3},
		{type = "sailor", count = 2},
		-- Point Multiplier cards
		{type = "lighthouse", count = 1},
		{type = "shoal", count = 1},
		{type = "colony", count = 1},
		{type = "captain", count = 1}
    }

    deck = {}

    -- Initialize the deck
    for _, cardDef in ipairs(cardDefinitions) do
        for i = 1, cardDef.count do
            table.insert(deck, {type = cardDef.type})
        end
    end

    -- Shuffle the deck
    shuffleDeck(deck)
    -- Temporary display to verify deck content
    for i, card in ipairs(deck) do
        print('Card #'..i..': '..card.type)
    end
    print('Total number of cards in deck: '..#deck)
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
	love.graphics.print("Hello World!", 400, 300)
end
