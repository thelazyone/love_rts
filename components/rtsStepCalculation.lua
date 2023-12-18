local rtsCollisionCheck = require 'components/rtsCollisionCheck'

local step = {}

-- Moving units, checking for collision if necessary.
-- This has a N^2 complexity and is NOT recommended, however what
-- most old-school RTS do is to set individual positions for the units at the target,
-- and I don't want to do that.
-- A better solution is to be expected.
function step:moveAllUnits(units, dt)
    for i = 1, #units do

        local currentUnit = units[i]
        local nextX, nextY = currentUnit:getNextMove(dt)
        if rtsCollisionCheck:resolveCollision(i, units, nextX, nextY) then
            currentUnit.frustration = currentUnit.frustration + dt
            if currentUnit.frustration > currentUnit.patience then
                print("unit got frustrated!")
                currentUnit:commandStop()
            end     
        else
            currentUnit:setMove(nextX, nextY)
            currentUnit.frustration = 0
        end
    end
end

return step