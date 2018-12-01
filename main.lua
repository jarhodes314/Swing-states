require("physics")

function love.load()
    windowWidth = 1920
    windowHeight = 1080
    love.window.setMode(windowWidth, windowHeight)
    love.window.setFullscreen(true)
    initialiseVariables()
    loadGraphics()
end

function love.update(dt)
    gravity()
end

function love.draw()
    updatePosition()
    if down then
	    love.graphics.print("Hello World!", 400, 300)
    end
end

function loadGraphics()
    player.sprite = love.graphics.newImage("player.jpg")
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
