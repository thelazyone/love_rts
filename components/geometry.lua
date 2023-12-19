local geo = {}

function geo.toPos(x, y)
    return { x = x, y = y }
end

function geo.cpPos(res, cp)
    res.x = cp.x
    res.y = cp.y
end

function geo.asPos(v)
    if v.x and v.y then
        return v
    end
    return { x = v[1], y = v[2] }
end

function geo.addPos(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

function geo.subPos(p1, p2)
    return { x = p1.x - p2.x, y = p1.y - p2.y }
end

function geo.addRad(a1, a2)
    return (a1 + a2) % (2 * math.pi)
end

function geo.subRad(a1, a2)
    return (a1 - a2) % (2 * math.pi)
end

function geo.toDeg(rad)
    return rad * 180.0 / math.pi
end

function geo.toRad(deg)
    return math.pi * deg / 180.0
end

-- Rotates position around the origin, uses radians
function geo.rotPos(rpos, rot)
    local retval = {}

    -- Standard clockwise rotation of radiant angle
    retval.x = (rpos.x) * math.cos(rot) - (rpos.y) * math.sin(rot)
    retval.y = (rpos.y) * math.cos(rot) + (rpos.x) * math.sin(rot)

    return retval
end

-- Distance between two points
function geo.dist(orig, other)
    return geo.length({ x = other.x - orig.x, y = other.y - orig.y})
end

-- Distance of point from origin
function geo.length(v)
    return math.sqrt(v.x * v.x + v.y * v.y)
end

-- Truncates precision up to num decimals
function geo.truncate(f, num)
    num = num or 2
    return tonumber(string.format("%." .. tostring(num) .. "f", f))
end

-- Computes origin radians angle to point
function geo.angleRel(p)
    return (math.atan2(p.y, p.x) + math.pi / 2.0) % (2 * math.pi)
end

-- Angle between points in radians
function geo.angle(p1, p2)
    return geo.angleRel({x = p2.x - p1.x, y = p2.y - p1.y})
end

-- Checks whether the input point is within the specified rectangle
function geo.insideRect(px, py, x, y, w, h)
    return (x <= px and px <= x + w and y <= py and py <= y + h)
end

-- input x,y position here is the center of the rectangle
function geo.insideRotRect(px, py, x, y, w, h, rot)
    -- Compute test point relative to rectangle center
    local rp = geo.toPos(px - x, py - y)
    -- Unrotate test point so it is in the same coordinate space as the rectangle
    rp = geo.rotRelPos(rp, -rot)
    -- Check inside using normal procedure, moving point back and using top-left corner reference
    return geo.insideRect(rp.x + x, rp.y + y, x - w/2, y - h/2, w, h)
end

-- Checks if point is inside given circle
function geo.insideCircle(px, py, x, y, r)
    return math.abs(geo.dist(geo.toPos(px, py), geo.toPos(x, y))) < r
end

return geo
