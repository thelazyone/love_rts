-- customLoader = require 'components.customloader'

local world = require 'components.world'
local camera = require 'components.camera'
local renderer = require 'components.renderer'
local rectangle = require 'components.selectionRectangle'
renderer:initialize("resources/map.png", camera, rectangle)
local button = require 'components.button'

-- Mouse last click.
local lastClickX = nil
local lastClickY = nil

-- Creating the buttons
local addUnitButton = button:new(20, 540, "add unit")
local buildThingButton = button:new(140, 540, "build")
local workAtButton = button:new(260, 540, "work")

-- Last Button pressed. "none" is the default.
local lastButton = "none"

function love.load()
    -- Nothing to do here
end

-- Controls
function love.update(dt)

    -- ####################################
    -- Arrows and WASD movement
    -- ####################################
    local moveSpeed = 5

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        camera:moveOffset(-moveSpeed, 0)
        updateDragArea(love.mouse.getPosition())
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        camera:moveOffset(moveSpeed, 0)
        updateDragArea(love.mouse.getPosition())
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        camera:moveOffset(0, -moveSpeed)
        updateDragArea(love.mouse.getPosition())
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        camera:moveOffset(0, moveSpeed)
        updateDragArea(love.mouse.getPosition())
    end

    -- Exit 
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    world:update(dt)
end


function love.mousepressed( x, y, button, istouch, presses )

    if button == 1 then
        lastClickX = x
        lastClickY = y 

        -- If no order is issued, it starts a rect drag.
        if lastButton == "none" then
            -- Nothing here 
        -- If add is set, creates a new worker
        elseif lastButton == "add" then
            world:createUnit(x, y)
            rectangle:hideSelection()

        -- If build is set, creates a new (unbuilt) building
        elseif lastButton == "build" then
            world:createBuilding(x, y)
            rectangle:hideSelection()

        -- if work, sending the selected units to do work on a building.
        elseif lastButton == "work" then
            rectangle:hideSelection()

        else 
            print("Bad Button Command: ", lastButton)
        end

        lastButton = "none"
    end

    --If right clicking, moving units to the point.
    if button == 2 then        
        world:moveSelectedUnitsTo(x, y)
        lastButton = "none"
    end
end


function love.mousereleased( x, y, button, istouch, presses)

    -- If button is released, a group of units could be selected
    if button == 1 and lastButton == "none" then
        updateDragArea(x, y)
        rectangle:selectUnits(world.units)
        rectangle:hideSelection()
    end

    -- BUTTONS
    if button == 1 then
        if addUnitButton:isInside(x, y) then
            lastButton = "add"
        elseif buildThingButton:isInside(x, y) then
            lastButton = "build"
        elseif workAtButton:isInside(x, y) then
            lastButton = "work"
        else 
            lastButton = "none"
        end
    end

    print ("mouse released, last button is ", lastButton)


end


function love.mousemoved( x, y, dx, dy, istouch )
    -- If mouse position is nil it means that no click has been done so far.
    if lastClickX == nil or lastClickY == nil then
        lastClickX = 0
        lastClickY = 0
    end

    -- Drawing an overlayed rectangle to indicate what has been selected
    updateDragArea(x, y)
end


function updateDragArea(x, y)
    local rectThreshold = 2
    local distance = math.abs(lastClickX - x) + math.abs(lastClickY - y)
    if love.mouse.isDown(1) and distance > rectThreshold then
        rectangle:showSelection(math.min(lastClickX, x), math.min(lastClickY, y), math.max(lastClickX, x), math.max(lastClickY, y))
    else
        rectangle:setSelection(math.min(lastClickX, x), math.min(lastClickY, y), math.max(lastClickX, x), math.max(lastClickY, y))
    end
end


-- Final Drawing
function love.draw()

    -- Drawing the world
    love.graphics.draw(renderer:getImage(world.units, world.buildings))

    -- The buttons should be elsewhere, these are temporary.
    -- Checking button pressed logic:
    if love.mouse.isDown(1) then
        local x,y = love.mouse.getPosition()
        if addUnitButton:isInside(x, y) then
            addUnitButton.isPressed = true
        end
        if buildThingButton:isInside(x, y) then
            buildThingButton.isPressed = true
        end
        if workAtButton:isInside(x, y) then
            workAtButton.isPressed = true
        end
    end

    -- Drawing the buttons:
    addUnitButton:draw()
    buildThingButton:draw()
    workAtButton:draw()
end
