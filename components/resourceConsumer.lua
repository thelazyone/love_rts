local builder = require 'components.resourceBuilder'

local consumer = {}

-- HOW TO USE
-- ==========
--
-- This class is the entry point for things that need to eat resources. These things are all *consumers*, and they are
-- denoted by two numbers: resource cost and time cost.
--
-- The consumer is the class that actually interacts with the resourceManager (via called API) so that it actually
-- consumes resources.
--
-- However, the *speed* at which it can consume resources depends on how many builders are on it. Builders are described
-- more in depth in `components/resourceBuilder.lua`, but they essentially are composable entities that can collaborate
-- to provide build power to consumers.
--
-- Each consumer is assigned by default a builder with zero build power, which acts as the "attach" point for additional
-- builders. In this way, the consumer only needs to read the overall build power for its associated builder and noone
-- else.
--
-- Note that as long as you create a consumer and register it to the resource manager, you don't need to do anything
-- else here.
--
-- SEE ALSO: components/resourceBuilder.lua

-- Computes the resources we could actually consume this turn.
local function tickCost(self, dt)
    local step = math.min((self.defaultBuilder:getBP() * dt) / self.timeCost, 1.0 - self.built)

    return self.resCost * step
end

-- Increments the `built` counter
local function construct(self, res)
    self.built = math.min(self.built + res / self.resCost, 1.0)
    return self.built == 1.0
end

function consumer:new(res, time)
    local c = {}

    c.resCost = res
    c.timeCost = time

    -- TODO: actually need to add some logic to these for repeating tasks. If a task is not repeating, we could even
    -- self-destruct the consumer and detach any helper builders. I'm still adding them here to not forget about it.
    c.repeating = false
    c.cooldown = 0 -- Time between end construction and start of the next loop.

    -- This is probably going to be a common constant but I'm not sure exactly how it is in BAR.
    -- Also, not working yet.
    c.decaySpeed = 0

    -- Build percentage done [0,1]
    c.built = 0

    -- Attaching functions
    c.tickCost = tickCost
    c.construct = construct

    -- Associated builder to which all others must append so we can track shit.
    -- This one has no buildpower, the helpers will contribute allowing to actually build the building.
    c.defaultBuilder = builder:new(0, 1, c)

    return c
end

return consumer
