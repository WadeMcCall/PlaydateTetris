local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO

local sprite = nil

local function loadSprites() 
	local spriteImage = gfx.image.new("sprites/zBlock")
	sprite = gfx.sprite.new(spriteImage)
	sprite:moveTo(10,10)
	sprite:add()
end

local function loadGame()
	loadSprites()
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font) -- DEMO
end

local function updateGame()
	gfx.sprite.update()
end

loadGame()

function playdate.update()
	gfx.sprite.update()
end