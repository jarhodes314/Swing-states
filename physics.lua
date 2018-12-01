function initialisePhysicsVariables()
        objects.ball = {}
        objects.ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
        objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
        objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
        objects.ball.fixture:setRestitution(1)
end

function updatePosition()
    love.graphics.setColor(0, 1, 1) --set the drawing color to blue for the ball
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
    love.graphics.setColor(0, 0, 0) --set the drawing color to red for the ball
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
    love.graphics.setLineWidth(5)
end

function angleFinder(x1,y1,x2,y2)
    return math.atan2(x2-x1,y2-y1)
end
