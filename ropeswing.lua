rope = { }

function shootRope()
    xTemp, yTemp = love.mouse.getPosition()
    rope.x1, rope.y1, rope.x2, rope.y2 = extendLine(player.xPosition+4, player.yPosition+4, xTemp, yTemp)
    rope.length = distance(rope.x1,rope.y1,rope.x2,rope.y2)
    readyToDraw = true
end

function drawRope()
    love.graphics.line(rope.x1,rope.y1,rope.x2,rope.y2)
end

function extendLine(x1,y1,x2,y2)
    return x1,y1,x1+(x2-x1)*100, y1+(y2-y1)*100
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
