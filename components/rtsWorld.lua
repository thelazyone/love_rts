local rtsUnit = require 'components/rtsUnit'
local building = require 'components/building'
local stepCalculation = require 'components/rtsStepCalculation'
local renderer = require 'components/rtsRenderer'
local camera = require 'components/rtsCamera'

local world = {}

-- Data
world.units = {}
world.buildings = {}


-- Update function
function world:update(dt)
    stepCalculation:moveAllUnits(self.units, dt)
    stepCalculation:activateAllUnits(self.units, dt)
    stepCalculation:activateAllBuildings(self.buildings, dt)
end


-- Adds a new unit in the list.
function world:createUnit(relativeX, relativeY)
    table.insert(self.units, rtsUnit:new(camera:getCoordsOffset(relativeX, relativeY)))
end

function world:createBuilding(relativeX, relativeY)
    table.insert(self.buildings, building:new(camera:getCoordsOffset(relativeX, relativeY)))
end


-- Issues a move command to all the selected units.
function world:moveSelectedUnitsTo(targetX, targetY)
    for i = 1, #self.units do
        if self.units[i].selected then
            self.units[i]:commandMove(camera:getCoordsOffset(targetX, targetY))
        end
    end
end

return world