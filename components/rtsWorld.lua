local rtsMap = require 'components/rtsMap'
local rtsUnit = require 'components/rtsUnit'


local rtsWorld = {}
rtsWorld.screenW = 800
rtsWorld.screenH = 600
rtsWorld.offsetX = 0
rtsWorld.offsetY = 0

-- Map Data
rtsWorld.map = rtsMap:new(love.image.newImageData("resources/map.png"))

-- Units Data
rtsWorld.units = {}

-- Selection rectangle
rtsWorld.isSelectionVisible = false
rtsWorld.selStartX = 0
rtsWorld.selStartY = 0
rtsWorld.selW = 0
rtsWorld.selH = 0


-- returns the global canvas
function rtsWorld.getImage(self, world)

    -- The local canvas is to compose the parts before rendering.
    local canvas = love.graphics.newCanvas(self.map.w, self.map.h)

    -- Adding the background map.
    canvas:renderTo(function()
        love.graphics.draw(love.graphics.newImage(self.map:getImage()))
    end)

    -- Drawing Units
    for i = 1, #self.units do
        self.units[i]:addToCanvas(canvas)
    end

    -- Showing the rectangle on top of the units:
    if self.isSelectionVisible then
        canvas:renderTo(function()
            love.graphics.setColor(1, 0, 0., 0.1)
            love.graphics.rectangle("fill", self.selStartX, self.selStartY, self.selW, self.selH)
            love.graphics.setColor(1, 0, 0., 1)
            love.graphics.rectangle("line", self.selStartX, self.selStartY, self.selW, self.selH)
            love.graphics.setColor(1, 1, 1., 1)
        end)
    end

    -- overriding the visible world content with the world image, shifted.
    local allWorld = canvas:newImageData()
    local visibleWorld = love.image.newImageData(self.screenW, self.screenH)
    visibleWorld:paste(
        allWorld,
        self.offsetX,
        self.offsetY,
        0,
        0,
        self.map.w,
        self.map.h)

    outImage = love.graphics.newImage(visibleWorld)
    return outImage

end

-- Update function
function rtsWorld.update(self, dt)


    -- Moving units, checking for collision if necessary.
    -- This has a N^2 complexity and is NOT recommended, however what
    -- most old-school RTS do is to set individual positions for the units at the target,
    -- and I don't want to do that.
    -- A better solution is to be expected.
    for i = 1, #self.units do

        local currentUnit = self.units[i]
        local nextX, nextY = currentUnit:getNextMove(dt)

        -- Checking if the position doesn't collide with others, in that case not moving.
        local isCollision = false
        for j = 1, #self.units do
            if not(i == j) and (nextX - self.units[j].x)^2+(nextY - self.units[j].y)^2 < (2*currentUnit.radius)^2 then
                isCollision = true
                currentUnit.frustration = currentUnit.frustration + dt
                if currentUnit.frustration > currentUnit.patience then
                    print("unit got frustrated!")
                    currentUnit:commandStop()
                end
            end
        end

        if isCollision == false then
            -- Updating the movement
            currentUnit.x = nextX
            currentUnit.y = nextY

            -- Resetting the frustration: the unit can move
            currentUnit.frustration = 0
        end
    end
end

-- Sets the visualization center on the coordinates.
function rtsWorld.setOffset(self, newX, newY)
    self.offsetX = newX
    self.offsetY = newY
end

function rtsWorld.moveOffset(self, moveX, moveY)
    self.offsetX = self.offsetX + moveX
    self.offsetY = self.offsetY + moveY
end

-- Adding rectangle if present
function rtsWorld.showSelection(self, startX, startY, endX, endY)
    self.isSelectionVisible = true
    self.selStartX = startX - self.offsetX
    self.selStartY = startY - self.offsetY
    self.selW = endX - startX
    self.selH = endY - startY
end

function rtsWorld.hideSelection(self)
    self.isSelectionVisible = false
end


-- Unit Handling

function rtsWorld.createUnit(self, relativeX, relativeY)
    table.insert(self.units, rtsUnit:new(relativeX - self.offsetX, relativeY - self.offsetY))
end

function rtsWorld.selectUnits(self, startX, startY, endX, endY)
    for i = 1, #self.units do
        local startXLocal = math.min(startX, endX) - self.offsetX
        local startYLocal = math.min(startY, endY) - self.offsetY
        local endXLocal = math.max(startX, endX) - self.offsetX
        local endYLocal = math.max(startY, endY) - self.offsetY

        -- Solution 2: check any point of the circle units.
        -- Method found for c++ on https://www.geeksforgeeks.org/check-if-any-point-overlaps-the-given-circle-and-rectangle/
        rectBorderX = math.max(startXLocal, math.min(self.units[i].x, endXLocal))
        rectBorderY = math.max(startYLocal, math.min(self.units[i].y, endYLocal))
        local is_unit_selected = (rectBorderX - self.units[i].x)^2 + (rectBorderY - self.units[i].y)^2 < self.units[i].radius ^ 2

        if is_unit_selected then
            self.units[i].selected = true
        else
            self.units[i].selected = false
        end
    end
end


function rtsWorld.moveSelectedUnitsTo(self, targetX, targetY)
    for i = 1, #self.units do
        if self.units[i].selected then
            self.units[i]:setTarget(targetX - self.offsetX, targetY - self.offsetY)
            self.units[i]:commandMove()
        end
    end
end

return rtsWorld