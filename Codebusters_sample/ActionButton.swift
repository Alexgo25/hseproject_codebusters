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
    private var tapped = false
    private var label: SKSpriteNode = SKSpriteNode()
    
    init(type: ActionType) {
        let texture = SKTexture(imageNamed: "button_\(type.rawValue)")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        actionType = type
        position = CGPoint(x: 20, y: 60)
        userInteractionEnabled = true
        let labelTextute = SKTexture(imageNamed: "label_\(type.rawValue)")
        label = SKSpriteNode(texture: labelTextute, color: UIColor(), size: labelTextute.size())
        if getActionButtonPosition(actionType).x > 0 {
            label.anchorPoint = CGPoint(x: 0, y: 0)
            label.position = CGPoint(x: -47, y: 70)
        } else {
            label.anchorPoint = CGPoint(x: 1, y: 0)
            label.position = CGPoint(x: 47, y: 70)
        }
        showLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        tapBegan()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if isTapped() && !ActionCell.isArrayOfCellsFull() {
            var robot = parent as! Robot
            robot.appendAction(actionType)
            runAction(SKAction.playSoundFileNamed("ActionSelection.mp3", waitForCompletion: false))
        }
        tapEnded()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(parent)
            if !containsPoint(touchLocation) {
                tapEnded()
            } else {
                tapBegan()
            }
        }
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
    
    func tapBegan() {
        tapped = true
        texture = SKTexture(imageNamed: "button_\(actionType.rawValue)_Pressed")
        size = texture!.size()
    }
    
    func tapEnded() {
        tapped = false
        texture = SKTexture(imageNamed: "button_\(actionType.rawValue)")
        size = texture!.size()
    }
    
    func isTapped() -> Bool {
        return tapped
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
        addChild(label)
    }
    
    func hideLabel() {
        label.removeFromParent()
    }
}
