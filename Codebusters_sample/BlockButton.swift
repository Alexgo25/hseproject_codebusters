//
//  BlockButton.swift
//  Codebusters_sample
//
//  Created by Alexander on 02.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

enum ActionState {
    case moveForward, turn, jump, push
}

class BlockButton : SKSpriteNode {
    
    var actionState : ActionState?
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(imageNamed : String , state : ActionState , size : CGSize)
    {
        let color = UIColor()
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
