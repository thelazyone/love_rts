-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.

local rtsUnit = {}

function rtsUnit:new(x, y)

    local unit = {}

    unit.x = x
    unit.y = y

    return unit
end

-- Static function. The sprite is a circle
function rtsUnit:addToCanvas(unit, canvas)
    -- First drawing the original position circle.
    canvas:renderTo(function()
        love.graphics.circle("fill", unit.x, unit.y, 10)
    end)
end

return rtsUnit 