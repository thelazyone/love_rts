local resourceManager = require 'components.resourceManager'
local resourceConsumer = require 'components.resourceConsumer'
local actor = require 'components.actor'

local building = {}

function building:new(x, y, buildingType)
    local newObj  = {}

    newObj.actor = actor:new(x, y, 40, 0)

    newObj.exists = false   -- When building is issued it's just a blueprint (semi transparent)
    newObj.dead = false

    newObj.buildingType = buildingType

    -- Working logic
    newObj.active = true
    newObj.workingProgress = 0      -- between 0 and 1, arbitrary construction progress
    newObj.productionSpeed = 0.1

    setmetatable(newObj, {__index = building})

    print("crating building with ", x, y, buildingType)
    newObj.shade = resourceConsumer:new(1.0, 1.0)
    resourceManager:registerConsumer(newObj.shade)

    return newObj
end

function building:isOver(x, y)
    return 
        x > self.actor.x - self.actor.radius/2 and x < self.actor.x + self.actor.radius/2 and 
        y > self.actor.y - self.actor.radius/2 and y < self.actor.y + self.actor.radius/2
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

        local colorTypeFactor = 1.
        if self.buildingType == "factory" then
            colorTypeFactor = 1.
        elseif self.buildingType == "extractor" then
            colorTypeFactor = .2
        else
            print ("Error, building type wrong: ", self.buildingType)
        end

        -- Drawing the building in blue-grey, with a red overlay for the uncompleted part.
        love.graphics.setColor(.6 * colorTypeFactor, .6, 1., alphaValue)
        love.graphics.rectangle("fill",
            self.actor.x - self.actor.radius/2, 
            self.actor.y - self.actor.radius/2, 
            self.actor.radius, 
            self.actor.radius)
        love.graphics.setColor(.6 * colorTypeFactor, 0, 0., alphaValue * .8)
        love.graphics.rectangle("fill", 
            self.actor.x - self.actor.radius/2, 
            self.actor.y - self.actor.radius/2,  
            self.actor.radius, 
            self.actor.radius * (1 - self.actor.health))

        -- If in working mode, adding a small darker square
        if self.exists and self.active then    
            love.graphics.setColor(.2 * colorTypeFactor, .2, 1., alphaValue)
            love.graphics.rectangle("fill", 
                self.actor.x - self.actor.radius/4, 
                self.actor.y - self.actor.radius/4, 
                self.actor.radius/2, 
                self.actor.radius/2)
            love.graphics.setColor(.4 * colorTypeFactor, .4, 1., alphaValue)
            love.graphics.rectangle("fill", 
                self.actor.x - self.actor.radius/4, 
                self.actor.y - self.actor.radius/4,  
                self.actor.radius/2, 
                self.actor.radius/2 * (1 - self.workingProgress))
        end
    end)
end


function building:tryResourceToBuild(amount)
    if resourceManager.resource > amount then
        resourceManager.resource = resourceManager.resource - amount
        self.actor.health = self.actor.health + amount
    end
end

function building:tryResourceToProduce(amount)
    if resourceManager.resource > amount then
        resourceManager.resource = resourceManager.resource - amount
        self.workingProgress = self.workingProgress + amount
    else
    end

end


function building:updateState(dt)
    -- Checking if health is maximum - in that case setting it to "exists"
    if not self.exists and self.actor.health > .99 then
        self.exists = true
        resourceManager:unregisterConsumer(self.shade)
        self.shade = nil

        if self.buildingType == "extractor" then
            self.getProduction = function(self, dt) return self.productionSpeed * dt end
            resourceManager:registerProducer(self)
        end
    end

    -- If health is below 0, it's removed.
    if self.actor.health < 0 then
        self.dead = true
    end

    -- Factory:
    if self.buildingType == "factory" then

        -- building if possible
        if self.exists then
            self:tryResourceToProduce(dt * self.productionSpeed)    
        end

        -- if production is > 1, building is done
        if self.workingProgress > 1 then
            self.workingProgress = 0
            resourceManager.produce = resourceManager.produce + 1
        end

    -- Extractor
    elseif self.buildingType == "extractor" then
        
        -- produces resources.
        self.workingProgress = 1 -- square is always full
        if self.exists then
            resourceManager.resource = resourceManager.resource + dt * self.productionSpeed
        end

    -- Error:
    else
        print ("Wrong building type!", self.buildingType)
    end
end

return building
