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
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 3, 3)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 3, 3)
    love.graphics.setColor(1, 1, 1)
end

function vecMinus(v1, v2)
    return {x = v1.x - v2.x, y = v1.y - v2.y}
end

function vecPlus(v1, v2)
    return {x = v1.x + v2.x, y = v1.y + v2.y}
end

function vecScale(v, a)
    return {x = v.x * a, y = v.y * a}
end

function Box:hitBy(line)
    intersections = {}
    tl = {x = self.x, y = self.y}
    tr = {x = self.x + self.width, y = self.y}
    bl = {x = self.x, y = self.y + self.height}
    br = {x = self.x + self.width, y = self.y + self.height}
    edges = {{p = tl, d = vecMinus(tr,tl)}, 
             {p = br, d = vecMinus(tr,br)},
             {p = bl, d = vecMinus(br,bl)},
             {p = bl, d = vecMinus(tl,bl)}}
    for i = 1,#edges do
        edge = edges[i]
            p1 = edge.p
            p2 = vecPlus(edge.p, edge.d)
            p3 = line.p
            p4 = vecPlus(line.p,vecScale(line.d,10000)) 
            intersects,x,y = segmentIntersection(p1.x, p1.y,
                                                 p2.x, p2.y,
                                                 p3.x, p3.y,
                                                 p4.x, p4.y)
        if intersects then
            table.insert(intersections,{x, y})
        end
    end

    if #intersections > 0 then
        minIntersection = {100000, windowWidth, windowHeight}
        for i = 1, #intersections do
            x = intersections[i][1]
            y = intersections[i][2]
            distanceBetween = distance(line.p.x, line.p.y, x, y)
            if distanceBetween < minIntersection[1] then
                minIntersection[1] = distanceBetween
                minIntersection[2] = {x, y}
            end
        end
        x = minIntersection[2][1]
        y = minIntersection[2][2]
        if x > -globalHOffset and x < windowWidth - globalHOffset then
            return true, minIntersection[1], x, y
        end
    end
    return false
end
