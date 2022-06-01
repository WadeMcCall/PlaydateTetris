import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

class("Tetrimino").extends(gfx.sprite)

function Tetrimino:init(x, y, spriteName)
    Tetrimino.super.init(self)
    self.offsetX = x or 0
    self.offsetY = y or 0
    
    self.image = gfx.image.new("sprites/" .. spriteName)
    self:setImage( self.image )
    self:moveTo(self.offsetX, self.offsetY)
    self:setCollideRect( 0, 0, self:getSize() )
    self:add()
    self.collisionResponse = "overlap"
    self:setGroups(1)
end

function Tetrimino:MoveTo(x, y)
    self:moveTo(x + self.offsetX, y + self.offsetY)
end

function Tetrimino:MoveToCheckCollisions(x, y)
    local actualX, actualY, collisions, length = self:checkCollisions(x + self.offsetX, y + self.offsetY)
    if  length > 0 then return false end
    return true
end

function Tetrimino:fall(linesToFall)
    local x, y = self:getPosition()
    self:moveTo(x, y + 16 * linesToFall) 
end