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
    initialisePhysicsVariables()
    initialiseGlobalVariables()
    loadGraphics()
    generateBoxes(3, 3, windowWidth, windowHeight)
end

function love.update(dt)
    gravity()

    --If left mouse button is pressed, try to rope swing
    if love.mouse.isDown(1) then
        shootRope()
    end
end

function love.draw()
    updatePosition()
    drawBoxes()
    if down then
	    love.graphics.print("Hello World!", 400, 300)
    end
    for i=1,#boxes do
        boxes[i]:draw()
    end
    if readyToDraw then
        drawRope()
    end
end

function loadGraphics()
    player.sprite = love.graphics.newImage("player.jpg")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function initialiseGlobalVariables()
    readyToDraw = false
end
