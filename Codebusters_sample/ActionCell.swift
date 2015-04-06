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
    var actionType: ActionButtonType?

    enum ActionButtonType: String {
        case moveForwardButton = "button_moveForward",
        turnButton = "button_Turn",
        pushButton = "button_Push",
        jumpButton = "button_Jump",
        none = "none"
    }
    
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
        let texture = SKTexture(imageNamed: "button_Turn")
        self.init(texture: texture, color: color, size: Constants.ActionButtonSize)
        self.actionType = ActionButtonType.none
        self.cellCenterX = actionCellCenter
        self.position = CGPoint(x: Constants.screenSize.width * actionCellCenter.rawValue/2048, y: Constants.screenSize.height * 193/1536)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width/2, height: size.height/2))
        self.physicsBody!.categoryBitMask = NodeType.ActionCell.rawValue
        self.physicsBody!.dynamic = false
    }
    
    struct Constants {
        static let screenSize = UIScreen.mainScreen().bounds
        static let ActionButtonSize = CGSize(width: screenSize.width * 119/2048, height: screenSize.height * 118/1536)
    }
}
