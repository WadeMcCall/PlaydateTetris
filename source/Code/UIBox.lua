import "CoreLibs/object"

class("UIBox").extends()

function UIBox:init(x, y)
    self.x = x
    self.y = y
    self.height = 32
    self.width = 132
end