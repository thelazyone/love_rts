local rtsMap = require 'components/rtsMap'
local rtsSelectionRectangle = require 'components/rtsSelectionRectangle'

local rtsRenderer = {}

rtsRenderer.screenW = 800
rtsRenderer.screenH = 600
rtsRenderer.offsetX = 0
rtsRenderer.offsetY = 0

function rtsRenderer.initialize(self, map_path, camera)
    -- Map Data
    self.map = rtsMap:new(love.image.newImageData(map_path))
    self.canvas = love.graphics.newCanvas(self.map.w, self.map.h)
    self.camera = camera
end

function rtsRenderer.getImage(self, units)

    -- Adding the background map.
    self.canvas:renderTo(function()
        love.graphics.draw(love.graphics.newImage(self.map:getImage()))
    end)

    -- Drawing Units
    for i = 1, #units do
        units[i]:addToCanvas(self.canvas)
    end

    -- Showing the rectangle on top of the units:
    if rtsSelectionRectangle.isSelectionVisible then
        self.canvas:renderTo(function()
            love.graphics.setColor(1, 0, 0., 0.1)
            love.graphics.rectangle("fill", rtsSelectionRectangle.selStartX, rtsSelectionRectangle.selStartY, rtsSelectionRectangle.selW, rtsSelectionRectangle.selH)
            love.graphics.setColor(1, 0, 0., 1)
            love.graphics.rectangle("line", rtsSelectionRectangle.selStartX, rtsSelectionRectangle.selStartY, rtsSelectionRectangle.selW, rtsSelectionRectangle.selH)
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


-- Sets the visualization center on the coordinates.
function rtsRenderer.setOffset(self, newX, newY)
    self.camera.offsetX = newX
    self.camera.offsetY = newY
end

-- Sets moves the Offset (to move the camera.)
function rtsRenderer.moveOffset(self, moveX, moveY)
    self.camera.offsetX = self.camera.offsetX + moveX
    self.camera.offsetY = self.camera.offsetY + moveY
end

-- Adding rectangle if present
function rtsRenderer.showSelection(self, startX, startY, endX, endY)
    print ("show rect")
    rtsSelectionRectangle.isSelectionVisible = true
    rtsSelectionRectangle.selStartX, rtsSelectionRectangle.selStartY = self.camera:coordsOffset(startX, startY)
    rtsSelectionRectangle.selW, rtsSelectionRectangle.selH  =  endX - startX, endY - startY
end

-- Hides the bound rect
function rtsRenderer.hideSelection(self)
    print ("hide rect")
    rtsSelectionRectangle.isSelectionVisible = false
end



return rtsRenderer