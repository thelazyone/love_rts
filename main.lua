local rtsWorld = require 'components/rtsWorld'

function love.load()
    world = rtsWorld:new()
end


-- Controls
function love.update(dt)

    -- ####################################
    -- Arrows and WASD movement
    -- ####################################
    local moveSpeed = 5

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        rtsWorld:moveOffset(world, -moveSpeed, 0)
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        rtsWorld:moveOffset(world, moveSpeed, 0)
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        rtsWorld:moveOffset(world, 0, -moveSpeed)
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        rtsWorld:moveOffset(world, 0, moveSpeed)
    end

    -- ####################################
    -- Other Controls 
    -- ####################################

    -- TODO

    -- ####################################
    -- Updating the world.
    -- ####################################
    rtsWorld:update(world, dt)
end

function love.mousepressed( x, y, button, istouch, presses )

    -- Ctrl + LClick generates a new unit
    if love.keyboard.isDown("lctrl") and button == 1 then
        rtsWorld:createUnit(world, x, y)
    end

    if button == 2 then
        -- todo temporary:
        rtsWorld:selectUnits(world, 0, 0, 1000, 1000)

        rtsWorld:moveSelectedUnitsTo(world, x, y)
    end

end

-- Final Drawing
function love.draw()

    -- Drawing the tank body
    love.graphics.draw(rtsWorld:getImage(world))
end