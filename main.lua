
local notifications = require( "plugin.notifications.v2" )

notifications.registerForPushNotifications({useFCM = true})

display.setStatusBar(display.HiddenStatusBar)


local firebaseAnalytics = require "plugin.firebaseAnalytics"
firebaseAnalytics.init()

notifications.registerForPushNotifications()
 
local launchArgs = ...
if ( launchArgs and launchArgs.notification ) then
    print( launchArgs.notification.type )
    print( launchArgs.notification.name )
    print( launchArgs.notification.sound )
    print( launchArgs.notification.alert )
    print( launchArgs.notification.badge )
    print( launchArgs.notification.applicationState )
end
 
local json = require("json")
 
local deviceToken
 
local function notificationListener( event )
 
        print( "notification engine started!" )
 
      if ( event.type == "remote" and event.applicationState == "active" ) then
        --handle the push or local notification
        print( "type ", event.type ) 
        print ("event alert ", event.alert ) 
 
    elseif ( event.type == "remoteRegistration" ) then
 
 
        local deviceToken = event.token
        --local deviceType = 1  --default to iOS
 
        print( "Event Token is" .. " " .. event.token )
 
    end
end
 
-- The notification Runtime listener should be handled from within "main.lua"
Runtime:addEventListener( "notification", notificationListener )

local appodeal = require( "plugin.appodeal" )

local function adListener( event )

    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.isError )
    end
end

-- Initialize the Appodeal plugin
appodeal.init( adListener, { appKey=" 6e4c349a519377320dbf0ea35773323860e79bd057b77957" } )

centerX = display.contentWidth * 0.5

centerY = display.contentHeight * 0.5

local json = require("json")

local saveAndLoad = require("loadSave")

nameCheck = false
blockFont = "art/blocked.ttf"

localPlayer = {
	highScore = 0,
	currency = 0,
	lives = 1000,
    scoreSet = false,
    userName = "",
    userID = 0
}

bg = display.newImageRect("art/bg.jpg", display.contentWidth, display.contentHeight)
bg.x = centerX
bg.y = centerY

if (saveAndLoad.loadData("localValues.json") == null) then
	saveAndLoad.saveData(localPlayer, "localValues.json")
else 
	localPlayer = saveAndLoad.loadData("localValues.json")
end



local composer = require("composer")

composer.gotoScene("mainMenu")