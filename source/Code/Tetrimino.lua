import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

class("Tetrimino").extends()

function Tetrimino:init(x, y)
    self.offsetX = x or 0
    self.offsetY = y or 0
    
    self.image = gfx.image.new("sprites/singleBlock")
    self.sprite = gfx.sprite.new( self.image )
    self.sprite:moveTo(self.offsetX, self.offsetY)
    self.sprite:add()
end

function Tetrimino:MoveTo(x, y)
    self.sprite:moveTo(x + self.offsetX, y + self.offsetY)
end