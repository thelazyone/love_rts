local collisionCheck = require 'components.collisionCheck'
local resourceBuilder = require 'components.resourceBuilder'
local actor = require 'components.actor'

-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.
local unit = {}

function unit:new(x, y)

    local newObj = {}

    print ("creating new unit on: ", x, ", ", y)

    newObj.actor = actor:new(x, y, 10, 1)

    newObj.speed = 250
    newObj.targetX = x
    newObj.targetY = y
    newObj.targetObj = nil
    newObj.buildSpeed = .05

    -- Level of patience for the Unit before giving up the order
    -- in case of collisions
    newObj.patience = 2
    newObj.frustration = 0 -- This will build up

    -- Flags
    newObj.selected = false
    newObj.interacting = false

    -- State
    -- States can be:
    --
    -- idle -> doing nothing
    -- moving -> simple movement, ends in idle
    -- following -> movement, ends in interacting
    -- reaching -> moving to interact
    -- interacting -> interacts with another object within range
    --
    -- Other states might include attacking and such
    newObj.state = "idle"
    newObj.builder = resourceBuilder:new(0.25)

    setmetatable(newObj, {__index = unit})

    return newObj
end

-- ##############################################
-- Logic
-- ##############################################

function unit:hasArrived(dt, threshold)
    local dist = (self.targetX - self.actor.x)^2 + math.abs(self.targetY - self.actor.y)^2
    if dist < (threshold) ^ 2 then
        return true
    end

    return false
end

function unit:calculateMovement(dt)
    -- Moving in the direction of the target
    direction = math.atan((self.targetY - self.actor.y) / (self.targetX - self.actor.x))
    if self.targetX - self.actor.x < 0 then
        direction = direction + math.pi
    end

    -- Calculating the movement.
    local nextStepX = self.actor.x + self.speed * math.cos(direction) * dt
    local nextStepY = self.actor.y + self.speed * math.sin(direction) * dt
    return nextStepX, nextStepY
end

function unit:tryMovingTo(nextX, nextY)
    if collisionCheck:resolveCollision(self.actor.id, nextX, nextY) then

        -- Unit collided

        -- -- TEMPORARLY COMMENTED OUT - it works but it might be unnecessary
        -- -- Implementing frustration
        -- if self.state == "moving" or self.state == "interacting" then
        --     self.frustration = self.frustration + dt
        --     if self.frustration > self.patience then
        --         print("unit got frustrated!")
        --         currentUnit:commandStop()
        --         return false
        --     end
        -- end

        return false
    else
        -- Unit moved OK
        self.actor:moveTo(nextX, nextY)
        self.frustration = 0
        return true
    end
end

-- When asked, predicts the next move in xy that the unit would do.
-- This is necessary to the rtsWorld, which then handles collisions of sort
-- Returns a pair of x and y
function unit:move(dt)

    if self.state == "idle" then -- nothing to do
        return false
    elseif self.state == "moving" then

        -- If too close to the target, stopping.
        if self:hasArrived(dt, 10) then
            print ("stop sent from moving")
            self:commandStop()
            return false
        end

        return self:tryMovingTo(self:calculateMovement(dt))

    elseif self.state == "following" then
        -- If a target obj exists calculating position
        if self.targetObj == nil then
            print ("stop sent from following")
            self:commandStop()
            return false
        else
            self.targetX = self.targetObj.x
            self.targetY = self.targetObj.y
        end

        return self:tryMovingTo(self:calculateMovement(dt))

    elseif self.state == "interacting" then

        -- If too close to the target, not moving but remain in interact.
        if self.targetObj == nil then
            print ("stop sent from interacting")
            self:commandStop()
            return false
        elseif self:hasArrived(dt, 40) then
            return false
        end

        return self:tryMovingTo(self:calculateMovement(dt))

    else
        print ("Warning, state is wrong: ", self.state)
        return false
    end
end

function unit:interact(dt)

    -- Checking if there's anything to interact to and if the state is right.
    if self.state == "interacting" then

        -- Checking if object has the right fields
        if self.targetObj.actor.health == nil or self.targetObj.exists == nil then
            print ("object has no proper parameters to interact with!!")
        end

        -- Checking if in range:
        if not self:hasArrived(dt, 50) then
            if self.builder.helping then
                self.builder.helping:unregisterHelper(self.builder)
            end
            return
        end

        -- Showing the interaction
        self.interacting = true

        -- Passing resources to the object:
        -- If not built yet, building
        if not self.targetObj.exists then
            self.targetObj.shade.defaultBuilder:registerHelper(self.builder)
        -- Otherwise help functioning
        else
            -- If extractor, nothing to do.
            if self.targetObj.buildingType == "extractor" then
                return
            end

            -- If Factory, helping to produce.
            if self.targetObj.buildingType == "factory" then
                self.targetObj.assemblyLine.defaultBuilder:registerHelper(self.builder)
            end
        end
    else
        if self.builder.helping then
            self.builder.helping:unregisterHelper(self.builder)
        end
    end
end

-- ##############################################
-- State Machine Methods
-- This should handle potential forbidden state changes.
-- ##############################################

-- Move interrupts any other action and can be issued from any state
function unit:commandMove(targetX, targetY)
    self.interacting = false
    self.targetX = targetX
    self.targetY = targetY
    self.targetObj = nil
    print ("Sent command Move to ", targetX, targetY)
    self.state = "moving"
end

function unit:commandInteract(obj)
    self.interacting = false -- Will get true only when reaching the target
    self.targetX = obj.actor.x
    self.targetY = obj.actor.y
    self.targetObj = obj
    print ("Sent command Interact to ", self.targetX, self.targetY,self.targetObj)
    self.state = "interacting"
end

-- Stop can be issued from any state
function unit:commandStop()
    print ("Sent command Stop")
    self.interacting = false
    self.targetObj = nil
    self.state = "idle"
end

-- ##############################################
-- Graphics
-- ##############################################

-- Static function. The sprite is a circle
function unit:draw()
    if self.selected then
        love.graphics.setColor(1, .5, .5, 1)
        love.graphics.circle("fill", self.actor.x, self.actor.y, self.actor.radius)
    else
        love.graphics.setColor(1, 1, 1., 1)
        love.graphics.circle("fill", self.actor.x, self.actor.y, self.actor.radius)
    end

    -- if interacting adding a smaller circle
    if self.interacting then
        love.graphics.setColor(.5, .2, .2, 1)
        love.graphics.circle("fill", self.actor.x, self.actor.y, self.actor.radius/2)
    end
end

return unit
