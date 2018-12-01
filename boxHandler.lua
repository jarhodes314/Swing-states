require "lib"
require "color"

boxes = {}
math.randomseed(os.time())

local function boxAABB(box1, box2)
    return AABB(box1.x, box1.y, box1.width, box1.height,
                box2.x, box2.y, box2.width, box2.height)
end

function generateBoxes(nw, nh, w, h)
    local cellWidth = w / nw
    local cellHeight = h / nh
    n = nw * nh
    for i = 0, n - 1 do
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
            box = Box:new(x, y, width, height)
            for j = 1, i do
                if boxAABB(box, boxes[j]) then
                    colliding = true
                end
            end
        end
        box.color = Color:new(1,0,0)
        boxes[i + 1] = box
    end
end

function drawBoxes()
    for i = 1, #boxes do
        box:draw()
    end
end
