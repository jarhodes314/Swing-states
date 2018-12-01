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
    if love.mouse.isDown(1) then
        if not readyToDraw then
            shootRope()
        end
    end
    world:update(dt)

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


function initialiseGlobalVariables()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0,9.81*64,true)
    objects = {}
    readyToDraw = false
end
