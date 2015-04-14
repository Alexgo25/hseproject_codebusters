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
    private var labelShowed: Bool = false
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonType: ActionType) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "button_\(buttonType.rawValue)")
        self.init(texture: texture, color: color, size: Constants.ActionButtonSize)
        actionType = buttonType
        position = getActionButtonPosition(buttonType)
        hideButton()
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.categoryBitMask = NodeType.ActionButton.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.contactTestBitMask = NodeType.Touch.rawValue
        physicsBody!.dynamic = false
        physicsBody!.allowsRotation = false
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
    
    func showButton() {
        hidden = false
        let move = SKAction.moveTo(getActionButtonPosition(actionType), duration: 0.1)
        runAction(move)
    }
    
    func hideButton() {
        let move = SKAction.moveTo(CGPoint(x: Constants.Robot_StartPosition.x, y: Constants.Robot_StartPosition.y + CGFloat(40)), duration: 0.1)
        runAction(move)
        hidden = true
    }
    
    func showLabel() {
        labelShowed = true
        println("show")
    }
    
    func hideLabel() {
        labelShowed = false
        println("hide")
    }
    
    func isLabelShowed() -> Bool {
        return labelShowed
    }
}
