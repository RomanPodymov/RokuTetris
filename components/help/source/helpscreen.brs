'
'  helpscreen.brs
'  RokuTetris
'
'  Created by Roman Podymov on 14/02/2023.
'  Copyright © 2023 RokuTetris. All rights reserved.
'

sub init()
    labelMoveLeftKey = m.top.findNode("labelMoveLeft")
    labelMoveLeftKey.text = tr("move_left")
    
    labelMoveRightKey = m.top.findNode("labelMoveRight")
    labelMoveRIghtKey.text = tr("move_right")
end sub