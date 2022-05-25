import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/timer"
import "Code/UIBox"
import "Code/Block"

local gfx <const> = playdate.graphics

class("Game").extends()

function Game:loadBackground() 
    -- local backgroundImage = gfx.image.new( "sprites/board mockup" )
    -- assert( backgroundImage )
    -- 
    -- gfx.sprite.setBackgroundDrawingCallback(
    --     function( x, y, width, height )
    --         gfx.setClipRect( x, y, width, height ) -- let's only draw the part of the screen that's dirty
    --         backgroundImage:draw( 0, 0 )
    --         gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
    --     end
    -- )

    local scoreBoard = gfx.image.new("sprites/ScoreboardNew")
    local nextBlockSide = gfx.image.new("sprites/NextBlockSide")

    local nextBlockSprite = gfx.sprite.new(nextBlockSide)
    nextBlockSprite:setZIndex(-10)
    local scoreBoardSprite = gfx.sprite.new(scoreBoard)
    scoreBoardSprite:setZIndex(-10)

    nextBlockSprite:moveTo(40,120)
    scoreBoardSprite:moveTo(320, 120)
    nextBlockSprite:add()
    scoreBoardSprite:add()

    nextBlockSprite:setCollideRect(0, 0, 80, 240)
    scoreBoardSprite:setCollideRect(240, 0, 164, 240)

    gfx.sprite.addEmptyCollisionSprite(0, 0, 80, 240)
    gfx.sprite.addEmptyCollisionSprite(240, 0, 164, 240)
    gfx.sprite.addEmptyCollisionSprite(0, 240, 300, 10)
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

function Game:RemoveLineSprites(sprites)
    for k, tetrimino in pairs(sprites) do
        -- TODO play an animation 
        local x, y = tetrimino:getPosition()
        tetrimino:remove()
        tetrimino = nil
    end
end

function Game:checkLine(sprites)
    local count = 0
    for tetrimino in pairs(sprites) do
        count = count + 1
    end
    if count < 10 then return false end
    self:RemoveLineSprites(sprites)
    return true
end

function Game:LineFall(sprites, numLines)
    for k, sprite in pairs(sprites) do
        local x, y = sprite:getPosition()
        sprite:moveTo(x, y + 16 * numLines)
    end
end

function Game:resetGame()
    for k,v in pairs(self.placedTetriminos) do
        v.sprite:remove()
    end

    self:setScore(0)
    self:setLines(0)
    self:setSpeed(1)
end

function Game:checkForLines() 
    local numLines = 0
    local lines = {}

    for i=1, 16 do
        local sprites = gfx.sprite.querySpritesAlongLine(88, 232 - ((i - 1) * 16), 232, 232 - ((i - 1) * 16))
        if(self:checkLine(sprites)) then
            numLines = numLines + 1
            table.insert(lines, i)
        end
    end

    if numLines > 0 then 
        self:setLines(self.lines + numLines)
    end

    if(numLines == 1) then self:setScore(self.score + 100) end
    if(numLines == 2) then self:setScore(self.score + 300) end
    if(numLines == 3) then self:setScore(self.score + 600) end
    if(numLines == 4) then self:setScore(self.score + 1000) end

    if self.score > self.maxScore then self:setMaxScore(self.score) end

    if(self.lines/10 > self.speed) then self:setSpeed(math.floor((self.lines/10) + 1)) end

    local distanceDown = 0
    for i=1, 16 do -- lines
        local sprites = gfx.sprite.querySpritesAlongLine(88, 232 - ((i - 1) * 16), 232, 232 - ((i - 1) * 16))
        for k,v in pairs(lines) do
            if i == v then distanceDown = distanceDown + 1 end
        end 
        self:LineFall(sprites, distanceDown)
    end
end

function Game:placeBlock()
    self.currentBlock:resetCollideGroups()
    local newMinos = self.currentBlock:getAllTetriminos()
    for k, mino in pairs(newMinos) do
        table.insert(self.placedTetriminos, mino)
    end
    self:checkForLines()
    self:newCurrentBlock()
end

function Game:newCurrentBlock()
    self.currentBlock = self.nextBlock
    self.currentBlock:MoveTo(160, 16)
    if not self.currentBlock:MoveToCheckCollisions(160, 16) then self:resetGame() end
    self:setNextBlock()
end

function Game:moveDown()
	if(self.currentBlock == nil) then return end
    return self.currentBlock:MoveToCheckCollisions(self.currentBlock.position.x, self.currentBlock.position.y + 16)
end

function Game:moveLeft()
	if(self.currentBlock == nil) then return end
    self.currentBlock:MoveToCheckCollisions(self.currentBlock.position.x - 16, self.currentBlock.position.y)
end

function Game:moveRight()
	if(self.currentBlock == nil) then return end
    self.currentBlock:MoveToCheckCollisions(self.currentBlock.position.x + 16, self.currentBlock.position.y)
end

function Game:getStepDuration() 
    if(self.downPressed and self.speed < 15) then return (500)/math.sqrt(15) end
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

function Game:setMaxScore(score)
    self.maxScore = score
    self.scores.MaxScoreBox:setText(score)
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
    self.downPressed = false
    self.BoundingX1 = 10
    self.BoundingX2 = 200
    self.Bottom = 235
    self.score = 0
    self.maxScore = 0
    self.speed = 1
    self.CrankMeter = 0
    self.lines = 0
    self.scores = {
        ScoreBox = UIBox(336, 52, self.score),
        LinesBox = UIBox(336, 108, self.lines),
        SpeedBox = UIBox(336, 160, self.speed),
        MaxScoreBox = UIBox(336, 214, self.maxScore)
    }

    self.placedTetriminos = {}

    self.stepTimer = nil
    self.currentBlock = nil
    self.nextBlock = nil

    self:setUpGame()
end

function Game:update()
    playdate.drawFPS(0, 0)
end