//
//  ActionButton.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 05.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class ActionButton: SKSpriteNode {
    
    enum ButtonType: String {
        case moveForwardButton = "button_moveForward",
        turn = "button_Turn",
        push = "button_Push",
        jump = "button_Jump"
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonType: ButtonType, size: CGSize) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: buttonType.rawValue)
        self.init(texture: texture, color: color, size: size)
    }
}
