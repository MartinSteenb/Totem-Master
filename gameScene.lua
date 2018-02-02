
local firebaseAnalytics = require "plugin.firebaseAnalytics"


local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require("physics")

local json = require("json")

local loadAndSave = require("loadSave")
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 --Local variables
local touched = false

local block

local isFirstBlock = true

local ui = display.newGroup()

local score = 0

local background = display.newGroup()

local gameObjects = display.newGroup()

local player = display.newGroup()

local blockY = 0

local isGameOver = false

local defaultLocation = system.DocumentsDirectory

 --Functions

 local function createImageRect(imageName, width, height, group, x, y)
    local imageRect = display.newImageRect(
            "art/" .. imageName,
            width,
            height
        )

    imageRect.x = x
    imageRect.y = y

    group:insert(imageRect)

    return imageRect
 end

 local function onCoinTap(event) 
    local obj = event.target
    print("COIN TAPPED!")
    obj:removeSelf()

    localPlayer.currency = localPlayer.currency + 1
    currencyLabel.text = "x " .. tostring(localPlayer.currency)
    loadAndSave.saveData(localPlayer, "localValues.json")

    return true
end

 local function createCoinPickup()
    local xX = math.random(0, 300)
    local xY = math.random(0, 500)

    local coin = createImageRect("coin.png", 60, 50, ui, centerX-100, centerY)
    transition.to(coin, {time=750, y=100, alpha=0, onComplete=function() display.remove(coin) end})
    --coin:addEventListener("tap", onCoinTap)

    localPlayer.currency = localPlayer.currency + 1
    currencyLabel.text = "x " .. tostring(localPlayer.currency)
    loadAndSave.saveData(localPlayer, "localValues.json")

 end

 local function createLabel(x, y, text, font, fontsize) 

    local label = display.newText {
        x = x,
        y = y,
        text = text,
        font = font,
        fontSize = fontsize
    }

    return label

 end

function updateHighScore(currentScore) 
    local currentHighScore = localPlayer.highScore

    if not currentHighScore then
        print("NO CURRENT HIGHSCORE")
        return false
    end

    if (tonumber(currentHighScore) < currentScore) then
        localPlayer.highScore = currentScore
        loadAndSave.saveData(localPlayer, "localValues.json", system.DocumentsDirectory)

        highScoreLabel.text = "Best " .. tostring(localPlayer.highScore)
        return true
    else 
        return false
    end
end

 local function incrementScore(num)
             print("points+1")
            score = score + num
            scoreLabel.text = tostring(score)
            updateHighScore(score)

            if (score % 3 == 0) then
                createCoinPickup()
            end

            firebaseAnalytics.logEvent("Total points earned", {content_type = "1", item_id= "points"})
                        print( "event logged" )
 end

 local function blockMove()

 	local function left()
 		local function right()
 			transition.to(block, {time = 1000, x = display.contentWidth - 30, onComplete = left})
 		end
 		transition.to(block, {time = 1000, x = 30, onComplete = right})
 	end
 	transition.to(block, {time = 1000, x = display.contentWidth - 30, onComplete = left})

 end

 local function backToMainMenu() 
    composer.gotoScene("mainMenu")
 end

 local function gameOver()
    
    print("GAMEOVER")
    touched = true

    if (isGameOver == false) then

    localPlayer.lives = localPlayer.lives - 1

    loadAndSave.saveData(localPlayer ,"localValues.json")

    composer.showOverlay("gameOverOverlay", {isModal = true, effect = "fade", time = 400})
    
    end


    isGameOver = true

    firebaseAnalytics.logEvent("Total times game over", {content_type = "1", item_id= "gameover"})
                        print( "event logged" )


