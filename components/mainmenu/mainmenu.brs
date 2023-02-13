'
'  mainmenu.brs
'  RokuTetris
'
'  Created by Roman Podymov on 07/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    setMenu()
end sub

sub setMenu()
    m.currentScene = "SCENE_MAIN_MENU"
    m.mainMenuListPanel = m.top.findNode("MainMenuListPanel")
    m.gameScene = m.top.findNode("GameScreen")
    m.helpScene = m.top.findNode("HelpScreen")
    m.mainMenuData = createObject("roSGNode", "MainMenuContent")
    m.mainMenuListPanel.list.content = m.mainMenuData.contentData
    m.mainMenuListPanel.list.observeField("itemSelected", "showMenuItem")
    m.mainMenuListPanel.setFocus(true)
end sub

sub showMenuItem()
    if (m.mainMenuListPanel.list.itemFocused = 0) then
        m.currentScene = "SCENE_GAME"
        m.gameScene.isTimerRunning = true
        m.mainMenuListPanel.visible = false
        m.gameScene.visible = true
    else if (m.mainMenuListPanel.list.itemFocused = 1) then
    
    else if (m.mainMenuListPanel.list.itemFocused = 2) then
        m.currentScene = "SCENE_HELP"
        m.mainMenuListPanel.visible = false
        m.helpScene.visible = true
    endif
end sub

function onBack() as Boolean
    if (m.currentScene = "SCENE_GAME")
        m.gameScene.isTimerRunning = false
        m.mainMenuListPanel.visible = true
        m.gameScene.visible = false
        m.currentScene = "SCENE_MAIN_MENU"
        return true
    else if (m.currentScene = "SCENE_HELP")
        m.mainMenuListPanel.visible = true
        m.helpScene.visible = false
        m.currentScene = "SCENE_MAIN_MENU"
        return true    
    endif
    return false
end function

function onLeft() as Boolean
    if (m.currentScene = "SCENE_GAME")
        m.gameScene.mustMoveLeft = true
        return true
    endif    
    return false
end function

function onRight() as Boolean
    if (m.currentScene = "SCENE_GAME")
        m.gameScene.mustMoveRight = true
        return true
    endif
    return false
end function

function onDown() as Boolean
    if (m.currentScene = "SCENE_GAME")
        m.gameScene.mustMoveDown = true
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