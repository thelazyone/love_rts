local bbox = {}

local geo = require 'components.geometry'

-- Returns a bounding box that contains the original one, rotated.
function bbox:rot(q, rot)
    local c1 = geo.toPos(q.w / 2, q.h / 2)
    local c2 = geo.toPos(q.w / 2, -q.h / 2)

    c1 = geo.rotRelPos(c1, rot)
    c2 = geo.rotRelPos(c2, rot)

    return bbox:new(math.max(math.abs(c1.x), math.abs(c2.x)) * 2, math.max(math.abs(c1.y), math.abs(c2.y)) * 2)
end

-- A very simple wrapper to put in a width and a height.
--
--     a.q = bbox:new(20,20)
--     print(a.q.w, a.q.h)
--
function bbox:new(w, h)
    local q = {}

    -- Can use these or radius, whatever you want.
    -- We set them both.
    q.w = w or 0
    q.h = h or 0
    q.rx = geo.length(geo.toPos(q.w / 2, q.h / 2))

    return q
end

return bbox
