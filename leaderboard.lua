local composer = require( "composer" )
local widget = require("widget")
local database = require("database")
local loadAndSave = require("loadSave") 
local scene = composer.newScene()
local path = system.pathForFile("highscores.db", system.DocumentsDirectory)
local db = sqlite3.open(path) 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local bgGroup
 local uiGroup
 local submitText
 local exists
 
 local function backToMain (event)
    composer.gotoScene("mainMenu", {effect = "crossFade"})
 end

 local function onRowRender (event)
    local row = event.row

    local font = native.systemFont
    local fontSize = 24
    local rowHeight = row.height / 2
    local rowColor = row.rowColor
    --row:setFillColor(1,0,0)
    --row.rowColor:setFillColor(1,0,0)
    print(rowColor)
--[[local options_id = {
        parent = row,
        text = row.params.ID,
        x = 80,
        y = rowHeight,
        font = font,
        fontSize = 15,
    }

    row.id = display.newText(options_id)
    row.id.anchorX = 0
    row.id:setFillColor(black)]]
    


    local options_name = {
        parent = row,
        text = row.params.FirstName,
        x = 50,
        y = rowHeight,
        font = font,
        fontSize = fontSize,
    }

    row.params.FirstName = display.newText(options_name)
    row.params.FirstName:setFillColor(black)
    row.params.FirstName.x = 150
    row.params.FirstName:setFillColor(black)

    local options_score = {
        parent = row,
        text = row.params.Score,
        x = 50,
        y = rowHeight,
        font = font,
        fontSize = fontSize,
    }

    row.params.Score = display.newText(options_score)
    row.params.Score:setFillColor(black)
    row.params.Score.x = row.params.FirstName.x+100

end

local function printDB ()
    local table_options = {
        top = 75,
        hideBackground = true,
        onRowRender = onRowRender,
    }   
    local tableView = widget.newTableView(table_options)
    uiGroup:insert(tableView)

    local id = {}

    for row in db:nrows("SELECT * FROM GameData WHERE UserID <= 9 ORDER BY Score DESC") do
        print("row: ", row.UserID, "FirstName", row.FirstName, "Score", row.Score )    
     
        id[#id+1] =
        {
            id = row.UserID
        }

        --Give local id to every user
        localPlayer.userID = id
        loadAndSave.saveData(localPlayer ,"localValues.json")

        for x = 1, 7 do
            local ranking = display.newText(x, 0, 0, native.systemFont, 24)
            ranking.x = 50
            ranking.y = (x * 50) + 50
            ranking:setFillColor(black)
            uiGroup:insert(ranking)
        end

        local rowParams = {
            ID = row.UserID,
            FirstName = row.FirstName,
            Score = row.Score,
        }

        tableView:insertRow(
            {   
                rowHeight = 50,
                rowColor = { default={1,1,1}, over={1,0.5,0,0.2} },
                params = rowParams,
            }
        )
    end
    --print(#id)
end
 
 function textListener(event)
    local phase = event.phase
    local obj = event.target
    local name = event.target.text
    if ( event.phase == "began" ) then

        
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        --Checks if the username already exists returns true if it doesn't
        database.checkUser(name)

        if database.checkUser(name) == false then 
            if existsText then 
                display.remove(existsText)
            end
            existsText = display.newText("The name " ..  name .. " is already in use!" , 0, 0 , native.systemFont, 20)
            existsText.x = centerX
            existsText.y = centerY-50
            existsText:setFillColor(1, 0, 0)
        else 
            obj:removeSelf()
            display.remove(existsText)
            display.remove(submitText)
            database.submitUser(name)
            printDB()
        end
    elseif ( event.phase == "editing" ) then

    end
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    bgGroup = display.newGroup()
    sceneGroup:insert(bgGroup)
    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)

    if database then
        print("database.lua exists")
    end

    local bg = display.newImageRect("art/bg.jpg", display.contentWidth, display.contentHeight)
    bg.x = centerX
    bg.y = centerY
    bgGroup:insert(bg)

    local back = display.newText("Back", centerX, display.contentHeight-25, blockFont, 30)
    back:addEventListener("tap", backToMain)
    uiGroup:insert(back)

    --[[local emptyTheDB = display.newText("empty", centerX-80, display.contentHeight-25, native.systemFont, 30) 
    uiGroup:insert(emptyTheDB)
    emptyTheDB:addEventListener("tap", database.emptyDB)]]
    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        if localPlayer.scoreSet == false then
            local userInput = native.newTextField(centerX, centerY-100, 200, 50)
            userInput:addEventListener("userInput", textListener)
            uiGroup:insert(userInput)

            submitText = display.newText("Type username", centerX, centerY-150, blockFont, 30) 
            uiGroup:insert(submitText)
        else
            database.submitUser()
            printDB()

            local highText = display.newText("Highscores", centerX, 50, blockFont, 30)
            uiGroup:insert(highText)
        end
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
         
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("leaderboard")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene