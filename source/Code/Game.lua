import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/timer"
import "Code/UIBox"
import "Code/Block"

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

function Game:setNextBlock()
    local num = math.random(7)

    -- Switch blocks are not a thing in lua so I am stringing ifs together...
    local xSpawnOffset = 0
    local ySpawnOffset = 0

    if(num == 1) then          -- I block
        xSpawnOffset = -8
        self.nextBlock = IBlock()
    elseif (num == 2) then     -- L block
        self.nextBlock = LBlock()
        ySpawnOffset = -8
    elseif (num == 3) then     -- S block
        self.nextBlock = SBlock()
        xSpawnOffset = -8
    elseif (num == 4) then     -- Square block
        self.nextBlock = SquareBlock()
    elseif (num == 5) then     -- T block
        self.nextBlock = TBlock()
        xSpawnOffset = -8
    elseif (num == 6) then     -- Z Block
        self.nextBlock = ZBlock()  
        xSpawnOffset = -8
    elseif (num == 7) then     -- Reverse L Block
        self.nextBlock = ReverseLBlock()
        ySpawnOffset = -8
    end

    self.nextBlock:MoveTo(40 + xSpawnOffset, 80 + ySpawnOffset)
end

function Game:placeBlock()
    -- TODO check if there are any lines and do the logic for that

    self:newCurrentBlock()
end

function Game:newCurrentBlock()
    self.currentBlock = self.nextBlock
    self.currentBlock:MoveTo(160, 16)
    self:setNextBlock()
end

function Game:moveDown()
	if(self.currentBlock == nil) then return end
    if (self.currentBlock:IsAboveFloor()) then return false end
    -- TODO collide with other placed blocks
    self.currentBlock:MoveTo(self.currentBlock.position.x, self.currentBlock.position.y + 16)
    return true
end

function Game:moveLeft()
	if(self.currentBlock == nil) then return end
    self.currentBlock:MoveTo(self.currentBlock.position.x - 16, self.currentBlock.position.y)
end

function Game:moveRight()
	if(self.currentBlock == nil) then return end
    self.currentBlock:MoveTo(self.currentBlock.position.x + 16, self.currentBlock.position.y)
end

function Game:getStepDuration() 
    return (500)/math.sqrt(self.speed)
end

function Game:setStepTimer()
    function step()
        if(self.nextBlock == nil) then self:setNextBlock() end
        if(self.currentBlock == nil) then
            self:newCurrentBlock() 
        else
            if not self:moveDown() then self:placeBlock() end
        end

        self:setStepTimer()
    end
    self.stepTimer = playdate.timer.performAfterDelay(self:getStepDuration(), step)
end

function Game:setScore(score)
    self.score = score
    self.scores.ScoreBox:setText(self.score)
end

function Game:setSpeed(speed)
    self.speed = speed
    self.scores.SpeedBox:setText(self.speed)
end

function Game:setLines(lines)
    self.lines = lines
    self.scores.LinesBox:setText(self.lines)
end

function Game:setUpGame()
    self:setStepTimer()
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
        LinesBox = UIBox(336, 120, self.lines),
        SpeedBox = UIBox(336, 184, self.speed)
    }

    self.stepTimer = nil
    self.currentBlock = nil
    self.nextBlock = nil

    self:setUpGame()
end

function Game:update()
    playdate.drawFPS(0, 0)
end