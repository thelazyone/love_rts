local resourcesManager = require 'components.resourcesManager'

local building = {}

function building:new(x, y, buildingType)
    local newObj  = {}

    newObj.x = x
    newObj.y = y
    newObj.size = 20        -- Size in both w and h
    newObj.exists = false   -- When building is issued it's just a blueprint (semi transparent)
    newObj.health = 0.      -- Health goes from 0 to 1
    newObj.dead = false

    newObj.buildingType = buildingType

    -- Working logic
    newObj.active = true
    newObj.workingProgress = 0      -- between 0 and 1, arbitrary construction progress
    newObj.productionSpeed = 0.1

    setmetatable(newObj, {__index = building})

    print("crating building with ", x, y, buildingType)

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
        love.graphics.rectangle("fill", self.x - self.size/2, self.y - self.size/2, self.size, self.size)
        love.graphics.setColor(.6 * colorTypeFactor, 0, 0., alphaValue * .8)
        love.graphics.rectangle("fill", 
            self.x - self.size/2, 
            self.y - self.size/2,  
            self.size, 
            self.size * (1 - self.health))

        -- If in working mode, adding a small darker square
        if self.exists and self.active then    
            love.graphics.setColor(.2 * colorTypeFactor, .2, 1., alphaValue)
            love.graphics.rectangle("fill", self.x - self.size/4, self.y - self.size/4, self.size/2, self.size/2)
            love.graphics.setColor(.4 * colorTypeFactor, .4, 1., alphaValue)
            love.graphics.rectangle("fill", 
            self.x - self.size/4, 
            self.y - self.size/4,  
            self.size/2, 
            self.size/2 * (1 - self.workingProgress))
        end
    end)
end


function building:tryResourceToBuild(amount)
    if resourcesManager.resource > amount then
        resourcesManager.resource = resourcesManager.resource - amount
        self.health = self.health + amount
    end
end

function building:tryResourceToProduce(amount)
    if resourcesManager.resource > amount then
        resourcesManager.resource = resourcesManager.resource - amount
        self.workingProgress = self.workingProgress + amount
    else
    end

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

    -- Factory:
    if self.buildingType == "factory" then

        -- building if possible
        if self.exists then
            self:tryResourceToProduce(dt * self.productionSpeed)    
        end

        -- if production is > 1, building is done
        if self.workingProgress > 1 then
            self.workingProgress = 0
            resourcesManager.produce = resourcesManager.produce + 1
        end

    -- Extractor
    elseif self.buildingType == "extractor" then
        
        -- produces resources.
        self.workingProgress = 1 -- square is always full
        if self.exists then
            resourcesManager.resource = resourcesManager.resource + dt * self.productionSpeed
        end

    -- Error:
    else
        print ("Wrong building type!", self.buildingType)
    end
end

return building
