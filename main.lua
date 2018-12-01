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

    --Contract rope if condition set
    if contractingRope and readyToDraw then
        objects.rope.length = objects.rope.length - 3
        objects.rope.joint = love.physics.newRopeJoint(objects.ball.body, objects.rope.body, objects.ball.body:getX(), objects.ball.body:getY(), objects.rope.body:getX(), objects.rope.body:getY(), objects.rope.length)
    end

    if love.mouse.isDown(1) then
        contractingRope = true
    else
        contractingRope = false
    end
    --Cut rope if mouse has crossed rope
    if readyToDraw and not objects.rope.body == nil then
        xNewMouse, yNewMouse = love.mouse.getPosition()
        cross, xCross, yCross = segmentIntersection(objects.ball.body:getX(), objects.ball.body:getY(), objects.rope.body:getX(), objects.rope.body:getY(), xPriorMouse, yPriorMouse, xNewMouse, yNewMouse)
        if cross then
            removeRope()
        end
    end

    --Update mouse positions
    xPriorMouse = xNewMouse
    yPriorMouse = yNewMouse


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
        end
    end
end

function love.mousereleased(x,y,button)
    if button == 1 then
        contractingRope = false
    end
end

function segmentIntersection(s1x1, s1y1, s1x2, s1y2, s2x1, s2y1, s2x2, s2y2)
	-- compensate for horizontal & verticle lines
	local eps = 0.0001
	if s1x1 == s1x2 then s1x2 = s1x2 + eps end
	if s1y1 == s1y2 then s1y2 = s1y2 + eps end
	if s2x1 == s2x2 then s2x2 = s2x2 + eps end
	if s2y1 == s2y2 then s2y2 = s2y2 + eps end
	-- fit linear equation to line segments
	local slope1 = ( s1y2 - s1y1 ) / ( s1x2 - s1x1 )	-- line1 slope
	local slope2 = ( s2y2 - s2y1 ) / ( s2x2 - s2x1 )	-- line2 slope
	local int1	 = s1y1 - slope1 * s1x1		-- line1 intercept
	local int2	 = s2y1 - slope2 * s2x1		-- line2 intercept
	-- intercept coordinates
	if slope1 == slope2 then slope1 = slope1 + eps end	-- avoid div by zero
	local x = ( int2 - int1 ) / ( slope1 - slope2 )
	local y = slope2 * x + int2
	-- check order of points
	if s1x1 > s1x2 then s1x1, s1x2 = s1x2, s1x1 end
	if s1y1 > s1y2 then s1y1, s1y2 = s1y2, s1y1 end
	if s2x1 > s2x2 then s2x1, s2x2 = s2x2, s2x1 end
	if s2y1 > s2y2 then s2y1, s2y2 = s2y2, s2y1 end
	-- check if contact point is on both line segments
	if  x >= s1x1 and x <= s1x2 and x >= s2x1 and x <= s2x2 and
		y >= s1y1 and y <= s1y2 and y >= s2y1 and y <= s2y2 then
		return true, x, y
		else
		return false, x, y
		end
	end


function initialiseGlobalVariables()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0,9.81*64,true)
    objects = {}
    readyToDraw = false
    contractingRope = false
    xPriorMouse = 0
    yPriorMouse = 0
end
