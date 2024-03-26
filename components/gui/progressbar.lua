local pbar = {}

local geo = require 'geometry'
local box = require 'bbox'
local colors = require 'colors'

local function draw(self)
    love.graphics.setColor(colors.white)
    love.graphics.rectangle('fill', self.p.x, self.p.y, self.q.w, self.q.h)

    local inwidth = self.q.w - self.pad*2
    local percentfilled = math.min(1.0, self.table[self.keyv] / self.table[self.keymaxv])
    local fillwidth = inwidth * percentfilled

    love.graphics.setColor(colors.dgreen)
    love.graphics.rectangle('fill', self.p.x + self.pad, self.p.y + self.pad, fillwidth, self.q.h - self.pad*2)
    love.graphics.setColor(colors.gray)
    love.graphics.rectangle('fill', self.p.x + self.pad + fillwidth, self.p.y + self.pad, inwidth - fillwidth, self.q.h - self.pad*2)
end

function pbar:new(table, keyv, keymaxv)
    local pb = {}

    pb.p = geo.toPos(10, 10)
    pb.q = box:new(100, 20)
    pb.pad = 2
    pb.draw = draw
    pb.table = table
    pb.keyv = keyv
    pb.keymaxv = keymaxv

    return pb
end

return pbar
