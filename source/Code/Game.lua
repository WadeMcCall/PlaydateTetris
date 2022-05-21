import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/timer"
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

function Game:getStepDuration() 
    return (500)/math.sqrt(self.speed)
end

function Game:stepTimer()
    function step()
        self:swapColors()
    end
    self.stepTimer = playdate.timer.performAfterDelay(self:getStepDuration(), step)
end

function Game:swapColors()
	if (gfx.getBackgroundColor() == gfx.kColorWhite) then
		gfx.setBackgroundColor(gfx.kColorBlack)
		gfx.setImageDrawMode("inverted")
	else
		gfx.setBackgroundColor(gfx.kColorWhite)
		gfx.setImageDrawMode("copy")
	end
end

function Game:setUpGame()
    self:stepTimer()
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

    self.stepTimer = nil

    self:setUpGame()
end

function Game:update()
    playdate.drawFPS(0, 0)
end