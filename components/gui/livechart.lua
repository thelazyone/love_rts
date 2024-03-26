local lc = {}

local geo = require 'geometry'
local box = require 'bbox'
local colors = require 'colors'
local ut = require 'utils'

local function update(self)
    self.values[ut.advance(self.tick,-1,self.len)] = self.table[self.keyv]
end

local function draw(self, pause)
    local k = self.tick

    local c = colors.cp(colors.lgray)
    c[3] = 0.5
    love.graphics.rectangle('fill', self.p.x, self.p.y, self.q.w, self.q.h)

    love.graphics.line(
        self.p.x, self.p.y,
        self.p.x + self.q.w, self.p.y + self.q.h
    )
    for i = 1, self.len do
        local barlength = math.max(1,self.values[k] / self.table[self.keymaxv] * (self.q.h - 2 * self.pad))
        if barlength > (self.q.h - 2 * self.pad) then
            print(barlength, self.values[k], self.table[self.keymaxv])
        end
        local x = self.p.x + self.pad + i - 1
        local starty = self.p.y + self.q.h - self.pad
        local midy = starty - barlength / 2
        local endy = starty - barlength

        love.graphics.setColor(colors.green)
        love.graphics.line(x, starty, x, midy)

        love.graphics.setColor(colors.red)
        love.graphics.line(x, midy, x, endy)

        love.graphics.setColor(colors.white)
        love.graphics.points(x - 0.5, endy + 0.5)

        k = ut.advance(k,1,self.len)
    end

    if not pause then
        self.tick = ut.advance(self.tick,1,self.len)
    end
end

function lc:new(table, keyv, keymaxv)
    local l = {}

    l.p = geo.toPos(10, 300)
    l.q = box:new(200, 80)
    l.pad = 5
    l.table = table
    l.keyv = keyv
    l.keymaxv = keymaxv

    l.tick = 1
    l.len = l.q.w - 2 * l.pad
    l.values = {}

    for i = 1, l.len do
        l.values[i] = 0
    end

    l.draw = draw
    l.update = update

    return l
end

return lc
