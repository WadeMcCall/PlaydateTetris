import "CoreLibs/graphics"
import "CoreLibs/object"
import "Code/UIBox"

local gfx <const> = playdate.graphics
local scores = nil

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

function Game:drawScores()
    gfx.drawTextInRect(tostring(self.score), scores.ScoreBox.x, scores.ScoreBox.y, scores.ScoreBox.width, scores.ScoreBox.height)
    gfx.drawTextInRect(tostring(self.speed), scores.SpeedBox.x, scores.SpeedBox.y, scores.SpeedBox.width, scores.SpeedBox.height)
    gfx.drawTextInRect(tostring(self.lines), scores.LinesBox.x, scores.LinesBox.y, scores.LinesBox.width, scores.LinesBox.height)

    return true
end

function Game:setUpGame()
    self:loadBackground()
    scores = {
        ScoreBox = UIBox(268, 42),
        SpeedBox = UIBox(268, 106),
        LinesBox = UIBox(268, 170),
    }
    self:drawScores()
end

function Game:init()
    self.BoundingX1 = 10
    self.BoundingX2 = 200
    self.Bottom = 235
    self.score = 0
    self.speed = 1
    self.CrankMeter = 0
    self.lines = 0

    self:setUpGame()
end

function Game:update()
    playdate.drawFPS(0, 0)
    self:drawScores()
end