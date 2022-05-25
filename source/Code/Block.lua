import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Code/Tetrimino"

local gfx <const> = playdate.graphics

-- Super class
class("Block").extends()

function Block:init(_x, _y, tetriminoSpriteName)
    self.globalOffsetx = 0
    self.globalOffsety = 0
    self.angleOffsetsx = {}
    self.angleOffsetsy = {}
    self.position = {x = _x or 0, y = _y or 0}
    self.tetriminos = {}
    self.angle = 0
    for i = 1, 4 do
        self.tetriminos[i] = Tetrimino(0, 0, tetriminoSpriteName)
    end
end

function Block:getAllTetriminos()
    return self.tetriminos
end

function Block:resetCollideGroups()
    for i = 1, 4 do
        self.tetriminos[i]:ResetCollideGroups(group)
    end
end

function Block:MoveTo(x, y)
    self.position = {x = x, y = y}
    for i = 1, 4 do
        self.tetriminos[i]:MoveTo(self.position.x + self.globalOffsetx, self.position.y + self.globalOffsety)
    end
end

function Block:MoveToCheckCollisions(x, y)
    for i = 1, 4 do
        local success = self.tetriminos[i]:MoveToCheckCollisions(x + self.globalOffsetx, y + self.globalOffsety)
        if not success then 
            return false
        end
    end
    self:MoveTo(x, y)
    return true
end

function Block:IsAboveFloor()
    for i = 1, 4 do
        if (self.position.y + self.tetriminos[i].offsetY + 10) > 240 then return true end
    end
    return false
end

-- We are rotating about a point which is not always the center of the block. On such blocks, after a certain amount of rotations, it becomes offset. We fix that here.
--      __
--     |  |
--   → |‾‾|    The pivot point of our I block is between the arrows, so it needs to correct after a few spins
--   → |‾‾|
--     |‾‾|
--      ‾‾
function Block:Rotate(left)
    local success = true
    if(left) then
        self.angle -= 1
        if (self.angle < 0) then self.angle = 3 end
        for i = 1, 4 do
            local previousx = self.tetriminos[i].offsetX
            local previousy = self.tetriminos[i].offsetY
            self.tetriminos[i].offsetX = -previousy
            self.tetriminos[i].offsetY = previousx
        end
    else 
        self.angle += 1
        if (self.angle >= 4) then self.angle = 0 end
        for i = 1, 4 do
            local previousx = self.tetriminos[i].offsetX
            local previousy = self.tetriminos[i].offsetY
            self.tetriminos[i].offsetX = previousy
            self.tetriminos[i].offsetY = -previousx
        end
    end

    -- See block comment above for offsets and angle reasoning
    if(self.angleOffsetsx[self.angle] ~= nil) then 
        self.globalOffsetx = self.angleOffsetsx[self.angle] 
    else
        self.globalOffsetx = 0
    end
    if(self.angleOffsetsy[self.angle] ~= nil) then 
        self.globalOffsety = self.angleOffsetsy[self.angle] 
    else
        self.globalOffsety = 0
    end
    -- -- first, we see if the rotation works as is. If so, we're done
    if self:MoveToCheckCollisions(self.position.x, self.position.y) then 
        return
    end
    -- try the same rotation to the right
    if self:MoveToCheckCollisions(self.position.x + 16, self.position.y) then 
        return
    end

    if self:isa(IBlock) then
        -- try the same rotation to the right again for I blocks.
        if self:MoveToCheckCollisions(self.position.x + 32, self.position.y) then 
            return
        end
    end
    -- try the same rotation to the left
    if self:MoveToCheckCollisions(self.position.x - 16, self.position.y) then 
        return
    end
    -- try the same rotation up
    if self:MoveToCheckCollisions(self.position.x, self.position.y - 16) then 
        return
    end
    -- at this point, no moving the block has worked so we need to undo the rotation
    self:Rotate(not left)
end

----------
-- T Block
----------
class("TBlock").extends("Block")

function TBlock:init(_x, _y)
    TBlock.super.init(self, _x, _y, "tBlockSquare")
    self.angleOffsetsx[1] = 16
    self.angleOffsetsx[2] = 16
    self.angleOffsetsy[3] = -16
    self:setTetriminoOffsetDefaults()
end

function TBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetX = -8
    self.tetriminos[2].offsetX = 8
    self.tetriminos[3].offsetX = 24
    self.tetriminos[1].offsetY = -8
    self.tetriminos[2].offsetY = -8
    self.tetriminos[3].offsetY = -8
    self.tetriminos[4].offsetX = 8
    self.tetriminos[4].offsetY = 8
end

----------
-- I Block
----------
class("IBlock").extends("Block")

function IBlock:init(_x, _y)
    IBlock.super.init(self, _x, _y, "iBlockSquare")
    self.angleOffsetsx[2] = 16
    self.angleOffsetsy[3] = -16
    self:setTetriminoOffsetDefaults()
end

function IBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetX = 8
    self.tetriminos[2].offsetX = 8
    self.tetriminos[3].offsetX = 8
    self.tetriminos[4].offsetX = 8
    self.tetriminos[1].offsetY = -24
    self.tetriminos[2].offsetY = -8
    self.tetriminos[3].offsetY = 8
    self.tetriminos[4].offsetY = 24
end
----------
-- L Block
----------
class("LBlock").extends("Block")

function LBlock:init(_x, _y)
    LBlock.super.init(self, _x, _y, "LBlockSquare")
    self.angleOffsetsx[3] = 16
    self:setTetriminoOffsetDefaults()
end

function LBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -8
    self.tetriminos[1].offsetX = -8
    self.tetriminos[2].offsetY = 8
    self.tetriminos[2].offsetX = -8
    self.tetriminos[3].offsetY = 24
    self.tetriminos[3].offsetX = -8
    self.tetriminos[4].offsetX = 8
    self.tetriminos[4].offsetY = 24
end

------------------
-- Reverse L Block
------------------
class("ReverseLBlock").extends("Block")

function ReverseLBlock:init(_x, _y)
    ReverseLBlock.super.init(self, _x, _y, "reverseLBlockSquare")
    self.angleOffsetsx[3] = 16
    self:setTetriminoOffsetDefaults()
end

function ReverseLBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -8
    self.tetriminos[1].offsetX = 8
    self.tetriminos[2].offsetY = 8
    self.tetriminos[2].offsetX = 8
    self.tetriminos[3].offsetY = 24
    self.tetriminos[3].offsetX = 8
    self.tetriminos[4].offsetX = -8
    self.tetriminos[4].offsetY = 24
end

----------
-- S Block
----------
class("SBlock").extends("Block")

function SBlock:init(_x, _y)
    SBlock.super.init(self, _x, _y, "sBlockSquare")
    self.angleOffsetsx[2] = 16
    self.angleOffsetsy[3] = -16
    self:setTetriminoOffsetDefaults()
end

function SBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -8
    self.tetriminos[1].offsetX = 8
    self.tetriminos[2].offsetY = 8
    self.tetriminos[2].offsetX = 8
    self.tetriminos[3].offsetY = 8
    self.tetriminos[3].offsetX = -8
    self.tetriminos[4].offsetY = -8
    self.tetriminos[4].offsetX = 24
end

---------------
-- Square Block
---------------
class("SquareBlock").extends("Block")

function SquareBlock:init(_x, _y)
    SquareBlock.super.init(self, _x, _y, "SquareBlockSquare")
    self:setTetriminoOffsetDefaults()
end

function SquareBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetX = 8
    self.tetriminos[1].offsetY = 8
    self.tetriminos[2].offsetY = 8
    self.tetriminos[2].offsetX = -8
    self.tetriminos[3].offsetX = 8
    self.tetriminos[3].offsetY = -8
    self.tetriminos[4].offsetX = -8
    self.tetriminos[4].offsetY = -8
end

----------
-- Z Block
----------
class("ZBlock").extends("Block")

function ZBlock:init(_x, _y)
    ZBlock.super.init(self, _x, _y, "zBlockSquare")
    self.angleOffsetsx[2] = 16
    self.angleOffsetsy[3] = -16
    self:setTetriminoOffsetDefaults()
end

function ZBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -8
    self.tetriminos[1].offsetX = 8
    self.tetriminos[2].offsetY = 8
    self.tetriminos[2].offsetX = 8
    self.tetriminos[3].offsetY = 8
    self.tetriminos[3].offsetX = 24
    self.tetriminos[4].offsetX = -8
    self.tetriminos[4].offsetY = -8
end