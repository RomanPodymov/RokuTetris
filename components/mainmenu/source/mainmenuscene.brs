'
'  mainmenuscene.brs
'  RokuTetris
'
'  Created by Roman Podymov on 07/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    setMenu()
end sub

sub setMenu()
    m.currentScreen = "SCREEN_MAIN_MENU"
    m.mainMenuScreen = m.top.findNode("mainMenuScreen")
    m.gameScreen = m.top.findNode("gameScreen")
    m.helpScreen = m.top.findNode("helpScreen")
    mainMenuContent = createObject("roSGNode", "MainMenuContent")
    m.mainMenuScreen.list.content = mainMenuContent.contentData
    m.mainMenuScreen.list.observeField("itemSelected", "showMenuItem")
    m.mainMenuScreen.setFocus(true)
end sub

sub showMenuItem()
    if (m.mainMenuScreen.list.itemFocused = 0) then
        m.currentScreen = "SCREEN_GAME"
        m.gameScreen.isTimerRunning = true
        m.mainMenuScreen.visible = false
        m.gameScreen.visible = true
    else if (m.mainMenuScreen.list.itemFocused = 1) then
    
    else if (m.mainMenuScreen.list.itemFocused = 2) then
        m.currentScreen = "SCREEN_HELP"
        m.mainMenuScreen.visible = false
        m.helpScreen.visible = true
    endif
end sub

function onBack() as Boolean
    if (m.currentScreen = "SCREEN_GAME")
        m.gameScreen.isTimerRunning = false
        m.mainMenuScreen.visible = true
        m.gameScreen.visible = false
        m.currentScreen = "SCREEN_MAIN_MENU"
        return true
    else if (m.currentScreen = "SCREEN_HELP")
        m.mainMenuScreen.visible = true
        m.helpScreen.visible = false
        m.currentScreen = "SCREEN_MAIN_MENU"
        return true    
    endif
    return false
end function

function onLeft() as Boolean
    if (m.currentScreen = "SCREEN_GAME")
        m.gameScreen.mustMoveLeft = true
        return true
    endif    
    return false
end function

function onRight() as Boolean
    if (m.currentScreen = "SCREEN_GAME")
        m.gameScreen.mustMoveRight = true
        return true
    endif
    return false
end function

function onDown() as Boolean
    if (m.currentScene = "SCREEN_GAME")
        m.gameScreen.mustMoveDown = true
        return true
    endif
    return false
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "back"
            return onBack()
        else if key = "left"
            return onLeft()
        else if key = "right"
            return onRight()
        else if key = "down"
            return onDown()  
        end if
    end if
    return false
end function