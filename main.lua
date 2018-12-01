function love.load()
    windowWidth = 1920
    windowHeight = 1080
    love.window.setMode(windowWidth, windowHeight)
    love.window.setFullscreen(true)
end

function love.update(dt)
    down = love.mouse.isDown(1)
end

function love.draw()
    if down then
	    love.graphics.print("Hello World!", 400, 300)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
