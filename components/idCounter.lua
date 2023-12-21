local idCounter = {}

idCounter.counter = 1

function idCounter:getId()
    self.counter = self.counter + 1
    return self.counter
end

return idCounter