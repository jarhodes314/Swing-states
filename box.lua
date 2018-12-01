require "color"

Box = {}

function Box:new(xx,yy, w, h)
    local fields = {x = xx, y = yy, width = w, height = h}
    self.__index = self
    return setmetatable(fields, self)
end

function Box:draw()
    if self.color ~= nil then
        local c = self.color
        love.graphics.setColor(c.R, c.G, c.B, c.A)
    else
        love.graphics.setColor(0, 0.5, 0.5)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end
