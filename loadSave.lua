local M = {}
 
local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
 

function M.saveData(value, fileName, location)
         
    local loc = location

    if not loc then 
        loc = defaultLocation
    end

    local path = system.pathForFile(fileName, loc)

    local file = io.open(path, "w")

    if not file then
        print(file .. "WHILE SAVING!")
        return false
    else
        file:write(json.encode(value))
        io.close(file)
        return true
    end

end



 function M.loadData(fileName, location) 

        local loc = location

    if not loc then 
        loc = defaultLocation
    end

    local path = system.pathForFile(fileName, loc)

    local file, errorString = io.open(path, "r")

    if not file then
        print(errorString .. "WHILE LOADING!")
    else
        local contents = file:read("*a")

        local t = json.decode(contents)
        io.close(file)
        return t
    end

 end
 return M