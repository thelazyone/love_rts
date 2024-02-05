local resourceManager = {}

resourceManager.produce = 0
resourceManager.resource = 0

-- HOW TO USE
-- ==========
--
-- Any producer, consumer or storage needs to register here. To be one (or more) of them, one needs to satisfy the
-- following API:
--
--     PRODUCERS (Generate resource):
--       - They need a `getProduction(dt)` method telling how much they make given `dt`.
--
--     CONSUMERS (Require resource to do stuff):
--       - Actually need a consumer object inside.
--       - See details `components/resourceConsumer.lua`.
--
--     BUILDERS (Provides build power to siphon resource)
--       - Actually need a builder object inside.
--       - See CONSUMERS.
--
--     STORAGE (Allows to store more resource before overflow gets discarded):
--       - They need a `getStorage()` method telling how much they can take.

resourceManager.currentResource = 0
resourceManager.currentProduction = 0
resourceManager.currentStorage = 0

resourceManager.producers = {}
resourceManager.consumers = {}
resourceManager.storage = {}

-- Collects resources, takes what's needed to build, and stores the rest.
function resourceManager:update(dt)
    -- Compute production, and what's currently available
    self.currentProduction = 0
    for k, v in pairs(self.producers) do
        self.currentProduction = self.currentProduction + v:getProduction(dt)
    end
    self.currentResource = self.currentResource + self.currentProduction

    -- Consume what can be consumed.
    local costs = 0 -- just in case
    for k, v in pairs(self.consumers) do
        -- FIXME: would actually need to check total cost first, and if greater than what is available scale all
        -- constructors back (depending on priority) so that everything keeps building at once and not depending on
        -- order.
        local cost = math.min(v:tickCost(dt), self.currentResource)
        v:construct(cost)

        costs = costs + cost
        self.currentResource = self.currentResource - cost
    end

    -- If anything's left, see if we can store it.
    self.currentStorage = 0
    for k, v in pairs(self.storage) do
        self.currentStorage = self.currentStorage + v:getStorage()
    end

    self.currentResource = math.min(self.currentResource, self.currentStorage)
end

-- Registering and unregistering functions.
function resourceManager:registerProducer(obj)
    self.producers[obj] = obj
end

function resourceManager:registerConsumer(obj)
    self.consumers[obj] = obj
end

function resourceManager:registerStorage(obj)
    self.storage[obj] = obj
end

function resourceManager:unregisterProducer(obj)
    self.producers[obj] = nil
end

function resourceManager:unregisterConsumer(obj)
    self.consumers[obj] = nil
end

function resourceManager:unregisterStorage(obj)
    self.storage[obj] = nil
end

-- Default production
resourceManager:registerProducer({ getProduction = function(self, dt) return 1 * dt end })
-- Default storage
resourceManager:registerStorage({ getStorage = function(self) return 10 end })

return resourceManager