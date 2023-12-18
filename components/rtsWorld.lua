local rtsUnit = require 'components/rtsUnit'
local rtsMovement = require 'components/rtsMovement'
local rtsRenderer = require 'components/rtsRenderer'
local rtsCamera = require 'components/rtsCamera'

local rtsWorld = {}

rtsRenderer:initialize("resources/map.png", rtsCamera)

-- Units Data
rtsWorld.units = {}

-- Returns the global canvas
function rtsWorld.getImage(self, world)
    return rtsRenderer:getImage(self.units, rtsSelectionRectangle)
end

-- Update function
function rtsWorld.update(self, dt)
    rtsMovement:moveAllUnits(self.units, dt)
end

-- Sets the visualization center on the coordinates.
function rtsWorld.setOffset(self, newX, newY)
    rtsRenderer:setOffset(newX, newY)
end

-- Sets moves the Offset (to move the camera.)
function rtsWorld.moveOffset(self, moveX, moveY)
    rtsRenderer:moveOffset(moveX, moveY)
end

-- #########################################
-- Selection Rectangle
-- #########################################

-- Adding rectangle if present
function rtsWorld.showSelection(self, startX, startY, endX, endY)
    rtsRenderer:showSelection(startX, startY, endX, endY)
end

-- Hides the bound rect
function rtsWorld.hideSelection(self)
    rtsRenderer:hideSelection()
end


-- #########################################
-- Unit Handling
-- #########################################

-- Adds a new unit in the list.
function rtsWorld.createUnit(self, relativeX, relativeY)
    table.insert(self.units, rtsUnit:new(rtsCamera:coordsOffset(relativeX, relativeY)))
end

-- Selects units within a bound rect
function rtsWorld.selectUnits(self, startX, startY, endX, endY)
    for i = 1, #self.units do
        local startXLocal, startYLocal = rtsCamera:coordsOffset(math.min(startX, endX), math.min(startY, endY))
        local endXLocal, endYLocal = rtsCamera:coordsOffset(math.max(startX, endX), math.max(startY, endY))

        -- Solution 2: check any point of the circle units.
        -- Method found for c++ on https://www.geeksforgeeks.org/check-if-any-point-overlaps-the-given-circle-and-rectangle/
        rectBorderX = math.max(startXLocal, math.min(self.units[i].x, endXLocal))
        rectBorderY = math.max(startYLocal, math.min(self.units[i].y, endYLocal))
        local is_unit_selected = (rectBorderX - self.units[i].x)^2 + (rectBorderY - self.units[i].y)^2 < self.units[i].radius ^ 2

        if is_unit_selected then
            self.units[i].selected = true
        else
            self.units[i].selected = false
        end
    end
end


-- Issues a move command to all the selected units.
function rtsWorld.moveSelectedUnitsTo(self, targetX, targetY)
    for i = 1, #self.units do
        if self.units[i].selected then
            self.units[i]:commandMove(rtsCamera:coordsOffset(targetX, targetY))
        end
    end
end

return rtsWorld