function shootRope(x,y)
    startTime = globalTime
    objects.rope = { }
    xPos, yPos = love.mouse.getPosition()
    xPos = xPos - globalHOffset
    xPos = x or xPos
    yPos = y or yPos
    ballX = objects.ball.body:getX()
    ballY = objects.ball.body:getY()
    mouseLine = { p = {x = ballX, y = ballY}, d = {x = windowWidth * (xPos - ballX), y = windowWidth * (yPos - ballY)} }
    foundHit = false
    minDist = 0
    anchorx = 0
    anchory = 0
    for i = 1, #boxes do
        box = boxes[i].box
        hit,dist,x,y = box:hitBy(mouseLine)
        if hit then
            if not foundHit then
                foundHit = true
                minDist = dist
                anchorx = x
                anchory = y
            elseif dist < minDist then
                minDist = dist
                anchorx = x
                anchory = y
            end
        end
    end
    if foundHit then
        xPos = anchorx
        yPos = anchory
        objects.rope.body = love.physics.newBody(world, xPos, yPos, "static")
        objects.rope.length = distance(objects.ball.body:getX(), objects.ball.body:getY(), xPos, yPos)
        objects.rope.joint = love.physics.newRopeJoint(objects.ball.body, objects.rope.body, objects.ball.body:getX(), objects.ball.body:getY(), xPos, yPos, objects.rope.length)
        shoot:play()
        ropeExists = true
        readyToDraw = true
    end
end

function removeRope()
    readyToDraw = false
    contractingRope = false
    if ropeExists and objects.rope.body ~= nil then
        ropeExists = false
        objects.rope.body:destroy()
    end
end

function drawRope()
    love.graphics.line(objects.ball.body:getX(), objects.ball.body:getY(), objects.rope.body:getX(), objects.rope.body:getY())
end

function extendLine(x1,y1,x2,y2)
    return x1,y1,x1+(x2-x1)*100, y1+(y2-y1)*100
end

function checkExtended()
    if distance(player.physics:getX(), player.physics:getY(), rope.x2, rope.y2) >= rope.length then
        ropeExtended = true
    else ropeExtended = false
    end
end

--Check whether a line intersects with a box
local function boxSegmentIntersection(l,t,w,h, x1,y1,x2,y2)
      local dx, dy  = x2-x1, y2-y1

      local t0, t1  = 0, 1
      local p, q, r

      for side = 1,4 do
        if     side == 1 then p,q = -dx, x1 - l
        elseif side == 2 then p,q =  dx, l + w - x1
        elseif side == 3 then p,q = -dy, y1 - t
        else                  p,q =  dy, t + h - y1
        end

        if p == 0 then
          if q < 0 then return nil end  -- Segment is parallel and outside the bbox
        else
          r = q / p
          if p < 0 then
            if     r > t1 then return nil
            elseif r > t0 then t0 = r
            end
          else -- p > 0
            if     r < t0 then return nil
            elseif r < t1 then t1 = r
            end
          end
        end
      end

      local ix1, iy1, ix2, iy2 = x1 + t0 * dx, y1 + t0 * dy,
                                 x1 + t1 * dx, y1 + t1 * dy

      if ix1 == ix2 and iy1 == iy2 then return ix1, iy1 end
      return ix1, iy1, ix2, iy2
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end
