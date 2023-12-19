local unit = require 'components.unit'
local building = require 'components.building'
local stepCalculation = require 'components.stepCalculation'
local renderer = require 'components.renderer'
local camera = require 'components.camera'
local rectangle = require 'components.selectionRectangle'

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
    table.insert(self.units, unit:new(camera:getCoordsOffset(relativeX, relativeY)))
end

function world:createBuilding(relativeX, relativeY)
    table.insert(self.buildings, building:new(camera:getCoordsOffset(relativeX, relativeY)))
    print("debug", self.buildings[1].x, self.buildings[1].y)
end


function world:getHoveredBuilding()

    -- Searching the buildings in reverse order for the first to be in a position.
    for i = 1, #self.buildings do
        if self.buildings[#self.buildings - i + 1]:isOver(love.mouse.getPosition()) then
            return i
        end
    end
    return -1
end

-- Issues a move command to all the selected units.
function world:moveSelectedUnitsTo(targetX, targetY)

    selectedBuilding = self:getHoveredBuilding()

    for i = 1, #self.units do
        if self.units[i].selected then
            if selectedBuilding == -1 then
                self.units[i]:commandMove(camera:getCoordsOffset(targetX, targetY))
            else
                self.units[i]:commandInteract(self.buildings[selectedBuilding])
            end
        end
    end
end

return world