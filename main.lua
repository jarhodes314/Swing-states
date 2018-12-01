require "physics"
require "box"
require "lib"
require "boxHandler"

function love.load()
    windowWidth = 1920
    windowHeight = 1080
    love.window.setMode(windowWidth, windowHeight)
    love.window.setFullscreen(true)
    initialiseVariables()
    loadGraphics()
    generateBoxes(3, 3, windowWidth, windowHeight)
end

function love.update(dt)
    gravity()
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
end

function loadGraphics()
    player.sprite = love.graphics.newImage("player.jpg")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
