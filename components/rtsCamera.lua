local rtsCamera = {}

rtsCamera.offsetX = 0
rtsCamera.offsetY = 0

function rtsCamera.coordsOffset(self, x, y)
    print("offset is ", self.offsetX, self.offsetY)
    return (x - self.offsetX),  (y - self.offsetY)
end

return rtsCamera