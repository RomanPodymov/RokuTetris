'
'  gamescreen.brs
'  RokuTetris
'
'  Created by Roman Podymov on 16/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    scoresTitle = m.top.findNode("labelScoresTitle")
    scoresTitle.text = tr("scores")
    scoresTitle.translation = [1280 - scoresTitle.boundingRect().width - 50, 50]
    
    m.gameField = m.top.findNode("gameField")
    m.gameField.translation = [50, 50]
    
    m.top.isTimerRunning = false
    m.top.mustMoveLeft = false
    m.top.mustMoveRight = false
    m.top.mustMoveDown = false
end sub

sub onIsTimerRunningValueChangedBase()
    m.gameField.isTimerRunning = m.top.isTimerRunning
end sub

sub onMustMoveLeftBase()
    if (m.top.mustMoveLeft = true)
        m.gameField.mustMoveLeft = m.top.mustMoveLeft
        m.top.mustMoveLeft = false
    end if
end sub

sub onMustMoveRightBase()
    if (m.top.mustMoveRight = true)
        m.gameField.mustMoveRight = m.top.mustMoveRight
        m.top.mustMoveRight = false
    end if
end sub

sub onMustMoveDownBase()
    if (m.top.mustMoveDown = true)
        m.gameField.mustMoveDown = m.top.mustMoveDown
        m.top.mustMoveDown = false
    end if
end sub