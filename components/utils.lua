local utils = {}

utils.scissor = {}

-- Removes all entries equal to value from array
function utils.compact(array, v)
    local s = #array

    -- Init core counter
    local i = 1
    while i <= s and array[i] ~= v do
        i = i + 1
    end

    -- Shift loop
    local j = i + 1
    while j <= s do
        if array[j] ~= v then
            array[i] = array[j]
            i = i + 1
        end
        j = j + 1
    end

    -- Erase loop
    while i <= s do
        array[i] = nil
        i = i + 1
    end
end

-- Returns the given id plus num, modulo size, considering that lua starts arrays from 1
-- (So you can both increase and decrease the number and it will correctly wrap around in both cases)
function utils.advance(id, num, size)
    if size == 0 then
        return 1
    end
    return ((id + num - 1) % size) + 1
end

-- Helper functions to set multiple scissors and remove them
function utils.setScissor(px, py, w, h)
    table.insert(utils.scissor, {px, py, w, h})
    love.graphics.intersectScissor(px, py, w, h)
end

function utils.unsetScissor()
    love.graphics.setScissor()
    local s = table.remove(utils.scissor)

    if #utils.scissor > 0 then
        for i = 1, #utils.scissor do
            love.graphics.intersectScissor(unpack(utils.scissor[i]))
        end
    end
end

-- Helper function to draw a rotated rectangle
function utils.drawRotatedRectangle(angle, mode, x, y, width, height, round)
    -- We cannot rotate the rectangle directly, but we
    -- can move and rotate the coordinate system.
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
--  love.graphics.rectangle(mode, 0, 0, width, height) -- origin in the top left corner
    love.graphics.rectangle(mode, -width/2, -height/2, width, height, round) -- origin in the middle
    love.graphics.pop()
end

return utils
