local builder = {}

-- HOW TO USE
-- ==========
--
-- The builder is an abstract concept of something that provides buildpower (and a scale variable to tune it) to another
-- builder (and a consumer ultimately utilizes it). It can be helped by other builders, and it can help a single other
-- builder.
--
-- One can add, update or remove other builders to one using the `registerHelper()`, `updateHelper()` and `unregisterHelper()`
-- functions. They will automatically and recursively update the buildpower of any builder chain (so that if you register a
-- helper and we are helping someone else, it will be correctly transfered).
--
-- This class does NOT do any distance checks! You should only register a builder as an helper to another when it can
-- actually help build whatever is being built; otherwise one can help building across the map which makes no sense. If
-- the unit moves too far or stops constructing for whatever reason, you need to temporarily unregister it as a helper and
-- re-register it later. That info is yours to manage. You can get info about what is being built by some builder by using
-- the `getTarget()` member function.
--
-- Note that constructions get assigned a default no-buildpower builder so that the GUI will be able to track it. All
-- other builders need to help that one in order to help build the construction.

-- Gets actual BP of the builder including helpers
local function getBP(self)
    return self.buildpower * self.scale
end

-- Sets the buildpower scale for this builder (scales all helpers as well)
local function setScale(self, scale)
    local oldBP = self:getBP()

    self.scale = scale

    if self.helping then
        self.helping:updateHelper(self, self:getBP() - oldBP)
    end
end

-- Registers a builder to help this one
local function registerHelper(self, otherBuilder)
    if self.helpers[otherBuilder] ~= nil then
        return
    end

    if otherBuilder.helping ~= nil then
        otherBuilder.helping:unregisterHelper(otherBuilder)
    end

    self.helpers[otherBuilder] = otherBuilder
    otherBuilder.helping = self

    self.buildpower = self.buildpower + otherBuilder:getBP()
end

-- Updates buildpower if an helper is modified
local function updateHelper(self, otherBuilder, bp)
    if self.helpers[otherBuilder] == nil then
        return
    end

    local oldBP = self:getBP()
    self.buildpower = self.buildpower + bp

    if self.helping then
        self.helping:updateHelper(self, self:getBP() - oldBP)
    end
end

-- Unregisters a builder from the helpers
local function unregisterHelper(self, otherBuilder)
    if self.helpers[otherBuilder] == nil then
        return
    end

    self.helpers[otherBuilder] = nil
    otherBuilder.helping = nil

    local oldBP = self:getBP()
    self.buildpower = self.buildpower - otherBuilder:getBP()

    if self.helping then
        self.helping:updateHelper(self, self:getBP() - oldBP)
    end
end

local function unregisterAllHelpers(self)
    local oldBP = self:getBP()

    for otherBuilder, _ in pairs(self.helpers) do
        self.helpers[otherBuilder] = nil
        otherBuilder.helping = nil

        self.buildpower = self.buildpower - otherBuilder:getBP()
        ::next::
    end

    local diff = self:getBP() - oldBP
    if self.helping and math.abs(diff) > 0 then
        self.helping:updateHelper(self, diff)
    end
end

local function getTarget(self)
    if self.target then
        return self.target
    end

    if self.helping then
        return self.helping:getTarget()
    end

    return nil
end

-- Creates a new builder
function builder:new(bp, scale, target)
    local b = {}

    -- Base stats
    b.buildpower = bp or 0
    b.scale = scale or 1
    b.target = target or nil

    -- Lists of other builders
    b.helpers = {}
    -- b.helping = nil

    -- Methods
    b.getBP = getBP
    b.setScale = setScale
    b.registerHelper = registerHelper
    b.updateHelper = updateHelper
    b.unregisterHelper = unregisterHelper
    b.unregisterAllHelpers = unregisterAllHelpers

    return b
end

return builder
