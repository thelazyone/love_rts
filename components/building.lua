local building = {}

function building:new(x, y)
    local newObj  = {}

    newObj.x = x
    newObj.y = y
    newObj.size = 20        -- Size in both w and h
    newObj.exists = false   -- When building is issued it's just a blueprint (semi transparent)
    newObj.health = 0.      -- Health goes from 0 to 1
    newObj.dead = false

    -- Working logic
    newObj.working = false
    newObj.selfWork = true
    newObj.workingProgress = 0      -- between 0 and 1, arbitrary construction progress
    newObj.produceCounter = 0
    newObj.productionSpeed = 0.1

    setmetatable(newObj, {__index = building})

    return newObj
end

function building:isOver(x, y)
    return x > self.x - self.size/2 and x < self.x + self.size/2 and y > self.y - self.size/2 and y < self.y + self.size/2
end

-- ##############################################
-- Graphics
-- ##############################################

-- Static function. The sprite is a circle
function building:addToCanvas(canvas)
    -- Drawing the circle.
    canvas:renderTo(function()

        -- If not built entirely, keeping it transparent
        local alphaValue = 1
        if not self.exists then
            alphaValue = 0.5
        end 

        if self.dead then
            return
        end

        -- Drawing the building in blue-grey, with a red overlay for the uncompleted part.
        love.graphics.setColor(.6, .6, 1., alphaValue)
        love.graphics.rectangle("fill", self.x - self.size/2, self.y - self.size/2, self.size, self.size)
        love.graphics.setColor(.6, 0, 0., alphaValue * .8)
        love.graphics.rectangle("fill", 
            self.x - self.size/2, 
            self.y - self.size/2,  
            self.size, 
            self.size * (1 - self.health))

        -- If in working mode, adding a small darker square
        if self.exists and (self.working or self.selfWork) then    
            love.graphics.setColor(.2, .2, 1., alphaValue)
            love.graphics.rectangle("fill", self.x - self.size/4, self.y - self.size/4, self.size/2, self.size/2)
            love.graphics.setColor(.4, .4, 1., alphaValue)
            love.graphics.rectangle("fill", 
            self.x - self.size/4, 
            self.y - self.size/4,  
            self.size/2, 
            self.size/2 * (1 - self.workingProgress))
            self.working = false
        end
    end)
end


function building:updateState(dt)
        -- Checking if health is maximum - in that case setting it to "exists"
        if not self.exists and self.health > .99 then
            self.exists = true
        end

        -- If health is below 0, it's removed.
        if self.health < 0 then
            self.dead = true
        end

        -- If existing, production is underway
        if self.exists then
            self.workingProgress = self.workingProgress + dt * self.productionSpeed
        end

        -- Working progress:
        if self.workingProgress > 1 then
            self.workingProgress = 0
            self.produceCounter = self.produceCounter + 1
            print ("produced one element. Total is ", self.produceCounter)
        end

        -- -- temporary just to see something TODO TBR
        -- self.health = math.min(1., self.health + dt)
end

return building
