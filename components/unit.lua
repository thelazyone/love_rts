-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.

local unit = {}

function unit:new(x, y)

    local newObj = {}

    print ("creating new unit on: ", x, ", ", y)

    newObj.x = x
    newObj.y = y
    newObj.speed = 250
    newObj.targetX = x
    newObj.targetY = y
    newObj.radius = 10

    -- Level of patience for the Unit before giving up the order
    -- in case of collisions
    newObj.patience = 2
    newObj.frustration = 0 -- This will build up

    -- Flags
    newObj.selected = false

    -- State
    -- States can be:
    --
    -- idle -> doing nothing
    -- moving -> simple movement, ends in idle
    -- following -> movement, ends in interacting
    -- interacting -> interacts with another object within range
    --
    -- Other states might include attacking and such
    newObj.state = "idle"

    setmetatable(newObj, {__index = unit})

    return newObj
end


-- ##############################################
-- Graphics
-- ##############################################

-- Static function. The sprite is a circle
function unit:addToCanvas(canvas)
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


-- ##############################################
-- Logic
-- ##############################################

-- When asked, predicts the next move in xy that the unit would do.
-- This is necessary to the rtsWorld, which then handles collisions of sort
-- Returns a pair of x and y
function unit:getNextMove(dt)

    if self.state == "idle" then -- nothing to do
        return self.x, self.y
    end

    if self.state == "interacting" then -- in interaction mode, no need to move further.
        return self.x, self.y
    end

    if self.state == "moving" or state == "following" then
        -- If too close to the target, stopping.

        local minDistThreshold = 1

        local dist = (self.targetX - self.x)^2 + math.abs(self.targetY - self.y)^2
        if dist < (minDistThreshold * self.speed * dt) ^ 2 then
            self:commandStop()
            return self.x, self.y
        end

        -- Moving in the direction of the target
        direction = math.atan((self.targetY - self.y) / (self.targetX - self.x))
        if self.targetX - self.x < 0 then
            direction = direction + math.pi
        end

        -- Calculating the movement.
        local nextStepX = self.x + self.speed * math.cos(direction) * dt
        local nextStepY = self.y + self.speed * math.sin(direction) * dt
        return nextStepX, nextStepY
    end
end


function unit:setPos(x, y)
    self.x = x
    self.y = y 
end


-- ##############################################
-- State Machine Methods
-- This should handle potential forbidden state changes.
-- ##############################################

-- Move interrupts any other action and can be issued from any state
function unit:commandMove(targetX, targetY)
    print ("Sent command Move to ", targetX, targetY)
    self.targetX = targetX
    self.targetY = targetY
    self.state = "moving"
end

-- Stop can be issued from any state
function unit:commandStop()
    print ("Sent command Stop")
    self.state = "idle"
end 

return unit 