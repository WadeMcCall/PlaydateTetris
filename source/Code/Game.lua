import "CoreLibs/graphics"
import "CoreLibs/object"
import "Code/UIBox"

local gfx <const> = playdate.graphics

class("Game").extends()

function Game:loadBackground() 
    local backgroundImage = gfx.image.new( "sprites/board mockup" )
    assert( backgroundImage )

    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            gfx.setClipRect( x, y, width, height ) -- let's only draw the part of the screen that's dirty
            backgroundImage:draw( 0, 0 )
            gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
        end
    )
end

function Game:setUpGame()
    self:loadBackground()
end

function Game:init()
    self.BoundingX1 = 10
    self.BoundingX2 = 200
    self.Bottom = 235
    self.score = 0
    self.speed = 1
    self.CrankMeter = 0
    self.lines = 0
    self.scores = {
        ScoreBox = UIBox(336, 56, self.score),
        SpeedBox = UIBox(336, 120, self.speed),
        LinesBox = UIBox(336, 184, self.lines)
    }

    self:setUpGame()
end

function Game:update()
    playdate.drawFPS(0, 0)
end