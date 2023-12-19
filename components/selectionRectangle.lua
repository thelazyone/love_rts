local camera = require 'components.camera'


local rectangle = {}
rectangle.isSelectionVisible = false
rectangle.selStartX = 0
rectangle.selStartY = 0
rectangle.selW = 0
rectangle.selH = 0

-- Sets the bound rect without showing it
function rectangle:setSelection(startX, startY, endX, endY)
    self.selStartX, self.selStartY = camera:getCoordsOffset(startX, startY)
    self.selW, self.selH  =  endX - startX, endY - startY
end

-- Adding rectangle if present
function rectangle:showSelection(startX, startY, endX, endY)
    self.isSelectionVisible = true
    self:setSelection(startX, startY, endX, endY)
end

-- Hides the bound rect
function rectangle:hideSelection()
    self.isSelectionVisible = false
end

-- Given the current units, checks which ones fall into the currently chosen rect
function rectangle:selectUnits(units)
    for i = 1, #units do
        local startXLocal, startYLocal = self.selStartX, self.selStartY
        local endXLocal, endYLocal = self.selW + self.selStartX, self.selH + self.selStartY

        -- Solution 2: check any point of the circle units.
        -- Method found for c++ on https://www.geeksforgeeks.org/check-if-any-point-overlaps-the-given-circle-and-rectangle/
        rectBorderX = math.max(startXLocal, math.min(units[i].x, endXLocal))
        rectBorderY = math.max(startYLocal, math.min(units[i].y, endYLocal))
        local is_unit_selected = (rectBorderX - units[i].x)^2 + (rectBorderY - units[i].y)^2 < units[i].radius ^ 2

        if is_unit_selected then
            units[i].selected = true
        else
            units[i].selected = false
        end
    end
end

-- Updates the provided canvas with the rectangle.
function rectangle:addToCanvas(canvas)
    if self.isSelectionVisible then 
        -- Drawing the circle.
        canvas:renderTo(function()
            love.graphics.setColor(1, 0, 0., 0.1)
            love.graphics.rectangle("fill", self.selStartX, self.selStartY, self.selW, self.selH)
            love.graphics.setColor(1, 0, 0., 1)
            love.graphics.rectangle("line", self.selStartX, self.selStartY, self.selW, self.selH)
            love.graphics.setColor(1, 1, 1., 1)
        end)
    end
end


return rectangle