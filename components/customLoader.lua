-- This is temporary - a proper solution is yet to be found.

if type(package.loaders) ~= "table" then
    error("package.searchers is not available in this environment.")
end

local function customLoader(moduleName)
    local modulePaths = {"./", "spellcomposer/"}  -- Add your module directories here

    for _, path in ipairs(modulePaths) do
        local filePath = path .. moduleName:gsub("%.", "/") .. ".lua"
        local file = io.open(filePath, "r")

        if file then
            local content = file:read("*a")
            file:close()
            return loadstring(content, filePath)  -- Load and return the module
        end
    end

    return "\nNo module found for " .. moduleName
end

table.insert(package.loaders, customLoader)