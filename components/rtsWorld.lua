local rtsMap = require 'components/rtsMap'


local rtsWorld = {}

-- No values for the creation of the world. all the magic numbers are inside for now.
function rtsWorld:new()

    local world = {}
    world.w = 800
    world.h = 600

    world.map = rtsMap:new(world.w, world.h, love.image.newImageData("resources/map.png"))

    return world
end


-- returns the global canvas
function rtsWorld:getImage(world) 

    -- Adding the background
    local canvas = love.graphics.newCanvas(world.w, world.h)

    canvas:renderTo(function() 
        love.graphics.draw(love.graphics.newImage(rtsMap:getImage(world.map)))
    end)

    -- TODO the crop should maybe be done AFTER all has been rendered, rather than before.

    -- Adding the rest of the stuff
    -- TODO

    outImage = love.graphics.newImage(canvas:newImageData())
    outImage = love.graphics.newImage(canvas:newImageData())
    return outImage

end

return rtsWorld