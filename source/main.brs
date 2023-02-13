'
'  main.brs
'  RokuTetris
'
'  Created by Roman Podymov on 07/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub Main()
    showChannelSGScreen()
end sub

sub showChannelSGScreen()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("MainMenu")
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)

        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
