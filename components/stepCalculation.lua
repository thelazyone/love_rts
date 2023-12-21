local collisionCheck = require 'components.collisionCheck'

local step = {}

-- Moving units, checking for collision if necessary.
-- This has a N^2 complexity and is NOT recommended, however what
-- most old-school RTS do is to set individual positions for the units at the target,
-- and I don't want to do that.
-- A better solution is to be expected.
function step:moveAllUnits(units, dt)

    -- Updating the collision check definition
    collisionCheck.units = units

    -- Iterating for all units
    for i = 1, #units do
        units[i]:move(dt)
    end
end

function step:activateAllUnits(units, dt)
    for i = 1, #units do
        units[i]:interact(dt)
        -- Checking if a unit is "interacting" with a building
        -- In that case, building a bit of it.
        -- TODO
    end
end

function step:activateAllBuildings(buildings, dt)
    for i = 1, #buildings do

        buildings[i]:updateState(dt)

        -- If a building exists, it consumes or produces resources
        -- TODO



    end
end   


return step