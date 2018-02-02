
local M = {}
--xd
local sqlite3 = require("sqlite3")
local widget = require("widget")
local loadAndSave = require("loadSave")

local path = system.pathForFile("highscores.db", system.DocumentsDirectory)
local db = sqlite3.open(path)
local nameCheck = false

function M.emptyDB (event)
	print("delete")
	local deleteQuery = [[DELETE FROM GameData WHERE UserID >= 0;]]
	db:exec(deleteQuery)

	localPlayer.scoreSet = false
	localPlayer.highScore = 1
	localPlayer.userID = 0
	loadAndSave.saveData(localPlayer ,"localValues.json")
end	

function M.checkUser (name)
		local query = [[SELECT FirstName FROM GameData WHERE FirstName LIKE "]] ..name.. [["]]
		db:exec(query)

		for row in db:nrows(query) do
			return false
		end
		return true
end

function M.submitUser (userInput, score)
	local score = 14
	local pScore = localPlayer.highScore
	local userName = localPlayer.userName
	local userID = localPlayer.userID
	
	if localPlayer.scoreSet == false then
		print("false")
		local insert = [[INSERT INTO GameData VALUES (NULL,"]] .. userInput .. [[", "]] .. pScore .. [[");]]
	    db:exec(insert)	
	    localPlayer.scoreSet = true
	    localPlayer.userName = userInput
	    loadAndSave.saveData(localPlayer ,"localValues.json")
	else
		print(pScore)
		local update = [[UPDATE GameData SET Score="]] ..pScore.. [[" WHERE FirstName="]] ..userName..[[";]]
	    db:exec(update)	
	end

	

	
	--if  then
		--for i = 1, 7 do
	       -- local insert = [[INSERT INTO GameData VALUES (NULL,"]] .. " " .. [[", "]] .. 0 .. [[");]]
	       -- db:exec(insert)
	    --end
	--end
	
	--
    
	
end

function M.onSystemEvent (event)
	if event.type == "applicationExit" then
		if db and db:open() then
			db:close()
		end
	end
end

local tableSetup = [[CREATE TABLE IF NOT EXISTS GameData (UserID INTEGER PRIMARY KEY, FirstName, Score);]]
db:exec(tableSetup)

return M







