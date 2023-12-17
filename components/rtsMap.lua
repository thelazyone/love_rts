-- The world map. Loads an image and displays it as imageData for the world to generate

local rtsMap = {}

-- Creates the new rts map, given size and base image.
-- Make sure that the image is wider than the w and h
function rtsMap:new(image)

    local map = {}

    map.w = image:getWidth()
    map.h = image:getHeight()
    map.image = image 

    return map
end

-- Returns the image of the map at the current centering.
function rtsMap:getImage(map)
    return map.image
end

return rtsMap


