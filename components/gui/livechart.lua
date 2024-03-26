local lc = {}

local geo = require 'components.geometry'
local box = require 'components.boundingbox'
local colors = require 'components.colors'
local ut = require 'components.utils'

local function update(self)
    if not pause then
        self.max = 0.1
        for k = 1, #self.keys do
            self.values[k][self.tick] = self.table[self.keys[k]]
            self.max = math.max(self.max, math.max(unpack(self.values[k])))
        end
        self.tick = ut.advance(self.tick,1,self.len)
    end
end

local function draw(self, pause)
    local t = self.tick

    love.graphics.setColor(colors.gray)
    love.graphics.rectangle('fill', self.p.x, self.p.y, self.q.w, self.q.h)

    love.graphics.line(
        self.p.x, self.p.y,
        self.p.x + self.q.w, self.p.y + self.q.h
    )
    local tickVals = {}
    local starty = self.p.y + self.q.h - self.pad
    for i = 1, self.len do
        for k = 1, #self.keys do
            tickVals[k] = {k, self.values[k][t]}
        end
        table.sort(tickVals, function (left, right)
            return left[2] > right[2]
        end)

        local x = self.p.x + self.pad + i - 1
        for k = 1, #tickVals do
            local barlength = math.max(1, tickVals[k][2] / self.max * (self.q.h - 2 * self.pad))
            local endy = starty - barlength

            love.graphics.setColor(self.colors[tickVals[k][1]])
            love.graphics.line(x, starty, x, endy)
        end

        t = ut.advance(t,1,self.len)
    end
end

function lc:new(table, keys)
    local l = {}

    l.p = geo.toPos(10, 300)
    l.q = box:new(200, 80)
    l.pad = 5
    l.table = table
    l.keys = keys

    l.tick = 1
    l.len = l.q.w - 2 * l.pad
    l.values = {}
    l.colors = { colors.green, colors.red, colors.purple }

    for k = 1, #l.keys do
        l.values[k] = {}
        for i = 1, l.len do
            l.values[k][i] = 0
        end
    end
    l.max = 0

    l.draw = draw
    l.update = update

    return l
end

return lc
