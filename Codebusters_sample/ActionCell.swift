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
    
    var cellCenterX: ActionCellCenter?
    private var actionType: ActionType = .none
    private var previousActionType: ActionType = .none
    
    enum ActionCellCenter: CGFloat {
        case first = 879,
        second = 1017,
        third = 1155,
        fourth = 1293
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(actionCellCenter: ActionCellCenter) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "none")
        self.init(texture: texture, color: color, size: Constants.ActionButtonSize)
        name = actionType.rawValue
        cellCenterX = actionCellCenter
        position = CGPoint(x: Constants.ScreenSize.width * actionCellCenter.rawValue/2048, y: Constants.ScreenSize.height * 193/1536)
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 2 / 5, height: size.height * 2 / 3))
        physicsBody!.categoryBitMask = NodeType.ActionCell.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.contactTestBitMask = NodeType.ActionButton.rawValue
        physicsBody!.dynamic = false
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
}
