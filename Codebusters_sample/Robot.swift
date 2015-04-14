//
//  Robot.swift
//  Codebusters_sample
//
//  Created by Alexander on 01.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction: Int {
    case ToRight = 1,
    ToLeft = -1
}

class Robot: SKSpriteNode {
    
    private var actions: [SKAction] = []
    private var direction: Direction = .ToRight
    private var tempPosition: CGPoint = Constants.Robot_StartPosition
    private var turnedToFront: Bool = false
    
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
        zPosition = 1
        moveToStart()
    }
    
    func appendAction(actionType: ActionType) {
        switch actionType {
        case .moveForward:
            tempPosition = getNextTempPosition(direction)
            actions.append(moveForward(tempPosition, direction: direction))
        case .turn:
            actions.append(turn(direction))
            changeDirection()
        case .jump:
            actions.append(jump(position, direction: direction))
//        case .push:
            
        default:
            println("123")
        }
    }
    
    func performActions() {
        let sequence = SKAction.sequence(actions)
        println(actions.count)
        runAction(sequence)
    }
    
    func moveForward(position: CGPoint, direction: Direction) -> SKAction {
        let move = SKAction.moveTo(position, duration: 1.6)
        let animate = SKAction.animateWithTextures(MoveAnimationTextures(direction), timePerFrame: 0.04)
        let repeatAnimation = SKAction.repeatAction(animate, count: 5)
        let moveAndAnimate = SKAction.group([move, repeatAnimation])
      
        return moveAndAnimate
    }
    
    func turn(direction: Direction) -> SKAction {
        let animate = SKAction.animateWithTextures(TurnAnimationTextures(direction), timePerFrame: 0.08)
        return animate
    }
    
    func turnToFront(direction: Direction) {
        let animate = SKAction.animateWithTextures(TurnToFrontAnimationTextures(direction), timePerFrame: 0.05)
        runAction(animate)
        turnedToFront = true
    }
    
    func turnFromFront(direction: Direction) -> SKAction {
        let animate = SKAction.animateWithTextures(TurnFromFrontAnimationTextures(direction), timePerFrame: 0.05)
        runAction(animate)
        turnedToFront = false
        return animate
    }
    
    func jump(position: CGPoint, direction: Direction) -> SKAction {
        let path = UIBezierPath()
        path.moveToPoint(position)
        path.addQuadCurveToPoint(CGPoint(x: getNextTempPosition(direction).x, y: getYPosition(.second)), controlPoint: CGPoint(x: (getNextTempPosition(direction).x - position.x) / 2 + position.x, y: getYPosition(.second) + 160))

        let move = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: false, duration: 2)
        
        return move
    }
    
    func push(direction: Direction) -> SKAction {
        let animate = SKAction.animateWithTextures(PushAnimationTextures(direction), timePerFrame: 0.08)
        
        return animate
    }
    
    func moveToStart() {
        position = Constants.Robot_StartPosition
        tempPosition = position
    }
    
    func getStartPosition() -> CGPoint {
        return Constants.Robot_StartPosition
    }
    
    func getNextPosition(direction: Direction) -> CGPoint {
        return CGPoint(x: position.x + CGFloat(direction.rawValue) * CGFloat(Constants.BlockFace_Size.width) , y: position.y)
    }
    
    func getNextTempPosition(direction: Direction) -> CGPoint {
        return CGPoint(x: tempPosition.x + CGFloat(direction.rawValue) * CGFloat(Constants.BlockFace_Size.width), y: tempPosition.y)
    }
    
    func getDirection() -> Direction {
        return direction
    }
    
    func changeDirection() {
        if direction == .ToRight {
            self.direction = .ToLeft
        } else {
            self.direction = .ToRight
        }
    }
    
    func isTurnedToFront() -> Bool {
        return turnedToFront
    }
}
