local map = require 'components.map'

local renderer = {}

renderer.screenW = 800
renderer.screenH = 600
renderer.offsetX = 0
renderer.offsetY = 0

function renderer:initialize(map_path, camera, rectangle)
    self.map = map:new(map_path)
    self.canvas = love.graphics.newCanvas(self.map.w, self.map.h)
    self.camera = camera
    self.rectangle = rectangle
end

-- Returns a cropped image combining together all the elements (units and buildings) for the scene
function renderer:draw(units, buildings)
    love.graphics.setCanvas(self.canvas)
    love.graphics.translate(self.camera.offsetX, self.camera.offsetY)

    -- Adding the background map.
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.map.image)

    -- Drawing Buildings
    for i = 1, #buildings do
        buildings[i]:draw()
    end

    -- Drawing Units
    for i = 1, #units do
        units[i]:draw()
    end

    -- Showing the rectangle on top of the units:
    self.rectangle:draw()

    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas)
end

return renderer
