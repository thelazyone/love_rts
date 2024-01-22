local builder = require 'components.builder'

local consumer = {}

local function tickCost(self, dt)
    local step = math.min((self.defaultBuilder:getBP() * dt) / self.timeCost, 1.0 - self.built)

    return self.resCost * step
end

local function construct(self, res)
    self.built = self.built + res / self.resCost
end

function consumer:new(res, time)
    local c = {}

    c.resCost = res
    c.timeCost = time
    c.decaySpeed = 0

    c.built = 0

    c.tickCost = tickCost
    c.construct = construct

    -- Builder to which all others must append so we can track shit.
    -- This one has no buildpower, the helpers will contribute allowing to actually build the building.
    c.defaultBuilder = builder:new(c)

    return c
end

return consumer
