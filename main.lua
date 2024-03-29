-- customLoader = require 'components.customloader'

local world = require 'components.world'
local camera = require 'components.camera'
local renderer = require 'components.renderer'
local rectangle = require 'components.selectionRectangle'
local button = require 'components.gui.button'
local resourceManager = require 'components.resourceManager'
local guiMaker = require 'components.gui'

-- Mouse last click.
local lastClickX = nil
local lastClickY = nil

-- Creating the buttons
local addUnitButton = button:new(20, 540, "add unit")
local buildThingButton = button:new(140, 540, "build factory")
local buildExtractButton = button:new(260, 540, "build extractor")
resourceManager.resource = 1.5
gui = {}

-- Last Button pressed. "none" is the default.
local lastButton = "none"

function love.load()
    love.window.setMode(800, 600, { resizable = false })

    renderer:initialize("resources/map.png", camera, rectangle)
    gui = guiMaker:new(love.graphics.getWidth(), love.graphics.getHeight())
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
    resourceManager:update(dt)
    gui:update(dt)
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
        elseif lastButton == "factory" then
            world:createBuilding(x, y, "factory")
            rectangle:hideSelection()

        -- if work, sending the selected units to do work on a building.
        elseif lastButton == "extractor" then
            world:createBuilding(x, y, "extractor")
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
            lastButton = "factory"
        elseif buildExtractButton:isInside(x, y) then
            lastButton = "extractor"
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
    if not lastClickX or not lastClickY then
        return
    end
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
    renderer:draw(world.units, world.buildings)

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
        if buildExtractButton:isInside(x, y) then
            buildExtractButton.isPressed = true
        end
    end

    -- Drawing the buttons:
    addUnitButton:draw()
    buildThingButton:draw()
    buildExtractButton:draw()

    gui:draw()
end
