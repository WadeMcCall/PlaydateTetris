import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Code/Game"

local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO

local function loadGame()
	gfx.setFont(font) -- DEMO
	Game:init()
end

local function updateGame()
	gfx.sprite.update()
	Game:update()
end

math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
loadGame()

function playdate.AButtonDown()
	if(Game.currentBlock == nil) then return end
    Game.currentBlock:Rotate()
end

function playdate.BButtonDown()
	if(Game.currentBlock == nil) then return end
    Game.currentBlock:Rotate(true)
end  

function playdate.leftButtonDown()
	Game:moveLeft()
end

function playdate.downButtonDown()
	Game.downPressed = true
end

function playdate.downButtonUp()
	Game.downPressed = false
end

function playdate.rightButtonDown()
	Game:moveRight()
end

function playdate.update()
	updateGame()
    playdate.timer.updateTimers()
end