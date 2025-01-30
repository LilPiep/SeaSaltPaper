-- Import the functions related to the deck 
local functions = require("deckFunctions")

-- Display a discard
local function displayDiscard(discard, output)
	if #discard > 0 then
		local topCard = discard[#discard]
		table.insert(output, ' - type: ' .. topCard.type .. ', color: ' .. topCard.color .. ', nature: ' .. topCard.nature)
	else
		table.insert(output, 'No cards in this discard')
	end
end

function textualInterface()
	love.window.setTitle("Sea Salt Paper")

	if deckEmpty then
		love.graphics.print("Game over! The deck is empty. Nobody wins.", 15, 15)
		return
	end
	
	local output = {}
	
	-- Display discard pile 1
	table.insert(output, 'Discard n°1:')
	displayDiscard(discardOne, output)
	
	-- Display discard pile 2
	table.insert(output, '\nDiscard n°2:')
	displayDiscard(discardTwo, output)
	
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

	-- In case the player played a Crab Duo
	if choosingCrabCard and selectedDiscard then
		love.graphics.print("Choose a card:", 100, 100)
		for i, card in ipairs(selectedDiscard) do
			love.graphics.print(i .. ". " .. card.type .. " (" .. card.color .. ")", 100, 120 + (i * 20))
		end
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

return textualInterface
