local builder = {}

-- HOW TO USE
-- ==========
--
-- The builder is an abstract concept of something that provides buildpower (and a scale variable to tune it) to another
-- builder (and a consumer ultimately utilizes it). It can be helped by other builders, and it can help a single other
-- builder.
--
-- One can add, update or remove other builders to one using the `addHelper()`, `updateHelper()` and `removeHelper()`
-- functions. They will automatically and recursively update the buildpower of any builder chain (so that if you add a
-- helper and we are helping someone else, it will be correctly transfered).
--
-- This class does NOT do any distance checks! You should only add a builder as an helper to another when it can
-- actually help build whatever is being built; otherwise one can help building across the map which makes no sense. If
-- the unit moves too far or stops constructing for whatever reason, you need to temporarily remove it as a helper and
-- re-add it later. That info is yours to manage.
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
        self.helping:update(self, self:getBP() - oldBP)
    end
end

-- Adds a builder to help this one
local function addHelper(self, otherBuilder)
    if self.helpers[otherBuilder] ~= nil then
        return
    end

    if otherBuilder.helping ~= nil then
        otherBuilder.helping:leave(otherBuilder)
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
        self.helping:update(self, self:getBP() - oldBP)
    end
end

-- Removes a builder from the helpers
local function removeHelper(self, otherBuilder)
    if self.helpers[otherBuilder] == nil then
        return
    end

    self.helpers[otherBuilder] = nil
    otherBuilder.helping = nil

    local oldBP = self:getBP()
    self.buildpower = self.buildpower - otherBuilder:getBP()

    if self.helping then
        self.helping:update(self, self:getBP() - oldBP)
    end
end

-- Creates a new builder
function builder:new(bp, scale)
    local b = {}

    -- Base stats
    b.buildpower = bp or 0
    b.scale = scale or 1

    -- Lists of other builders
    b.helpers = {}
    -- b.helping = nil

    -- Methods
    b.getBP = getBP
    b.setScale = setScale
    b.addHelper = addHelper
    b.updateHelper = updateHelper
    b.removeHelper = removeHelper

    return b
end

return builder
