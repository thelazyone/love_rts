local collisionCheck = {}

units = {} -- reference to the units here

function collisionCheck:resolveCollision(id, x, y)

    local isCollision = false
    for i = 1, #self.units do
        
        -- simple distance check
        local distance2 = (x - self.units[i].actor.x)^2+(y - self.units[i].actor.y)^2 
        if not(self.units[i].actor.id == id) and distance2 < (2*self.units[i].actor.radius)^2 then
            return true
        end
    end
    return false
end

return collisionCheck