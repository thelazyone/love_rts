local rtsMap = require 'components/rtsMap'
local rectangle = require 'components/rtsSelectionRectangle'

local renderer = {}

renderer.screenW = 800
renderer.screenH = 600
renderer.offsetX = 0
renderer.offsetY = 0

function renderer:initialize(map_path, camera)
    -- Map Data
    self.map = rtsMap:new(love.image.newImageData(map_path))
    self.canvas = love.graphics.newCanvas(self.map.w, self.map.h)
    self.camera = camera
end

function renderer:getImage(units)

    -- Adding the background map.
    self.canvas:renderTo(function()
        love.graphics.draw(love.graphics.newImage(self.map:getImage()))
    end)

    -- Drawing Units
    for i = 1, #units do
        units[i]:addToCanvas(self.canvas)
    end

    -- Showing the rectangle on top of the units:
    if rectangle.isSelectionVisible then
        self.canvas:renderTo(function()
            love.graphics.setColor(1, 0, 0., 0.1)
            love.graphics.rectangle("fill", rectangle.selStartX, rectangle.selStartY, rectangle.selW, rectangle.selH)
            love.graphics.setColor(1, 0, 0., 1)
            love.graphics.rectangle("line", rectangle.selStartX, rectangle.selStartY, rectangle.selW, rectangle.selH)
            love.graphics.setColor(1, 1, 1., 1)
        end)
    end

    -- overriding the visible world content with the world image, shifted.
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