local composer = require( "composer" )
 
local scene = composer.newScene()
 
 local creator = require("creatingObjectModule")

 local ui = display.newGroup()

 --functions
 local function retryButton(event) 

    local btn = event.target.id

    if (btn == "retry") then
        composer.hideOverlay("gameOverOverlay")
        composer.gotoScene("gameScene", {effect = "crossFade", time = 2000})
    end
    if (btn == "menu") then
        composer.gotoScene("mainMenu", {effect = "crossFade", time = 400})
    end
    if  (btn == "social") then
        composer.gotoScene("leaderboard", {effect = "crossFade", time = 400})
    end
        
 end
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    local backGround = creator.createImageRect("gameOverBackground.png", 250, 300, ui,  centerX, centerY)
    

    local gameOverLabel = creator.createLabel(centerX, centerY - 70, "GAME OVER", native.systemFont, 25)
    ui:insert(gameOverLabel)



    local retry = creator.createImageRect("retryButton.png", 50, 50, ui, centerX, centerY)
    retry:addEventListener("tap", retryButton)
    retry.id = "retry"
    ui:insert(retry)

    local menu = creator.createImageRect("menuButton.png", 50, 50, ui, centerX - 40, centerY + 40)
    menu:addEventListener("tap", retryButton)
    menu.id = "menu"
    ui:insert(menu)

    local social = creator.createImageRect("socialButton.png", 50, 50, ui, centerX + 40, centerY + 40)
    social:addEventListener("tap", retryButton)
    social.id = "social"
    ui:insert(social)
 
    sceneGroup:insert(ui)
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
        -- Code here runs immediately after the scene goes entirely off screen
        composer.hideOverlay("gameOverOverlay")
        composer.removeScene("gameScene")
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