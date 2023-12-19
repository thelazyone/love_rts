local rtsMap = require 'components/rtsMap'

local renderer = {}

renderer.screenW = 800
renderer.screenH = 600
renderer.offsetX = 0
renderer.offsetY = 0

function renderer:initialize(map_path, camera, rectangle)
    self.map = rtsMap:new(love.image.newImageData(map_path))
    self.canvas = love.graphics.newCanvas(self.map.w, self.map.h)
    self.camera = camera
    self.rectangle = rectangle
end

-- Returns a cropped image combining together all the elements (units and buildings) for the scene
function renderer:getImage(units, buildings)

    -- Adding the background map.
    self.canvas:renderTo(function()
        love.graphics.draw(love.graphics.newImage(self.map:getImage()))
    end)

    -- Drawing Buildings
    for i = 1, #buildings do
        buildings[i]:addToCanvas(self.canvas)
    end

    -- Drawing Units
    for i = 1, #units do
        units[i]:addToCanvas(self.canvas)
    end

    -- Showing the rectangle on top of the units:
    self.rectangle:addToCanvas(self.canvas)

    -- overriding the visible world content with the world image, shifted.
    love.graphics.setColor(1, 1, 1, 1)
    local allWorld = self.canvas:newImageData()
    local visibleWorld = love.image.newImageData(self.screenW, self.screenH)
    visibleWorld:paste(
        allWorld,
        self.camera.offsetX,
        self.camera.offsetY,
        0,
        0,
        self.map.w,
        self.map.h)

    return love.graphics.newImage(visibleWorld)
end

return renderer