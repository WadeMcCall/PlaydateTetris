import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/easing"

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
    self.anim = nil
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
    self.endYPosition = y + 16 * linesToFall
    self:CreateFallAnimation()
end

function Tetrimino:CreateFallAnimation()
    local x1, y1 = self:getPosition()
    local lineSegment = playdate.geometry.lineSegment.new(x1, y1, x1, self.endYPosition)
    local animationSpeed = 300 - (Game.speed * 8)
    self.anim = gfx.animator.new(animationSpeed, lineSegment, playdate.easingFunctions.inOutCubic, 216 * (animationSpeed / 500) - y1)
    self:setAnimator(self.anim)
end