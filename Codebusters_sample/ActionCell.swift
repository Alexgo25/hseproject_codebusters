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
    static var cells: [ActionCell] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(actionType: ActionType) {
        let texture = SKTexture(imageNamed: "cell_\(actionType.rawValue)")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        self.actionType = actionType
        position = getNextPosition()
        ActionCell.cells.append(self)
        zPosition = 3
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
    
    func getActionType() -> ActionType {
        return actionType
    }
    
    func getNextPosition() -> CGPoint {
        return CGPoint(x: Constants.ActionCellFirstPosition.x, y: Constants.ActionCellFirstPosition.y - CGFloat(ActionCell.cells.count) *  (texture!.size().height - 5))
    }
    
    func highlightBegin() -> SKAction {
        return SKAction.runBlock( { self.texture = SKTexture(imageNamed: "cell_\(self.actionType.rawValue)_Highlighted") } )
    }
    
    func highlightEnd() -> SKAction {
        return SKAction.runBlock( { self.texture = SKTexture(imageNamed: "cell_\(self.actionType.rawValue)") } )
    }
    
    class func isArrayOfCellsFull() -> Bool {
        return ActionCell.cells.count > 10
    }
}
