local world = require 'components/rtsWorld'


-- Mouse last click
local lastClickX = nil
local lastClickY = nil

function love.load()

end


-- Controls
function love.update(dt)

    -- ####################################
    -- Arrows and WASD movement
    -- ####################################
    local moveSpeed = 5

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        world:moveOffset(-moveSpeed, 0)
        updateDragArea(love.mouse.getPosition())
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        world:moveOffset(moveSpeed, 0)
        updateDragArea(love.mouse.getPosition())
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        world:moveOffset(0, -moveSpeed)
        updateDragArea(love.mouse.getPosition())
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        world:moveOffset(0, moveSpeed)
        updateDragArea(love.mouse.getPosition())
    end

    -- ####################################
    -- Other Controls 
    -- ####################################

    -- TODO

    -- ####################################
    -- Updating the world.
    -- ####################################
    world:update(dt)
end

function love.mousepressed( x, y, button, istouch, presses )


    -- Ctrl + LClick generates a new unit
    if love.keyboard.isDown("lctrl") and button == 1 then
        world:createUnit(x, y)
    end

    if button == 1 then
        lastClickX = x
        lastClickY = y 
    end

    if button == 2 then
        -- todo temporary:
        world:moveSelectedUnitsTo(x, y)
    end

end

function love.mousereleased( x, y, button, istouch, presses)

    -- If button is released, a group of units could be selected
    if button == 1 then
        world:selectUnits(lastClickX, lastClickY, x, y)
        world:hideSelection()
    end
end

function love.mousemoved( x, y, dx, dy, istouch )

    -- If mouse position is nil it means that no click has been done so far.
    if lastClickX == nil or lastClickY == nil then
        lastClickX = 0
        lastClickY = 0
    end

    -- Drawing an overlayed rectangle to indicate what has been selected
    updateDragArea(x, y)
end

function updateDragArea(x, y)
    local rectThreshold = 2
    local distance = math.abs(lastClickX - x) + math.abs(lastClickY - y)
    if love.mouse.isDown(1) and distance > rectThreshold then
        world:showSelection(math.min(lastClickX, x), math.min(lastClickY, y), math.max(lastClickX, x), math.max(lastClickY, y))
    else
        world:hideSelection()
    end
end

-- Final Drawing
function love.draw()

    -- Drawing the world
    love.graphics.draw(world:getImage())
end
