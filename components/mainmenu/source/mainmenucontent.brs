'
'  mainmenucontent.brs
'  RokuTetris
'
'  Created by Roman Podymov on 07/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    content = createObject("roSGNode", "ContentNode")

    newGame = content.createChild("ContentNode")	
    newGame.setField("title", tr("new_game"))

    options = content.createChild("ContentNode")	
    options.setField("title", tr("options"))

    help = content.createChild("ContentNode")	
    help.setField("title", tr("help"))

    m.top.contentData = content
end sub