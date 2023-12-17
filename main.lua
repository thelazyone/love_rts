local rtsWorld = require 'components/rtsWorld'

-- TODO to be removed - the movement should happen in the rtsWorld
local rtsMap = require 'components/rtsMap' 


function love.load()
    world = rtsWorld:new()
end


-- Controls
function love.update(dt)

    -- ####################################
    -- Arrows and WASD movement
    -- ####################################

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        rtsMap:moveCenterOffset(world.map, -1, 0)
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        rtsMap:moveCenterOffset(world.map, 1, 0)
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        rtsMap:moveCenterOffset(world.map, 0, -1)
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        rtsMap:moveCenterOffset(world.map, 0, 1)
    end

    -- ####################################
    -- Other Controls 
    -- ####################################

    -- TODO
end

function love.draw()

    -- Drawing the tank body
    love.graphics.draw(rtsWorld:getImage(world))
end