local resourceManager = {}

resourceManager.produce = 0
resourceManager.resource = 0

-- NEED TO REGISTER:
--
-- PRODUCERS:
--   - JUST NEED A getProduction(dt) METHOD TELLING HOW MUCH THEY MAKE GIVEN DT
--
-- CONSUMERS:
--   - SEE COMPONENTS/RESOURCECONSUMER.LUA
--
-- STORAGE:
--   - JUST NEED A getStorage() METHOD TELLING HOW MUCH THEY CAN TAKE

resourceManager.currentResource = 0
resourceManager.currentProduction = 0
resourceManager.currentStorage = 0

resourceManager.producers = {}
resourceManager.consumers = {}
resourceManager.storage = {}

function resourceManager:update(dt)
    self.currentProduction = 0
    for k, v in pairs(self.producers) do
        self.currentProduction = self.currentProduction + v:getProduction(dt)
    end
    self.currentResource = self.currentResource + self.currentProduction

    local costs = 0 -- just in case
    for k, v in pairs(self.consumers) do
        local cost = math.min(v:tickCost(dt), self.currentResource)
        v:construct(cost)

        costs = costs + cost
        self.currentResource = self.currentResource - cost
    end

    self.currentStorage = 0
    for k, v in pairs(self.storage) do
        self.currentStorage = self.currentStorage + v:getStorage()
    end

    self.currentResource = math.min(self.currentResource, self.currentStorage)
end

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
