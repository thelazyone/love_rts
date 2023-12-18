local rtsUnit = require 'components/rtsUnit'
local stepCalculation = require 'components/rtsStepCalculation'
local renderer = require 'components/rtsRenderer'
local camera = require 'components/rtsCamera'

local rtsWorld = {}

renderer:initialize("resources/map.png", camera)

-- Data
rtsWorld.units = {}
-- TODO add buildings or whatnot


-- Update function
function rtsWorld:update(dt)
    stepCalculation:moveAllUnits(self.units, dt)
end


-- Adds a new unit in the list.
function rtsWorld:createUnit(relativeX, relativeY)
    table.insert(self.units, rtsUnit:new(camera:getCoordsOffset(relativeX, relativeY)))
end


-- Issues a move command to all the selected units.
function rtsWorld:moveSelectedUnitsTo(targetX, targetY)
    for i = 1, #self.units do
        if self.units[i].selected then
            self.units[i]:commandMove(camera:getCoordsOffset(targetX, targetY))
        end
    end
end

return rtsWorld