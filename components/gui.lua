local gui = {}
local bbox = require 'components.boundingbox'

local function draw(self)
end


function gui:new(w, h)
    local g = {}

    g.q = bbox:new(w, h)

    g.draw = draw

    return g
end

return gui
