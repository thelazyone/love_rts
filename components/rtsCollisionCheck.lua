local collisionCheck = {}


function collisionCheck.resolveCollision(self, idx, units, x, y)

    local isCollision = false
    for i = 1, #units do
        local distance2 = (x - units[i].x)^2+(y - units[i].y)^2 
        local currentUnit = units[i]

        -- simple distance check
        if not(i == idx) and distance2 < (2*currentUnit.radius)^2 then
            return true
        end
    end
    return false

end

return collisionCheck