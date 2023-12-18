local camera = {}

camera.offsetX = 0
camera.offsetY = 0

function camera.getCoordsOffset(self, x, y)
    return (x - self.offsetX),  (y - self.offsetY)
end

-- Sets the visualization center on the coordinates.
function camera.setOffset(self, newX, newY)
    self.offsetX = newX
    self.offsetY = newY
end

-- Sets moves the Offset (to move the camera.)
function camera.moveOffset(self, moveX, moveY)
    self.offsetX = self.offsetX + moveX
    self.offsetY = self.offsetY + moveY
end


return camera