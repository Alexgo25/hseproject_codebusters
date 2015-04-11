//
//  Robot.swift
//  Codebusters_sample
//
//  Created by Alexander on 01.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction {
    case ToRight,
    ToLeft
}

class Robot: SKSpriteNode {
    
    var actions: [SKAction]
    var direction: Direction = .ToRight
    
    func moveForward()-> SKAction {
        let animation = SKAction.animateWithTextures(MoveForwardAnimationTextures(), timePerFrame: 0.04)
        let action = SKAction.repeatActionForever(animation)
        runAction(action)

        let moveAction = SKAction.moveTo(getNextPosition(), duration: 1.5)
        let doneAction = SKAction.runBlock( {
            self.removeAllActions()
            self.texture = SKTexture(imageNamed: "robot")
        })
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        
        //runAction(moveActionWithDone)
        return moveActionWithDone
    }
    
    func turn()-> SKAction {
        let turnAction = SKAction.runBlock({
           self.xScale = self.xScale * (-1)
        })
        let waitAction = SKAction.waitForDuration(1.0)
        let turnActionWithDone = SKAction.sequence([turnAction , waitAction])
        return turnActionWithDone
    }
    
    func jump() {
        
    }
    
    func push() {
        
    }
    
    func moveToStart() {
        position = Constants.Robot_StartPosition
    }
    
    func getStartPosition() -> CGPoint {
        return Constants.Robot_StartPosition
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        actions = []
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "robot")
        let size = Constants.Robot_Size
        self.init(texture: texture, color: color, size: size)
        moveToStart()
    }
    
    func getNextPosition(direction: Direction) -> CGPoint {
        var position = self.position
        if direction == .ToRight {
            position.x += CGFloat(236 / 225 * size.width)
        } else {
            position.x -= CGFloat(236 / 225 * size.width)
        }
        
        return position
    }
    
    func addAction(action : ActionButtonType)
    {
        switch action {
        case .moveForwardButton :
            actions.append(self.moveForward())
        case .turnButton :
            actions.append(self.turn())
        default :                                 //ToDo : add jump and push actions
            break
        }
    }
    
}
