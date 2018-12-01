require "physics"
require "box"
require "lib"
require "boxHandler"
require "ropeswing"

function love.load()
    windowWidth = 1920
    windowHeight = 1080
    love.window.setMode(windowWidth, windowHeight)
    love.window.setFullscreen(true)
    initialiseGlobalVariables()
    initialisePhysicsVariables()
    generateBoxes(3, 3, windowWidth, windowHeight)
    initialisePhysicsVariables();
end

function love.update(dt)
    --If left mouse button is pressed, try to rope swing
    if love.mouse.isDown(1) then
        if not readyToDraw then
            shootRope()
        else
            removeRope()
        end
    end
    world:update(dt)

end

function love.draw()
    updatePosition()

    drawBoxes()
    for i=1,#boxes do
        boxes[i]:draw()
    end
    if readyToDraw then
        drawRope()
    end
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function initialiseGlobalVariables()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0,9.81*64,true)
    objects = {}
    readyToDraw = false
end
