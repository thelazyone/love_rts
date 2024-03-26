local gui = {}
local bbox = require 'components.boundingbox'
local geo = require 'components.geometry'

local rs = require 'components.resourceManager'

local button = require 'components.gui.button'
local pb = require 'components.gui.progressbar'

local function draw(self)
    self.storageBar:draw()
end

function gui:new(w, h)
    local g = {}

    g.q = bbox:new(w, h)

    local p = pb:new(rs, "currentResource", "currentStorage")
    g.storageBar = p
    p.p = geo.toPos(w/2 - p.q.w/2, 10)

    g.draw = draw

    return g
end

return gui
