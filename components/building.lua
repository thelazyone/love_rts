local resourceManager = require 'components.resourceManager'
local resourceConsumer = require 'components.resourceConsumer'
local actor = require 'components.actor'

local building = {}

-- Enum
local Factory = "factory"
local Extractor = "extractor"

function building:new(x, y, buildingType)
    local newObj  = {}

    newObj.actor = actor:new(x, y, 40, 0)

    newObj.exists = false   -- When building is issued it's just a blueprint (semi transparent)
    newObj.dead = false

    newObj.buildingType = buildingType

    -- Working logic
    newObj.active = true
    -- newObj.workingProgress = 0      -- between 0 and 1, arbitrary construction progress

    if buildingType == Extractor then
        newObj.productionSpeed = 0.1
    end

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

-- function building:tryResourceToBuild(amount)
--     if resourceManager.resource > amount then
--         resourceManager.resource = resourceManager.resource - amount
--         self.actor.health = self.actor.health + amount
--     end
-- end
--
-- function building:tryResourceToProduce(amount)
--     if resourceManager.resource > amount then
--         resourceManager.resource = resourceManager.resource - amount
--         self.workingProgress = self.workingProgress + amount
--     else
--     end
--
-- end

function building:updateState(dt)
    -- Checking if health is maximum - in that case setting it to "exists"
    if not self.exists then
        if self.shade.built <= .99 then
            self.actor.health = self.shade.built
            return
        end

        self.exists = true
        -- Probably need a way in consumer to link built to some weighted property
        self.actor.health = 1

        if self.buildingType == Extractor then
            resourceManager:unregisterConsumer(self.shade)
            self.shade = nil

            self.getProduction = function(self, dt) return self.productionSpeed * dt end
            resourceManager:registerProducer(self)

            self.workingProgress = 1 -- square is always full
        elseif self.buildingType == Factory then
            -- Change name, so we keep all helper builders registered
            self.assemblyLine = self.shade
            self.shade = nil

            -- TODO: change price/time cost of production, not that important atm

            -- Reset build status
            self.assemblyLine.built = 0
            self.workingProgress = 0 -- Again need to decide a way to link values (pass dict + key usually works)
        end
        return
    end

    -- If health is below 0, it's removed.
    if self.actor.health < 0 then
        self.dead = true
    end

    -- Factory:
    if self.buildingType == Factory then
        -- if production is > 1, building is done
        if self.assemblyLine.built >= 1 then
            self.assemblyLine.built = 0
            resourceManager.produce = resourceManager.produce + 1
        end
        self.workingProgress = self.assemblyLine.built

    -- Extractor
    elseif self.buildingType == Extractor then

    -- Error:
    else
        print ("Wrong building type!", self.buildingType)
    end
end

-- ##############################################
-- Graphics
-- ##############################################

-- Static function. The sprite is a circle
function building:draw()
    -- If not built entirely, keeping it transparent
    local alphaValue = 1
    if not self.exists then
        alphaValue = 0.5
    end

    if self.dead then
        return
    end

    local colorTypeFactor = 1.
    if self.buildingType == Factory then
        colorTypeFactor = 1.
    elseif self.buildingType == Extractor then
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
end

return building
