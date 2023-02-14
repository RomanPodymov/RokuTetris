'
'  mainmenupanel.brs
'  RokuTetris
'
'  Created by Roman Podymov on 07/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    screenWidth = 1280
    screenHeight = 720
    m.top.list = m.top.findNode("menulist")
    title = m.top.findNode("appTitle")
    title.text = tr("appTitle")
    title.translation = [(screenWidth - title.boundingRect().width) / 2, 100]

    centerx = (screenWidth - 250) / 2
    centery = (screenHeight - 200) / 2
    m.top.list.translation = [ centerx, centery ]
    m.top.list.setFocus(true)
end sub