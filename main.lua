local rtsWorld = require 'components/rtsWorld'


-- Mouse last click
local lastClickX = 0
local lastClickY = 0

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

    if button == 1 then
        lastClickX = x
        lastClickY = y 
    end

    if button == 2 then
        -- todo temporary:
        rtsWorld:moveSelectedUnitsTo(world, x, y)
    end

end

function love.mousereleased( x, y, button, istouch, presses)

    -- If button is released, a group of units could be selected
    if button == 1 then
        rtsWorld:selectUnits(world, lastClickX, lastClickY, x, y)
        rtsWorld:hideSelection(world)
    end
end

function love.mousemoved( x, y, dx, dy, istouch )
    -- Drawing an overlayed rectangle to indicate what has been selected
    local rectThreshold = 2
    local distance = math.abs(lastClickX - x) + math.abs(lastClickY - y)
    if love.mouse.isDown(1) and distance > rectThreshold then
        rtsWorld:showSelection(world, math.min(lastClickX, x), math.min(lastClickY, y), math.max(lastClickX, x), math.max(lastClickY, y))
    else
        rtsWorld:hideSelection(world)
    end
end

-- Final Drawing
function love.draw()

    -- Drawing the world
    love.graphics.draw(rtsWorld:getImage(world))
end
