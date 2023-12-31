local button = {}

function button:new(x, y, text)
    local newObj = {}

    newObj.x = x
    newObj.y = y 
    newObj.w = 100
    newObj.h = 50
    newObj.text = text
    newObj.isPressed = false

    print ("defined button with ", x, y, text)

    setmetatable(newObj, {__index = button})

    return newObj
end

-- Checks if the xy coords are inside the button.
function button:isInside(x, y)
    return x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h 
end

-- Draws the button. If the "isPressed" is true it draws it lighter, but then sets "isPressed" to false.
function button:draw()
    love.graphics.setColor(.5, .5, .5, 1)
    if self.isPressed then
        love.graphics.setColor(.8, .8, .8, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    local margin = 10
    love.graphics.setColor(1, 1, 1., 1)
    love.graphics.print(self.text, self.x + margin, self.y + margin)
    self.isPressed = false
end

return button