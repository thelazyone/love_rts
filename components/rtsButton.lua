local rtsButton = {}

function rtsButton:new(x, y, text)
    local button = {}

    button.x = x
    button.y = y 
    button.w = 100
    button.h = 50
    button.text = text
    button.isPressed = false

    print ("defined button with ", x, y, text)

    setmetatable(button, {__index = rtsButton})

    return button
end

function rtsButton:isInside(x, y)
    return x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h 
end

function rtsButton:draw()
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

return rtsButton