end

 local function onCollision(self, event)
 	local phase = event.phase

 	if (phase == "began") then
 		-- touched = false
        if scoreLabel then
            display.remove(scoreLabel)
        end
        scoreLabel = createLabel(centerX, 75, tostring(score), blockFont, 80)
        ui:insert(scoreLabel)
 		print(self.myName ..": collision with: " .. event.other.myName)

 		if (self.myName == "block" and event.other.myName == "block") then
 			self.myName = "solidBlock"
 			touched = false
 			transition.to(gameObjects, {time = 1000, y = gameObjects.y + 70})
            incrementScore(1)
           
 			
 		end

 		if (self.myName == "newBlock" and event.other.myName == "floor") then
 			self.myName = "beginBlock"
            self.collision = nil
 			touched = false
 			--gameObjects.y = gameObjects.y + 70
            transition.to(gameObjects, {time = 1000, y = gameObjects.y + 70})
        	incrementScore(1)
           

 		end

 		if (self.myName == "block" and event.other.myName == "floor") then
 			gameOver()
 			

 			
 		end

 		if (self.myName == "block" and event.other.myName == "solidBlock") then
 			incrementScore(1)
 			self.myName = "solidBlock"
 			touched = false
 			transition.to(gameObjects, {time = 1000, y = gameObjects.y + 70})

 		end

        if (self.myName == "solidBlock" and event.other.myName == "floor") then
            gameOver()
        end

        if (self.myName == "block" and event.other.myName == "beginBlock") then
            incrementScore(1)
            self.myName = "solidBlock"
            touched = false
            transition.to(gameObjects, {time = 1000, y = gameObjects.y + 70})
        end





 	elseif (phase == "ended") then

end
end




 local function touchedEvent(event)

 	local phase = event.phase

 	if (phase == "began") then

        if touched == false then
            touched = true
     		if isFirstBlock then
    		newBlock = createImageRect("crate.png", 70, 70, gameObjects, block.x, blockY)
     		newBlock.myName = "newBlock"
     		newBlock.collision = onCollision
     		newBlock:addEventListener("collision")
     		isFirstBlock = false
    		physics.addBody(newBlock, {density = 3.0, friction = 0.3, bounce = 0})
            blockY = blockY - 70


     		
     		else

            newBlock = createImageRect("crate.png", 70, 70, gameObjects, block.x, blockY)

     		newBlock.myName = "block"
     		newBlock.collision = onCollision
     		newBlock:addEventListener("collision")
     		physics.addBody(newBlock, {density = 3.0, friction = 0.3, bounce = 0})
            blockY = blockY - 70
         end

     end

        if (isGameOver == true) then 
            backToMainMenu()
        end 


    

 

 		elseif (phase == "ended") then

    	
 	      end


 end

 -- local function moveToRight(event)
 -- 	transition.to(block, {time = 1000, x = display.contentWidth - 30, onComplete = moveToLeft})
 -- 	 	print("RIGHT")
 -- end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )


    --Load player data

    --Physics
    physics.start()
    physics.setGravity(0, 10)
 
    local sceneGroup = self.view
    local bg = createImageRect("bg.jpg", display.contentWidth, display.contentHeight, background, centerX, centerY)

    sceneGroup:insert(background)
    sceneGroup:insert(gameObjects)
    sceneGroup:insert(ui)
    sceneGroup:insert(player)

    

   
   --Objects
    block = createImageRect("arrow.png", 70, 70, player, centerX, 75)
    blockY = block.y
    block.myName = "blockRed"
    blockMove()
    player:insert(block)




--UI

    

    highScoreLabel = createLabel(display.contentWidth - 50, 25, "Best " .. tostring(localPlayer.highScore), blockFont, 15)

    local currencyImg = createImageRect("coin.png", 60, 50, ui, 25, 25)
    currencyLabel = createLabel(50, 25, "x " .. tostring(localPlayer.currency), blockFont, 15)
    currencyLabel.anchorX = 0

    ui:insert(highScoreLabel)
    
    ui:insert(currencyLabel)

    local floor = createImageRect("floor.png", display.contentWidth, 100, gameObjects, centerX, display.contentHeight - 50)
   
    floor:setFillColor(0, 1, 0)
    floor.myName = "floor"
    gameObjects:insert(floor)

    --physics body's

    --physics.addBody(block, "static", {density = 3.0, friction = 0.5, bounce = 0;})
    physics.addBody(floor, "static", {density = 3.0, friction = 0.5, bounce = 0})

    --
    bg:addEventListener("touch", touchedEvent)
    
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        --composer.removeOver("gameOverOverlay")
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
 
    elseif ( phase == "did" ) then
       
        
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    loadAndSave.saveData(localPlayer, "localValues.json")
    physics.stop()
 
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

