import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

-- Super class
class("Block").extends()

function Block:init(_x, _y)
    self.position = {x = _x or 0, y = _y or 0}
end

function Block:setPosition(x, y)
    self.position = {x, y}
end

function Block:update()
    
end

----------
-- T Block
----------
class("TBlock").extends("Block")

function TBlock:init(_x, _y)
    TBlock.super:init(_x, _y)
end

----------
-- I Block
----------
class("IBlock").extends("Block")

function IBlock:init(_x, _y)
    IBlock.super:init(_x, _y)
end

----------
-- L Block
----------
class("LBlock").extends("Block")

function LBlock:init(_x, _y)
    LBlock.super:init(_x, _y)
end

------------------
-- Reverse L Block
------------------
class("ReverseLBlock").extends("Block")

function ReverseLBlock:init(_x, _y)
    ReverseLBlock.super:init(_x, _y)
end

----------
-- S Block
----------
class("SBlock").extends("Block")

function SBlock:init(_x, _y)
    SBlock.super:init(_x, _y)
end

---------------
-- Square Block
---------------
class("SquareBlock").extends("Block")

function TBlock:init(_x, _y)
    TBlock.super:init(_x, _y)
end

----------
-- Z Block
----------
class("ZBlock").extends("Block")

function TBlock:init(_x, _y)
    TBlock.super:init(_x, _y)
end