-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.

local rtsUnit = {}
local minDistThreshold = 1

function rtsUnit:new(x, y)

    local unit = {}

    unit.x = x
    unit.y = y
    unit.speed = 250
    unit.targetX = x
    unit.targetY = y

    unit.selected = false

    return unit
end


-- Static function. The sprite is a circle
function rtsUnit:addToCanvas(unit, canvas)

    -- Drawing the circle.
    canvas:renderTo(function()
        if unit.selected then
            love.graphics.setColor(1, .5, .5, 1)
            love.graphics.circle("fill", unit.x, unit.y, 10)
        else 
            love.graphics.setColor(1, 1, 1., 1)
            love.graphics.circle("fill", unit.x, unit.y, 10)
        end
        love.graphics.setColor(1, 1, 1., 1)
    end)
end


function rtsUnit:setTarget(unit, targetX, targetY)
    unit.targetX = targetX
    unit.targetY = targetY
end    


function rtsUnit:update(unit, dt)

    -- If too close to the target, ignoring.
    local dist = (unit.targetX - unit.x)^2 + math.abs(unit.targetY - unit.y)^2
    if dist < (minDistThreshold * unit.speed * dt) ^ 2 then
        return
    end

    -- Moving in the direction of the target
    direction = math.atan((unit.targetY - unit.y) / (unit.targetX - unit.x))
    if unit.targetX - unit.x < 0 then
        direction = direction + math.pi
    end

    unit.x = unit.x + unit.speed * math.cos(direction) * dt
    unit.y = unit.y + unit.speed * math.sin(direction) * dt
end

return rtsUnit 