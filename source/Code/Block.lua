import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Code/Tetrimino"

local gfx <const> = playdate.graphics

-- Super class
class("Block").extends()

function Block:init(_x, _y)
    self.position = {x = _x or 0, y = _y or 0}
    self.tetriminos = {}
    for i = 1, 4 do
        self.tetriminos[i] = Tetrimino(0, 0)
    end
end

function Block:MoveTo(x, y)
    self.position = {x = x, y = y}
    for i = 1, 4 do
        self.tetriminos[i]:MoveTo(self.position.x, self.position.y)
    end
end

function Block:Rotate(left)
    if(left) then
        for i = 1, 4 do
            local previousx = self.tetriminos[i].offsetX
            local previousy = self.tetriminos[i].offsetY
            self.tetriminos[i].offsetX = -previousy
            self.tetriminos[i].offsetY = previousx
        end
    else 
        for i = 1, 4 do
            local previousx = self.tetriminos[i].offsetX
            local previousy = self.tetriminos[i].offsetY
            self.tetriminos[i].offsetX = previousy
            self.tetriminos[i].offsetY = -previousx
        end
    end
    self:MoveTo(self.position.x, self.position.y)
end

function Block:update()
    
end

----------
-- T Block
----------
class("TBlock").extends("Block")

function TBlock:init(_x, _y)
    TBlock.super.init(self, _x, _y)

    self:setTetriminoOffsetDefaults()
end

function TBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetX = -15
    self.tetriminos[3].offsetX = 15
    self.tetriminos[4].offsetY = 15
end

----------
-- I Block
----------
class("IBlock").extends("Block")

function IBlock:init(_x, _y)
    IBlock.super.init(self, _x, _y)
    self:setTetriminoOffsetDefaults()
end

function IBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -22.5
    self.tetriminos[2].offsetY = -7.5
    self.tetriminos[3].offsetY = 7.5
    self.tetriminos[4].offsetY = 22.5
end

----------
-- L Block
----------
class("LBlock").extends("Block")

function LBlock:init(_x, _y)
    LBlock.super.init(self, _x, _y)
    self:setTetriminoOffsetDefaults()
end

function LBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -15
    self.tetriminos[3].offsetY = 15
    self.tetriminos[4].offsetX = 15
    self.tetriminos[4].offsetY = 15
end

------------------
-- Reverse L Block
------------------
class("ReverseLBlock").extends("Block")

function ReverseLBlock:init(_x, _y)
    ReverseLBlock.super.init(self, _x, _y)
    self:setTetriminoOffsetDefaults()
end

function ReverseLBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -15
    self.tetriminos[3].offsetY = 15
    self.tetriminos[4].offsetX = -15
    self.tetriminos[4].offsetY = 15
end

----------
-- S Block
----------
class("SBlock").extends("Block")

function SBlock:init(_x, _y)
    SBlock.super.init(self, _x, _y)
    self:setTetriminoOffsetDefaults()
end

function SBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -7.5
    self.tetriminos[2].offsetY = 7.5
    self.tetriminos[3].offsetY = 7.5
    self.tetriminos[3].offsetX = -15
    self.tetriminos[4].offsetY = -7.5
    self.tetriminos[4].offsetX = 15
end

---------------
-- Square Block
---------------
class("SquareBlock").extends("Block")

function SquareBlock:init(_x, _y)
    SquareBlock.super.init(self, _x, _y)
    self:setTetriminoOffsetDefaults()
end

function SquareBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetX = 7.5
    self.tetriminos[1].offsetY = 7.5
    self.tetriminos[2].offsetY = 7.5
    self.tetriminos[2].offsetX = -7.5
    self.tetriminos[3].offsetX = 7.5
    self.tetriminos[3].offsetY = -7.5
    self.tetriminos[4].offsetX = -7.5
    self.tetriminos[4].offsetY = -7.5
end

----------
-- Z Block
----------
class("ZBlock").extends("Block")

function ZBlock:init(_x, _y)
    ZBlock.super.init(self, _x, _y)
    self:setTetriminoOffsetDefaults()
end

function ZBlock:setTetriminoOffsetDefaults()
    self.tetriminos[1].offsetY = -7.5
    self.tetriminos[2].offsetY = 7.5
    self.tetriminos[3].offsetY = 7.5
    self.tetriminos[3].offsetX = 15
    self.tetriminos[4].offsetX = -15
    self.tetriminos[4].offsetY = -7.5
end