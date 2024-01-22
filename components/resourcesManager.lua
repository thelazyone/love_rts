local resourcesManager = {}

resourcesManager.produce = 0
resourcesManager.resource = 0

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

resourcesManager.currentResource = 0
resourcesManager.currentProduction = 0
resourcesManager.currentStorage = 0

resourcesManager.producers = {}
resourcesManager.consumers = {}
resourcesManager.storage = {}

function resourcesManager:update(dt)
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

function resourcesManager:registerProducer(obj)
    self.producers[obj] = obj
end

function resourcesManager:registerConsumer(obj)
    self.consumers[obj] = obj
end

function resourcesManager:registerStorage(obj)
    self.storage[obj] = obj
end

function resourcesManager:unregisterProducer(obj)
    self.producers[obj] = nil
end

function resourcesManager:unregisterConsumer(obj)
    self.consumers[obj] = nil
end

function resourcesManager:unregisterStorage(obj)
    self.storage[obj] = nil
end

-- Default production
resourcesManager:registerProducer({ getProduction = function(self, dt) return 1 * dt end })
-- Default storage
resourcesManager:registerStorage({ getStorage = function(self) return 10 end })

return resourcesManager
