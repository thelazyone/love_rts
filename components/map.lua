-- The world map. Loads an image and displays it as imageData for the world to generate

local map = {}

-- Creates the new rts map, given size and base image.
-- Make sure that the image is wider than the w and h
function map:new(image)

    local newObj = {}

    newObj.w = image:getWidth()
    newObj.h = image:getHeight()
    newObj.image = image 

    setmetatable(newObj, {__index = map})

    return newObj
end

-- Returns the image of the map at the current centering.
function map:getImage()
    return self.image
end

return map



