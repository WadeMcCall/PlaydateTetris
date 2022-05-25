import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Code/Game"

local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO

local game = nil

local function loadGame()
	gfx.setFont(font) -- DEMO
	game = Game()
end

local function updateGame()
	gfx.sprite.update()
	game:update()
end

math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
loadGame()

function playdate.AButtonDown()
	if(game.currentBlock == nil) then return end
    game.currentBlock:Rotate()
end

function playdate.BButtonDown()
	if(game.currentBlock == nil) then return end
    game.currentBlock:Rotate(true)
end  

function playdate.leftButtonDown()
	game:moveLeft()
end

function playdate.downButtonDown()
	game.downPressed = true
end

function playdate.downButtonUp()
	game.downPressed = false
end

function playdate.rightButtonDown()
	game:moveRight()
end

function playdate.update()
	updateGame()
    playdate.timer.updateTimers()
end