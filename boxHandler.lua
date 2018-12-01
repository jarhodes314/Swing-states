require "lib"
require "color"

boxes = {}
math.randomseed(os.time())

local function boxAABB(box1, box2)
    if box2 == nil then return false end
    return AABB(box1.x, box1.y, box1.width, box1.height,
                box2.x, box2.y, box2.width, box2.height)
end

function generateBoxes(nw, nh, w, h)
    local cellWidth = w / nw
    local cellHeight = h / nh
    n = nw * nh
    for i = 0, n - 1 do
        box = {}
        if math.random() > 1/3 then
            row = math.floor(i / nw)
            col = i % nw
            local left = math.floor(col * cellWidth) 
            local top = math.floor(row * cellHeight)
            local colliding = true
            while colliding do
                colliding = false
                local x = cellWidth * math.random() + left
                local y = cellHeight * math.random() + top
                local width = cellWidth * math.random()
                local height = cellHeight * math.random() / 2
                local xx = math.floor(x + width / 2)
                local yy = math.floor(y + height / 2)
                box.b = love.physics.newBody(world, xx, yy, "static")
                box.s = love.physics.newRectangleShape(width, height)
                box.f = love.physics.newFixture(box.b, box.s)
                box.box = Box:new(x, y, width, height)
                box.f:setUserData("Box")
                for j = 1, i do
                    if boxAABB(box.box, boxes[j].box) then
                        colliding = true
                    end
                end
            end
            box.box.color = Color:new(1,0,0)
            boxes[i + 1] = box
        else
            boxes[i + 1] = box
            boxes[i + 1].box = Box:new(0,0,0,0)
        end
    end
end

function drawBoxes()
    for i = 1, #boxes do
        local box = boxes[i].box
        box:draw()
    end
end
