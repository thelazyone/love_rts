local rtsMap = {}

-- Creates the new rts map, given size and base image.
-- Make sure that the image is wider than the w and h
function rtsMap:new(w, h, image)

    local map = {}

    -- Sanity check, visible in debug only:
    if image:getWidth() < w or image:getHeight() < h then
        print ("Image too small or coordinates too large");
    end

    map.sizeX = image:getWidth()
    map.sizeY = image:getHeight()
    map.visibleSizeX = w
    map.visibleSizeY = h
    map.image = image 
    map.centerOffsetX = 0
    map.centerOffsetY = 0

    return map
end

-- Returns the image of the map at the current centering.
function rtsMap:getImage(map)

    local visibleMap = love.image.newImageData(map.visibleSizeX, map.visibleSizeY)

    -- overriding the visible map content with the map image, shifted.
    visibleMap:paste(
        map.image,         
        map.centerOffsetX,
        map.centerOffsetY,
        0,
        0,
        map.sizeX,
        map.sizeY)

    return visibleMap
end

-- Sets the visualization center on the coordinates.
function rtsMap:setCenterOffset(map, newCenterX, newCenterY)
    map.centerOffsetX = newCenterX
    map.centerOffsetY = newCenterY
end

function rtsMap:moveCenterOffset(map, moveX, moveY)
    map.centerOffsetX = map.centerOffsetX + moveX
    map.centerOffsetY = map.centerOffsetY + moveY
end

return rtsMap



