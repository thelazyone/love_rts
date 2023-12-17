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
    for i = 1, #world.units do
        rtsUnit:update(world.units[i], dt)
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
        if world.units[i].x > startX - world.offsetX and world.units[i].x < endX - world.offsetX and world.units[i].y > startY - world.offsetY and world.units[i].y < endY - world.offsetY then
            world.units[i].selected = true
        else
            world.units[i].selected = false
        end
    end
end

function rtsWorld:moveSelectedUnitsTo(world, targetX, targetY)
    print ("sending to ", targetX, ", ", targetY)
    for i = 1, #world.units do
        if world.units[i].selected then
            rtsUnit:setTarget(world.units[i], targetX, targetY)
        end
    end
end

return rtsWorld