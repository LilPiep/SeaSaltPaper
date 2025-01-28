-- Definition of card types and their quantities in the deck
local cardDefinitions = require("cards")
-- Import the functions related to the deck 
local functions = require("deckFunctions")

function init()
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

return init
