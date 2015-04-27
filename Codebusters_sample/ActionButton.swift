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
    
    init(type: ActionType) {
        let texture = SKTexture(imageNamed: "button_\(type.rawValue)")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        actionType = type
        position = CGPoint(x: 20, y: 60)
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        showLabel()
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
     
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if labelShowed && !ActionCell.isArrayOfCellsFull() {
            var robot = parent as! Robot
            robot.appendAction(actionType)
        }
        hideLabel()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(parent)
            if !containsPoint(touchLocation) {
                hideLabel()
            } else {
                showLabel()
            }
        }
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
    
    func showButton() {
        let move = SKAction.moveTo(getActionButtonPosition(actionType), duration: 0.1)
        runAction(move)
    }
    
    func hideButton() {
        let move = SKAction.moveTo(CGPoint(x: 20, y: 60), duration: 0.1)
        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        runAction(sequence)
    }
    
    func showLabel() {
        labelShowed = true
        texture = SKTexture(imageNamed: "button_\(actionType.rawValue)_Pressed")
        size = texture!.size()
    }
    
    func hideLabel() {
        labelShowed = false
        texture = SKTexture(imageNamed: "button_\(actionType.rawValue)")
        size = texture!.size()
    }
    
    func isLabelShowed() -> Bool {
        return labelShowed
    }
}
