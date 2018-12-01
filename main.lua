require "physics"
require "box"
require "lib"
require "boxHandler"
require "ropeswing"

function love.load()
    nw = 3
    nh = 3
    love.window.setFullscreen(true)
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    initialiseGlobalVariables()
    initialisePhysicsVariables()
    --loadGraphics()
    generateBoxes(nw, nh, windowWidth, windowHeight)
end

function love.update(dt)
    --If left mouse button is pressed, try to rope swing

    world:update(dt)

    if contractingRope and readyToDraw then
        objects.rope.length = objects.rope.length - 3
        objects.rope.joint = love.physics.newRopeJoint(objects.ball.body, objects.rope.body, objects.ball.body:getX(), objects.ball.body:getY(), objects.rope.body:getX(), objects.rope.body:getY(), objects.rope.length)
    end

end

function love.draw()
    updatePosition()

    drawBoxes()
    if readyToDraw then
        drawRope()
    end
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x,y,button, istouch, presses)
    if presses == 2 then
        removeRope()
    elseif button == 1 then
        if not readyToDraw then
            shootRope()
        else
            contractingRope = true
        end
    end
end

function love.mousereleased(x,y,button)
    if button == 1 then
        contractingRope = false
    end
end


function initialiseGlobalVariables()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0,9.81*64,true)
    objects = {}
    readyToDraw = false
    contractingRope = false

end
