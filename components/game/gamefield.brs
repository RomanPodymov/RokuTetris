'
'  gamefield.brs
'  RokuTetris
'
'  Created by Roman Podymov on 16/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    m.fieldHeight = 20
    m.fieldWidth = 10
    m.brickSize = 30
    
    m.colorsAndValues = CreateObject("roAssociativeArray")
    m.colorsAndValues.AddReplace("0", "0x880088FF")
    m.colorsAndValues.AddReplace("1", "0xF008F8FF")
    
    m.figuresTypes = CreateObject("roAssociativeArray")
    m.figuresTypes.AddReplace("1", "J")
    m.figuresTypes.AddReplace("2", "L")
    
    m.gameFieldMatrix = CreateObject("roArray",m.fieldHeight + 1,false)
    for i = 1 to m.fieldHeight
        newLine = CreateObject("roArray",m.fieldWidth + 1,false)
        for j = 1 to m.fieldWidth
            brickId = box("gameFieldBrick")
            brickId.appendString(box(i).toStr(), box(i).toStr().len()) 
            brickId.appendString("_", "_".len())
            brickId.appendString(box(j).toStr(), box(j).toStr().len())
            currentBrick = m.top.findNode(brickId)
            if (currentBrick <> invalid) then
                newLine[j] = 0
                currentBrick.color = m.colorsAndValues[box(newLine[j]).toStr()]
                currentBrick.width = m.brickSize
                currentBrick.height = m.brickSize
                currentBrick.translation = [j * m.brickSize, i * m.brickSize]
            endif
        end for
        m.gameFieldMatrix[i] = newLine
    end for        
    
    createFigure()
    m.top.isTimerRunning = false
    m.top.mustMoveLeft = false
	m.top.mustMoveRight = false
	m.top.mustMoveDown = false
	renderMatrix()
end sub

sub startTimer()
    if (m.timer <> invalid)
        stopTimer()
    endif
    m.timer = m.top.findNode("gameplayTimer")
    m.timer.control = "start"
    m.timer.observeField("fire","onTimerFired")
end sub

sub stopTimer()
    m.timer.unobserveField("fire")
    m.timer.control = "stop"
    m.timer = invalid
end sub

sub renderMatrix()
    for i = 1 to m.fieldHeight
        for j = 1 to m.fieldWidth
            brickId = box("gameFieldBrick")
            brickId.appendString(box(i).toStr(), box(i).toStr().len()) 
            brickId.appendString("_", "_".len())
            brickId.appendString(box(j).toStr(), box(j).toStr().len())
            currentBrick = m.top.findNode(brickId)
            if (currentBrick <> invalid) then
                currentBrick.color = m.colorsAndValues[box(abs(m.gameFieldMatrix[i][j])).toStr()]
            endif
        end for
    end for
end sub

function createRandomFigureType()
    figureNumber = RND(m.figuresTypes.count())
    return m.figuresTypes[box(figureNumber).toStr()]
end function

function createRandomFigureColor()
    return RND(m.colorsAndValues.count() - 1)
end function

sub createFigure()
    figureType = createRandomFigureType()
    figureColor = createRandomFigureColor()
    if (figureType = "J") then
        m.gameFieldMatrix[1][m.fieldWidth/2 - 1] = figureColor
        m.gameFieldMatrix[1][m.fieldWidth/2] = figureColor
        m.gameFieldMatrix[1][m.fieldWidth/2 + 1] = figureColor
        m.gameFieldMatrix[2][m.fieldWidth/2 + 1] = figureColor
    else if (figureType = "L") then
        m.gameFieldMatrix[1][m.fieldWidth/2 - 1] = figureColor
        m.gameFieldMatrix[1][m.fieldWidth/2] = figureColor
        m.gameFieldMatrix[1][m.fieldWidth/2 + 1] = figureColor
        m.gameFieldMatrix[2][m.fieldWidth/2 - 1] = figureColor    
    end if
end sub

sub onTimerFired()
	fallDown()
    renderMatrix()
end sub

sub onIsTimerRunningValueChanged()
    if (m.top.isTimerRunning) then
        startTimer()
    else
        stopTimer()
    end if
end sub

