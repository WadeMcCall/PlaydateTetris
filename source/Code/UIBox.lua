import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

class("UIBox").extends()

function UIBox:init(x, y, text)
    self.x = x
    self.y = y
    self.height = 32
    self.width = 132

    self.text = text
    self.image = gfx.image.new(self.width, self.height)
    self.sprite = nil

    self:drawText()
end

function UIBox:drawText()
    gfx.pushContext(self.image)
        gfx.drawText(self.text , 0, 0)
    gfx.popContext()
    self.sprite = gfx.sprite.new(self.image)
    self.sprite:moveTo(self.x, self.y)
    self.sprite:add()
end

function UIBox:setText(text)
    self.text = text
    self:drawText()
end