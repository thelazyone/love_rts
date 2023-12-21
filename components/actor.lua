local idCounter = require 'components.idCounter'
local geometry = require 'components.geometry'

-- Actors are all the objects on the map: Units, Buildings, wrecks, resources and vegetation.
-- Basically, everything that needs a sprite is an actor.

-- This is the only kind of unit currently implemented.
-- Trying to avoid inheritance, let's see how it goes with
-- more units.
local actor = {}

function actor:new(x, y, radius, health)

    local newObj = {}

    newObj.id = idCounter:getId()       -- An incremental counter is used for all actors.

    newObj.x = x                        -- X Map coordinates of the center of the object
    newObj.y = y                        -- Y Map coordinates of the center of the object
    newObj.radius = radius              -- Radial Hitbox. Used also for selection 
    newObj.health = health              -- Ideally actors can be destroyed

    -- Graphical params
    newObj.facing = 0                   -- Expressed as rad
    newObj.spriteSheet = ""

    setmetatable(newObj, {__index = actor})

    return newObj
end


-- Setting position.
function actor:setPos(x, y)
    self.x = x
    self.y = y 
end

-- Same as SetPos, but direction gets updated
function actor:moveTo(x, y)
    self.facing = geometry.angleRel({x = x - self.x, y = y - self.y})
    self:setPos(x,y)
end

return actor

