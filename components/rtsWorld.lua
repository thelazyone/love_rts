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

-- Sets the visualization center on the coordinates.
function rtsWorld:setOffset(world, newX, newY)
    world.offsetX = newX
    world.offsetY = newY
end

function rtsWorld:moveOffset(world, moveX, moveY)
    world.offsetX = world.offsetX + moveX
    world.offsetY = world.offsetY + moveY
end

function rtsWorld:createUnit(world, relative_x, relative_y)
    table.insert(world.units, rtsUnit:new(relative_x - world.offsetX, relative_y - world.offsetY))
end
function rtsWorld.createUnitb(x, y)
    table.insert(world.units, rtsUnit:new(x, y))
end

return rtsWorld