import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

class("Tetrimino").extends()

function Tetrimino:init(x, y, spriteName)
    self.offsetX = x or 0
    self.offsetY = y or 0
    
    self.image = gfx.image.new("sprites/" .. spriteName)
    self.sprite = gfx.sprite.new( self.image )
    self.sprite:moveTo(self.offsetX, self.offsetY)
    self.sprite:setCollideRect( 0, 0, self.sprite:getSize() )
    self.sprite:add()
end

function Tetrimino:MoveTo(x, y)
    self.sprite:moveTo(x + self.offsetX, y + self.offsetY)
end

