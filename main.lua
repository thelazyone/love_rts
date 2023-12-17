local rtsMap = require 'components/rtsMap'


function love.load()
    map = rtsMap:new(800, 600, love.image.newImageData("resources/map.png"))
    for key,value in pairs(map) do
        print("found member " .. key);
    end
end


-- Controls
function love.update(dt)

    -- ####################################
    -- Arrows and WASD movement
    -- ####################################

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        rtsMap:moveCenterOffset(map, -1, 0)
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        rtsMap:moveCenterOffset(map, 1, 0)
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        rtsMap:moveCenterOffset(map, 0, 1)
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        rtsMap:moveCenterOffset(map, 0, -1)
    end

    -- ####################################
    -- Other Controls 
    -- ####################################

    -- TODO
end

function love.draw()

    -- Drawing the tank body
    love.graphics.draw(love.graphics.newImage(rtsMap:getImage(map)))
end