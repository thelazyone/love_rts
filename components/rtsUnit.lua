-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.

local rtsUnit = {}

function rtsUnit:new(x, y)

    local unit = {}

    unit.x = x
    unit.y = y
    unit.speed = 250
    unit.targetX = x
    unit.targetY = y
    unit.radius = 10

    -- Level of patience for the Unit before giving up the order
    -- in case of collisions
    unit.patience = 10
    unit.frustration = 0 -- This will build up

    -- Flags
    unit.selected = false
    unit.isActive = false

    return unit
end


-- Static function. The sprite is a circle
function rtsUnit:addToCanvas(unit, canvas)

    -- Drawing the circle.
    canvas:renderTo(function()
        if unit.selected then
            love.graphics.setColor(1, .5, .5, 1)
            love.graphics.circle("fill", unit.x, unit.y, unit.radius)
        else 
            love.graphics.setColor(1, 1, 1., 1)
            love.graphics.circle("fill", unit.x, unit.y, unit.radius)
        end
        love.graphics.setColor(1, 1, 1., 1)
    end)
end


function rtsUnit:setTarget(unit, targetX, targetY)
    unit.targetX = targetX
    unit.targetY = targetY
    print ("sending ", unit, " to ", targetX, ", ", targetY)
end    


-- function rtsUnit:update(unit, dt)


-- end

return rtsUnit 