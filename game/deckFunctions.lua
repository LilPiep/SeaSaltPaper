local functions = {}

-- Shuffles the deck before playing a game
function functions.shuffleDeck(deck)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

-- Takes a card from the deck and add it to a target
function functions.takeCard(target)
	if #deck > 0 then
        table.insert(target, table.remove(deck, 1))
        if #deck == 0 then
            deckEmpty = true
        end
    end
end

-- Takes a card from a table and add it to a target 
function functions.takeCardFrom(target, from)
	table.insert(target, table.remove(from, 1))
end

function functions.checkDuoPlayable(hand)
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

function functions.playDuoCards(hand, mat, typeToPlay)
    local cardsPlayed = 0
	local isCrabDuo = (typeToPlay == "crab")
	local isFishDuo = (typeToPlay == "fish")
	local isBoatDuo = (typeToPlay == "boat")
    for i = #hand, 1, -1 do
        if hand[i].nature == "duo" and hand[i].type == typeToPlay then
            table.insert(mat, table.remove(hand, i))
            cardsPlayed = cardsPlayed + 1
            if cardsPlayed == 2 then
                break
            end
        end
    end
	return isCrabDuo, isBoatDuo, isFishDuo
end

function functions.getTotal(hand)
	local total = 0
    --[[
	-- Points related to duos
    -- Points related to collections
    -- Points related to colors
    ]]
	return total
end

return functions
