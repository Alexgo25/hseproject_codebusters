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

    private var actionType: ActionType = .none
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonType: ActionType) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: buttonType.rawValue)
        self.init(texture: texture, color: color, size: Constants.ActionButtonSize)
        actionType = buttonType
        position = getActionButtonPosition(buttonType)
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 2 / 3, height: size.height))
        physicsBody!.categoryBitMask = NodeType.ActionButton.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody!.contactTestBitMask = NodeType.ActionCell.rawValue
        physicsBody!.dynamic = true
        physicsBody!.allowsRotation = false
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
}
