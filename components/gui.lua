local gui = {}
local bbox = require 'components.boundingbox'
local geo = require 'components.geometry'
local colors = require 'components.colors'

local rs = require 'components.resourceManager'

local button = require 'components.gui.button'
local pb = require 'components.gui.progressbar'
local lc = require 'components.gui.livechart'

local function draw(self)
    self.storageBar:draw()

    -- Drawing resources
    love.graphics.setColor(colors.white)

    local resText = string.format('%d', math.floor(rs.currentResource))
    local txtW = love.graphics.getFont():getWidth(resText)
    love.graphics.print(resText, self.storageBar.p.x - txtW - 15, self.storageBar.p.y + (self.storageBar.q.h - 16)/2)
    love.graphics.print(tostring(rs.currentStorage), self.storageBar.p.x + self.storageBar.q.w + 15, self.storageBar.p.y + (self.storageBar.q.h - 16)/2)


    self.liveChart:draw()
end

local function update(self, dt)
    self.dt = self.dt + dt

    -- Only refresh stuff every X seconds
    local th = 0.05
    if self.dt > th then
        self.dt = self.dt - th

        self.liveChart:update()
    end
end

function gui:new(w, h)
    local g = {}

    g.dt = 0

    g.q = bbox:new(w, h)

    -- Progress bar at the top
    local p = pb:new(rs, "currentResource", "currentStorage")
    g.storageBar = p
    p.p = geo.toPos(w/2 - p.q.w/2, 10)

    -- In/Out at top right
    local c = lc:new(rs, {"currentProduction", "currentConsumption"})
    g.liveChart = c
    c.p = geo.toPos(w - c.q.w - 15, 10)

    g.draw = draw
    g.update = update

    return g
end

return gui
