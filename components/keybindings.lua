local keybindings = {}

-- System to handle keybinds generically.
--
-- You can define keybindings associated with things. You can then verify whether those keybindings are pressed using
-- the `match` and `verify` methods below. Example:
--
--    function love.keypressed(key)
--        if kb.match(kb.main.quit, key) then
--            love.event.quit()
--        end
--    end
local function addkeybind(t, name, keybind)
    t[name] = keybind
    table.insert(t, name)
end

-- ##### CUSTOM PART TO EDIT ####
--
-- WYSIWYG. Mod keys must be true for them to work. They are disabled if either they are not specified or false.

-- # EXAMPLE #
-- keybindings.main      = {}
-- addkeybind(keybindings.main, "quit", { key = "escape", mods = {ctrl=true},           desc = "Quit program"   })
-- addkeybind(keybindings.main, "help", { key = "h",      mods = {ctrl=true,alt=false}, desc = "Show/hide help" })

-- ##### END CUSTOM PART TO EDIT ####

-- Checks whether a given mod is pressed
function keybindings.matchMods(mods)
    if love.keyboard.isDown('lctrl', 'rctrl') ~= not not mods.ctrl then
        return false
    end
    if love.keyboard.isDown('lalt', 'ralt') ~= not not mods.alt then
        return false
    end
    if love.keyboard.isDown('lshift', 'rshift') ~= not not mods.shift then
        return false
    end

    return true
end

-- Function to check what key was pressed in key event (e.g. keydown())
function keybindings.match(entry, key)
    return entry.key == key and keybindings.matchMods(entry.mods)
end

-- Function to check what is pressed at runtime (e.g. update())
function keybindings.verify(entry)
    return keybindings.matchMods(entry.mods) and love.keyboard.isDown(entry.key)
end

-- Orderings when printing keybinding
keybindings.modorder = {"ctrl", "alt", "shift"}
keybindings.modsymbol = {"C", "A", "S"}

-- Function to pretty-print a given keybinding
function keybindings.tostr(entry, quote)
    quote = (quote ~= false)
    if entry.key == "" then
        if quote then
            return "'unbound'"
        else
            return "unbound"
        end
    end

    local str = {}
    if quote then
        str[#str + 1] = "'"
    end
    for i = 1, #keybindings.modorder do
        if entry.mods[keybindings.modorder[i]] then
            str[#str + 1] = keybindings.modsymbol[i] .. '-'
        end
    end

    str[#str + 1] = entry.key
    if quote then
        str[#str + 1] = "'"
    end

    return table.concat(str)
end

return keybindings
