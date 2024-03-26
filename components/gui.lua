local gui = {}
local bbox = require 'components.boundingbox'
local geo = require 'components.geometry'
local colors = require 'components.colors'

local rs = require 'components.resourceManager'

local button = require 'components.gui.button'
local pb = require 'components.gui.progressbar'

local function draw(self)
    self.storageBar:draw()

    -- Drawing resources
    love.graphics.setColor(colors.white)

    local resText = string.format('%d', math.floor(rs.currentResource*100))
    local txtW = love.graphics.getFont():getWidth(resText)
    love.graphics.print(resText, self.storageBar.p.x - txtW - 15, self.storageBar.p.y + (self.storageBar.q.h - 16)/2)
    love.graphics.print(tostring(rs.currentStorage*100), self.storageBar.p.x + self.storageBar.q.w + 15, self.storageBar.p.y + (self.storageBar.q.h - 16)/2)
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
