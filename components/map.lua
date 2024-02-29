-- The world map. Loads an image and displays it as imageData for the world to generate

local map = {}

-- Creates the new rts map, given size and base image.
-- Make sure that the image is wider than the w and h
function map:new(imagePath)
    local newObj = {}

    newObj.image = love.graphics.newImage(imagePath)
    newObj.w = newObj.image:getWidth()
    newObj.h = newObj.image:getHeight()

    return newObj
end

return map
