local building = {}

function building:new(x, y)
    local newObj  = {}

    newObj.x = x
    newObj.y = y
    newObj.size = 20        -- Size in both w and h
    newObj.exists = false   -- When building is issued it's just a blueprint (semi transparent)
    newObj.health = 0.      -- Health goes from 0 to 1
    newObj.dead = false

    setmetatable(newObj, {__index = building})

    return newObj
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

        -- temporary just to see something TODO TBR
        self.health = math.min(1., self.health + dt)
end

return building
