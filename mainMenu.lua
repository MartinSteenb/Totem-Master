local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local database = require("database")
local loadAndSave = require("loadSave")
local appodeal = require( "plugin.appodeal" )


 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Function to handle button events
local function handleButtonEvent( event )
    local btn = event.target.id
    localPlayer = loadAndSave.loadData("localValues.json")
    
    if btn == "play" then
        if (localPlayer.lives > 0) then
            composer.gotoScene("gameScene", "fade", 400)  
            else 
            print("ALERT: NOT ENOUGH LIVES!")  
        end
    elseif btn == "leaderboards" then
        composer.gotoScene("leaderboard", "fade", 400)
    end  
end
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    appodeal.show( "banner", { yAlign="bottom" } )
 
    local sceneGroup = self.view

    bgGroup = display.newGroup()
    uiGroup = display.newGroup()

    sceneGroup:insert(bgGroup)
    sceneGroup:insert(uiGroup)

    local bg = display.newImageRect("art/bg.jpg", display.contentWidth, display.contentHeight)
    bg.x = centerX
    bg.y = centerY

    bgGroup:insert(bg)

    local play = display.newText("Play", centerX, centerY-120, blockFont, 30)
    play:setFillColor(1)
    play.id = "play"
    play:addEventListener("touch", handleButtonEvent)
    uiGroup:insert(play)

    local leaderboards = display.newText("Leaderboards", centerX, centerY-50, blockFont, 30)
    leaderboards:setFillColor(1)
    leaderboards.id = "leaderboards"
    leaderboards:addEventListener("touch", handleButtonEvent)
    uiGroup:insert(leaderboards)    
end


 

 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
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
        -- Code here runs immediately after the scene goes entirely off scree
        composer.removeScene("mainMenu")
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