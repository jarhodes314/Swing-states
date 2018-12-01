require "lib"
require "color"

boxes = {}
box = {}
math.randomseed(os.time())

local function boxAABB(box1, box2)
    if box2 == nil then return false end
    return AABB(box1.x, box1.y, box1.width, box1.height,
                box2.x, box2.y, box2.width, box2.height)
end

function generateBoxes(nw, nh, w, h, wOffset, hOffset)
    wOffset = wOffset or 0
    hOffset = hOffset or 0
    local cellWidth = w / nw
    local cellHeight = h / nh
    n = nw * nh
    for i = 0, n - 1 do
        if math.random() > 1/5 then
            box = {}
            row = math.floor(i / nw)
            col = i % nw
            local left = math.floor(col * cellWidth) + wOffset
            local top = math.floor(row * cellHeight) + hOffset
            local colliding = true
            while colliding do
                colliding = false
                local x = cellWidth * math.random() + left
                local y = cellHeight * math.random() + top
                local width = cellWidth * math.random(0.3,0.5)
                local height = cellHeight * math.random(0.2,0.4)
                local xx = math.floor(x + width / 2)
                local yy = math.floor(y + height / 2)
                box.b = love.physics.newBody(world, xx, yy, "static")
                box.s = love.physics.newRectangleShape(width, height)
                box.f = love.physics.newFixture(box.b, box.s)
                box.box = Box:new(x, y, width, height)
                box.f:setUserData("Box")
                for j = 1, #boxes do
                    if boxAABB(box.box, boxes[j].box) then
                        colliding = true
                    end
                end
                if colliding then
                    box.b:destroy()
                end
            end
            box.box.color = Color:new(1,0,0)
            table.insert(boxes,box)
        end
    end
    box = {}
    box.b = love.physics.newBody(world, wOffset, hOffset - 100, "static")
    box.s = love.physics.newRectangleShape(w, 0)
    box.f = love.physics.newFixture(box.b, box.s)
    box.box = Box:new(wOffset, hOffset - 100, w, 1)
    box.f:setUserData("Box")

    table.insert(boxes,box)
end

function drawBoxes()
    for i = 1, #boxes do
        local box = boxes[i].box
        box:draw()
    end
end