sub onMustMoveLeft()
    if (m.top.mustMoveLeft = true)
        m.top.mustMoveLeft = false
        moveBase(canMoveLeft, moveLeft)
    endif
end sub

sub onMustMoveRight()
    if (m.top.mustMoveRight = true)
        m.top.mustMoveRight = false
        moveBase(canMoveRight, moveRight)
    endif
end sub

sub onMustMoveDown()
    if (m.top.mustMoveDown = true)
        m.top.mustMoveDown = false
        fastFall()
    endif
end sub

function canMoveLeft(i, j, n, nsecondary)
   	return j - 1 < 1 or m.gameFieldMatrix[i][j - 1] < 0
end function

function canMoveRight(i, j, n, nsecondary)
   	return j + 1 > n or m.gameFieldMatrix[i][j + 1] < 0
end function

function canFall(i, j, n, nsecondary)
   	return i + 1 > nsecondary or m.gameFieldMatrix[i + 1][j] < 0
end function

function canMoveBase(statementFunc)
    result = true
    currentFigureBricks = CreateObject("roArray",1,true)
    fColor = 0
    for i = 1 to m.fieldHeight
        for j = 1 to m.fieldWidth
            if (m.gameFieldMatrix[i][j] > 0) then
                fColor = m.gameFieldMatrix[i][j]
                if (statementFunc(i, j, m.fieldWidth, m.fieldHeight)) then
                    result = false
                end if
                currentFigureBricks.push({iIndex:i, jIndex:j})
            end if
        end for
    end for
    return { canMove : result, figureBricks : currentFigureBricks, figureColor : fColor}
end function

function moveBase(canMoveFunction, afterMoveProcedure)
    canMoveParams = canMoveBase(canMoveFunction)
    if (canMoveParams["canMove"]) then
        for i = 1 to m.fieldHeight
            for j = 1 to m.fieldWidth
                if (m.gameFieldMatrix[i][j] > 0) then
                    m.gameFieldMatrix[i][j] = 0
                end if
            end for
        end for
        for each figureBrick in canMoveParams["figureBricks"]
        	afterMoveProcedure(figureBrick, canMoveParams)
        end for
        renderMatrix()
        return true
    else
    	return false
    end if
end function

sub moveLeft(figureBrick, canMoveLeftParams)
	m.gameFieldMatrix[figureBrick["iIndex"]][figureBrick["jIndex"] - 1] = canMoveLeftParams["figureColor"]
end sub

sub moveRight(figureBrick, canMoveLeftParams)
	m.gameFieldMatrix[figureBrick["iIndex"]][figureBrick["jIndex"] + 1] = canMoveLeftParams["figureColor"]
end sub

sub fall(figureBrick, canMoveLeftParams)
	m.gameFieldMatrix[figureBrick["iIndex"] + 1][figureBrick["jIndex"]] = canMoveLeftParams["figureColor"]
end sub

sub fallDown()
	if (not moveBase(canFall, fall)) then
		afterFalling()
	end if
end sub

function checkIfFulLine(i)
	for j = 1 to m.fieldWidth 
    	if (m.gameFieldMatrix[i][j] = 0) then
    		return false
    	end if
   	end for
   	return true
end function

sub removeLine(i)
	for j = 1 to m.fieldWidth
    	m.gameFieldMatrix[i][j] = 0
    end for
end sub

sub moveLinesDownAfterFalling(lines)

end sub

sub afterFalling()
	for i = 1 to m.fieldHeight
    	for j = 1 to m.fieldWidth
        	if (m.gameFieldMatrix[i][j] > 0) then
            	m.gameFieldMatrix[i][j] = -m.gameFieldMatrix[i][j]
            end if
        end for
    end for
    while(true)
    	wasLineFound = false
    	lines = CreateObject("roArray", 1, true)
    	for i = m.fieldHeight to 1 step -1
    		if (checkIfFulLine(i)) then
    			wasLineFound = true
    			removeLine(i)
    			lines.Push(i)
    		end if
    	end for
    	if wasLineFound = false then
    		exit while
    	else
    		moveLinesDownAfterFalling(lines)
    	end if
    end while
    createFigure()
end sub

sub fastFall()
	while (true)
		if (not moveBase(canFall, fall)) then
			exit while
		end if
	end while
end sub