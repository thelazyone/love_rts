local rtsMap = require 'components/rtsMap'
local rtsUnit = require 'components/rtsUnit'


local rtsWorld = {}

-- No values for the creation of the world. all the magic numbers are inside for now.
function rtsWorld:new()

    -- World Data
    local world = {}
    world.screenW = 800
    world.screenH = 600
    world.offsetX = 0
    world.offsetY = 0

    -- Map Data
    world.map = rtsMap:new(love.image.newImageData("resources/map.png"))

    -- Units Data
    world.units = {}

    -- Selection rectangle
    world.showSelection = false
    world.selStartX = 0
    world.selStartY = 0
    world.selW = 0
    world.selH = 0

    return world
end


-- returns the global canvas
function rtsWorld:getImage(world) 

    -- The local canvas is to compose the parts before rendering.
    local canvas = love.graphics.newCanvas(world.map.w, world.map.h)

    -- Adding the background map.
    canvas:renderTo(function() 
        love.graphics.draw(love.graphics.newImage(rtsMap:getImage(world.map)))
    end)

    -- Drawing Units
    for i = 1, #world.units do
        rtsUnit:addToCanvas(world.units[i], canvas)
    end

    -- Showing the rectangle on top of the units:
    if world.showSelection then
        canvas:renderTo(function() 
            love.graphics.setColor(1, 0, 0., 0.1)
            love.graphics.rectangle("fill", world.selStartX, world.selStartY, world.selW, world.selH)
            love.graphics.setColor(1, 0, 0., 1)
            love.graphics.rectangle("line", world.selStartX, world.selStartY, world.selW, world.selH)
            love.graphics.setColor(1, 1, 1., 1)
        end)
    end

    -- overriding the visible world content with the world image, shifted.
    local allWorld = canvas:newImageData()
    local visibleWorld = love.image.newImageData(world.screenW, world.screenH)
    visibleWorld:paste(
        allWorld,         
        world.offsetX,
        world.offsetY,
        0,
        0,
        world.map.w,
        world.map.h)

    outImage = love.graphics.newImage(visibleWorld)
    return outImage

end

-- Update function
function rtsWorld:update(world, dt) 
    
    local minDistThreshold = 1

    -- Moving units, checking for collision if necessary.
    -- This has a N^2 complexity and is NOT recommended, however what
    -- most old-school RTS do is to set individual positions for the units at the target, 
    -- and I don't want to do that.
    -- A better solution is to be expected.
    for i = 1, #world.units do

        local currentUnit = world.units[i]

        if currentUnit.isActive then -- This is not a great way to go, but LOVE2D has no "continue" statement
            -- If too close to the target, stopping.
            local dist = (currentUnit.targetX - currentUnit.x)^2 + math.abs(currentUnit.targetY - currentUnit.y)^2
            if dist < (minDistThreshold * currentUnit.speed * dt) ^ 2 then
                currentUnit.isActive = false
            end

            -- Moving in the direction of the target
            direction = math.atan((currentUnit.targetY - currentUnit.y) / (currentUnit.targetX - currentUnit.x))
            if currentUnit.targetX - currentUnit.x < 0 then
                direction = direction + math.pi
            end

            -- Checking if the position doesn't collide with others, in that case not moving.
            local newUnitX = currentUnit.x + currentUnit.speed * math.cos(direction) * dt
            local newUnitY = currentUnit.y + currentUnit.speed * math.sin(direction) * dt
            local isCollision = false
            for j = 1, #world.units do
                if not(i == j) and (newUnitX - world.units[j].x)^2+(newUnitY - world.units[j].y)^2 < (2*currentUnit.radius)^2 then
                    isCollision = true
                    currentUnit.frustration = currentUnit.frustration + dt
                    print("Frustration is ", currentUnit.frustration)
                    if currentUnit.frustration > currentUnit.patience then
                        print("unit got frustrated!")
                        currentUnit.isActive = false
                    end
                end
            end

            if isCollision == false then 
                -- Updating the movement
                currentUnit.x = newUnitX
                currentUnit.y = newUnitY

                -- Resetting the frustration: the unit can move
                currentUnit.frustration = 0
            end
        end
    end
end

-- Sets the visualization center on the coordinates.
function rtsWorld:setOffset(world, newX, newY)
    world.offsetX = newX
    world.offsetY = newY
end

function rtsWorld:moveOffset(world, moveX, moveY)
    world.offsetX = world.offsetX + moveX
    world.offsetY = world.offsetY + moveY
end

-- Adding rectangle if present
function rtsWorld:showSelection(world, startX, startY, endX, endY)
    world.showSelection = true
    world.selStartX = startX - world.offsetX
    world.selStartY = startY - world.offsetY
    world.selW = endX - startX
    world.selH = endY - startY
end

function rtsWorld:hideSelection(world)
    world.showSelection = false
end


-- Unit Handling

function rtsWorld:createUnit(world, relativeX, relativeY)
    print ("Creating unit on ", relativeX, ", ", relativeY)
    table.insert(world.units, rtsUnit:new(relativeX - world.offsetX, relativeY - world.offsetY))
end

function rtsWorld:selectUnits(world, startX, startY, endX, endY)
    for i = 1, #world.units do
        -- Solution 1: check the centers of the units. BORING.
        --local is_unit_selected = world.units[i].x > startX - world.offsetX and world.units[i].x < endX - world.offsetX and world.units[i].y > startY - world.offsetY and world.units[i].y < endY - world.offsetY

        -- Solution 2: check any point of the circle units.
        -- Method found for c++ on https://www.geeksforgeeks.org/check-if-any-point-overlaps-the-given-circle-and-rectangle/
        rectBorderX = math.max(startX - world.offsetX, math.min(world.units[i].x, endX - world.offsetX))
        rectBorderY = math.max(startY - world.offsetY, math.min(world.units[i].y, endY - world.offsetY))
        local is_unit_selected = (rectBorderX - world.units[i].x)^2 + (rectBorderY - world.units[i].y)^2 < world.units[i].radius ^ 2

        if is_unit_selected then
            world.units[i].selected = true
        else
            world.units[i].selected = false
        end
    end
end


function rtsWorld:moveSelectedUnitsTo(world, targetX, targetY)
    for i = 1, #world.units do
        if world.units[i].selected then
            rtsUnit:setTarget(world.units[i], targetX, targetY)
            world.units[i].isActive = true
        end
    end
end

return rtsWorld