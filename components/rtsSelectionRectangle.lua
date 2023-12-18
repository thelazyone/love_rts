local camera = require 'components/rtsCamera'


local rectangle = {}
rectangle.isSelectionVisible = false
rectangle.selStartX = 0
rectangle.selStartY = 0
rectangle.selW = 0
rectangle.selH = 0

-- Adding rectangle if present
function rectangle:showSelection(startX, startY, endX, endY)
    rectangle.isSelectionVisible = true
    rectangle.selStartX, rectangle.selStartY = camera:getCoordsOffset(startX, startY)
    rectangle.selW, rectangle.selH  =  endX - startX, endY - startY
end

-- Hides the bound rect
function rectangle:hideSelection()
    rectangle.isSelectionVisible = false
end

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

return rectangle