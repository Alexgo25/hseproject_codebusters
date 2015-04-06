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

    var type: ButtonType?
    
    enum ButtonType: String {
        case moveForwardButton = "button_moveForward",
        turnButton = "button_Turn",
        pushButton = "button_Push",
        jumpButton = "button_Jump"
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonType: ButtonType, position: CGPoint) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: buttonType.rawValue)
        self.init(texture: texture, color: color, size: Constants.ActionButtonSize)
        self.type = buttonType
        self.position = position
        self.name = buttonType.rawValue
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody!.categoryBitMask = NodeType.ActionButton.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody!.contactTestBitMask = NodeType.ActionCell.rawValue
        self.physicsBody!.dynamic = true
        self.physicsBody!.allowsRotation = false
    }
    
    struct Constants {
        static let screenSize = UIScreen.mainScreen().bounds
        static let ActionButtonSize = CGSize(width: screenSize.width * 119/2048, height: screenSize.height * 118/1536)
    }
}
