require "physics"
require "box"
require "lib"
require "boxHandler"
require "ropeswing"

function love.load()
    nw = 3
    nh = 3
    boxes = {}
    love.window.setFullscreen(true)
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    background = love.graphics.newImage("background.jpg")
    initialiseGlobalVariables()
    initialisePhysicsVariables()
    generateBoxes(0, 0, windowWidth * 1 / 3, windowHeight, 0, 0)
    generateBoxes(nw - 1, nh, windowWidth * 2 / 3, windowHeight, windowWidth / 3, 0)
    generateBoxes(nw, nh, windowWidth, windowHeight, windowWidth, 0)
    music = love.audio.newSource("bgm.mp3", 'stream')
    music:setLooping(true)
    music:play()
    shoot = love.audio.newSource("shoot.wav", 'static')
    Font = love.graphics.newFont("font.ttf", 18)
    love.graphics.setFont(Font)
    FontLarge = love.graphics.newFont("font.ttf", 72)
    world:setCallbacks(beginContact)
end

function love.update(dt)

    world:update(dt)

    --Contract rope if condition set
    if contractingRope and readyToDraw then
        objects.rope.length = objects.rope.length - 3 - baseSpeed * dt * 0.05
        objects.rope.joint = love.physics.newRopeJoint(objects.ball.body, objects.rope.body, objects.ball.body:getX(), objects.ball.body:getY(), objects.rope.body:getX(), objects.rope.body:getY(), objects.rope.length)
        if objects.rope.length < 15 then
            removeRope()
        end
    end


    if love.mouse.isDown(1) then
        contractingRope = true
    else
        contractingRope = false
    end
    --Cut rope if mouse has crossed rope
    xNewMouse, yNewMouse = love.mouse.getPosition()
    xNewMouse = xNewMouse - globalHOffset
    if readyToDraw and distance(xNewMouse, yNewMouse, objects.rope.body:getX(), objects.rope.body:getY()) > 15 then
        cross, xCross, yCross = segmentIntersection(objects.ball.body:getX(), objects.ball.body:getY(), objects.rope.body:getX(), objects.rope.body:getY(), xPriorMouse, yPriorMouse, xNewMouse, yNewMouse)
        if cross then
            removeRope()
        end
    end

    --Update mouse positions
    xPriorMouse = xNewMouse
    yPriorMouse = yNewMouse

    --Update globalTime
    globalTime = globalTime + 0.01
    baseSpeed = baseSpeed + acceleration * dt

    if (objects.ball.body:getX() < 960) then
        globalHspeed = baseSpeed
    else
        hspeed, vspeed = objects.ball.body:getLinearVelocity()
        if hspeed > 0 then
            globalHspeed = baseSpeed
        else
            globalHspeed = baseSpeed
        end
    end

    if loss then
        globalHspeed = 0
    end

    --Update score (max x value)
    if objects.ball.body:getX() > score then
        if not loss then
            score = math.floor(objects.ball.body:getX())
        end
    end

    if (boxScreens - 1) * windowWidth < -globalHOffset then
        generateBoxes(nw,nh,windowWidth,windowHeight, windowWidth * boxScreens,0)
        boxScreens = boxScreens + 1
    end
    globalHOffset = globalHOffset - globalHspeed * dt
end

function love.draw()
    love.graphics.draw(background, 0,0)
    love.graphics.translate(globalHOffset,0)
    updatePosition()
    drawBoxes()
    if readyToDraw then
        drawRope()
    end
    --globalHOffset = globalHOffset - globalHspeed
    love.graphics.translate(-globalHOffset,0)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Score: " .. score, 30, 30)

    if (objects.ball.body:getX() <= -100) or (objects.ball.body:getY() >= 1180) then
        loss = true
    end


    if loss then
        love.graphics.setFont(FontLarge)
        love.graphics.print("You lose", 800,300)
        love.graphics.print("Final score: " .. score, 800, 400)
        love.graphics.setFont(Font)
        love.graphics.print("Press the mouse button to restart", 800, 500)
    end

end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x,y,button, istouch, presses)
    if loss then
        love.load()
    elseif presses == 2 then
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
    -- compensate for horizontal & vertical lines
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

    globalHspeed = 5
    globalHOffset = 0
    baseSpeed = 200
    acceleration = 0.1
    globalTime = 0
    boxScreens = 2
    ropeExists = false

    loss = false

    score = 0
end

function beginContact(a, b, coll)
    if a:getShape():typeOf("PolygonShape") and b:getShape():typeOf("CircleShape") then
        loss = true
        love.graphics.print("You lose", 300,300)
    end
end
