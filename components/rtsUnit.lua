-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.

local rtsUnit = {}
-- rtsUnit.x = 0
-- rtsUnit.y = 0
-- rtsUnit.speed = 250
-- rtsUnit.targetX = 0
-- rtsUnit.targetY = 0
-- rtsUnit.radius = 10

-- -- Level of patience for the Unit before giving up the order
-- -- in case of collisions
-- rtsUnit.patience = 2
-- rtsUnit.frustration = 0 -- This will build up

-- -- Flags
-- rtsUnit.selected = false
-- rtsUnit.isActive = false


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
    unit.patience = 2
    unit.frustration = 0 -- This will build up

    -- Flags
    unit.selected = false
    unit.isActive = false

    setmetatable(unit, {__index = rtsUnit})

    return unit
end


-- Static function. The sprite is a circle
function rtsUnit.addToCanvas(self, canvas)

    -- Drawing the circle.
    canvas:renderTo(function()
        if self.selected then
            love.graphics.setColor(1, .5, .5, 1)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        else 
            love.graphics.setColor(1, 1, 1., 1)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        end
        love.graphics.setColor(1, 1, 1., 1)
    end)
end


function rtsUnit.setTarget(self, targetX, targetY)
    self.targetX = targetX
    self.targetY = targetY
end    


-- function rtsUnit:update(unit, dt)


-- end

return rtsUnit 