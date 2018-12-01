player = { }


function initialiseVariables()
    player.hspeed = 0
    player.vspeed = 0
    player.xPosition = 200
    player.yPosition = 200
end

function updatePosition()
    player.xPosition = player.xPosition + player.hspeed
    player.yPosition = player.yPosition + player.vspeed
    love.graphics.draw(player.sprite, player.xPosition, player.yPosition)
end

function gravity()
    player.vspeed = player.vspeed + 0.1
end
