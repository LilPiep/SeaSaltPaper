-- Import the functions related to the deck 
local functions = require("deckFunctions")

-- Import the init function
local init = require("init")

-- Import the textual interface
local textualInterface = require("textualInterface")

-- Import the keyboard interaction
local interactions = require("interactions")

-- global variables
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
selectedCardIndex = 1
choosingCrabDiscard = false
choosingCrabCard = false
selectedDiscard = nil


function love.load()
	init()
end

function love.keypressed(key)
    interactions(key)
end

function love.update()
    if deckEmpty then
        -- Stop the game and display a message
        return
    end
	canPlayDuo = functions.checkDuoPlayable(handPlayerOne)
end

function love.draw()
	textualInterface()
end
