//
//  ActionCell.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 05.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class ActionCell: SKSpriteNode {
    
    private var actionType: ActionType = .none
    private var previousActionType: ActionType = .none
    static var cells: [ActionCell] = []
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(actionType: ActionType) {
        let color = UIColor()
        var imageName = "cell_\(actionType.rawValue)"
        let texture = SKTexture(imageNamed: imageName)
        self.init(texture: texture, color: color, size: Constants.ActionCellSize)
        self.actionType = actionType
        position = getNextPosition()
        ActionCell.cells.append(self)
        println(ActionCell.cells.count)
        println(self.getActionType().rawValue)
        /*
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 2 / 5, height: size.height * 2 / 3))
        physicsBody!.categoryBitMask = NodeType.ActionCell.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.contactTestBitMask = NodeType.ActionButton.rawValue
        physicsBody!.dynamic = false
        */
    }
    
    func setActionType(actionType: ActionType) {
        self.actionType = actionType
        texture = SKTexture(imageNamed: actionType.rawValue)
    }
    
    func setPreviousActionType(actionType: ActionType) {
        previousActionType = actionType
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
    
    func getPreviousActionType() -> ActionType {
        return previousActionType
    }
    
    func getNextPosition() -> CGPoint {
        return CGPoint(x: Constants.ActionCellFirstPosition.x, y: Constants.ActionCellFirstPosition.y - CGFloat(ActionCell.cells.count) * (Constants.ActionCellSize.height - 2))
    }
}
