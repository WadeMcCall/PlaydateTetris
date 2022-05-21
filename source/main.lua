import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Code/Game"

local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO

local game = nil

local function loadGame()
	game = Game()
	gfx.setFont(font) -- DEMO
end

local function updateGame()
	gfx.sprite.update()
	game:update()
end

math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
loadGame()

function playdate.update()
	updateGame()
    playdate.timer.updateTimers()
end