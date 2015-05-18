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

class Robot: SKSpriteNode, SKPhysicsContactDelegate {
    
    private var actions: [SKAction] = []
    private var currentActionIndex = 0
    private var direction: Direction = .ToRight // рассчитывается заранее
    private var animationDirection: Direction = .ToRight // рассчитывается во время движения
    private var turnedToFront = false
    private var stopRobot = false
    
    var track: RobotTrack
    
    private let actionButtons: [ActionButton] = [ActionButton(type: .moveForward), ActionButton(type: .turn), ActionButton(type: .push), ActionButton(type: .jump)]
    var isOnStart = true
    
    
    init(track: RobotTrack) {
        var texture = SKTexture(imageNamed: "robot")
        self.track = track
        super.init(texture: texture, color: UIColor(), size: texture.size())
        zPosition = CGFloat(floorPosition().rawValue * 7 + trackPosition())
        moveToStart()
        actions = []
        userInteractionEnabled = true
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width - 50, height: size.height - 70))
        physicsBody!.categoryBitMask = PhysicsCategory.Robot
        physicsBody!.contactTestBitMask = PhysicsCategory.Detail
        physicsBody!.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currentAction() -> Int {
        return currentActionIndex
    }
    
    func canPerformAction(actionType: ActionType) -> Bool {
        return track.canPerformActionWithDirection(actionType, direction: direction)
    }
    
    func takeDetail() {
        stopRobot = true
    }
    
    func appendAction(actionType: ActionType) {
        parent!.addChild(ActionCell(actionType: actionType))
        if canPerformAction(actionType) {
            let highlightBeginAction = ActionCell.cells.last!.highlightBegin()
            let highlightEndAction = ActionCell.cells.last!.highlightEnd()
            var action: SKAction
            switch actionType {
            case .moveForward:
                action = moveForward()
            case .turn:
                action = turn()
            case .jump:
                action = jump(false)
            case .push:
                action = push()
            default:
                return
            }
            let sequence = SKAction.sequence([highlightBeginAction, action, highlightEndAction])
            actions.append(sequence)
        } else {
            actions.append(SKAction.runBlock() {
                self.stopRobot = true
            })
            actions.append(SKAction())
        }
    }
    
    func runActions() {
        runAction(actions[currentActionIndex], completion: {
            self.runAction(SKAction.runBlock() {
                if self.stopRobot {
                    let turn = SKAction.animateWithTextures(TurnToFrontAnimationTextures(self.animationDirection), timePerFrame: 0.05)
                    self.runAction(turn)
                    return
                } else {
                    if self.currentActionIndex < self.actions.count - 1 {
                        self.currentActionIndex++
                        self.runActions()
                    }
                }
            })
        })
    }
    
    func performActions() {
        if !actions.isEmpty && isOnStart {
            if turnedToFront {
                let turnFromFront = SKAction.runBlock() {
                    self.turnFromFront()
                }
            
                runAction(turnFromFront, completion: { self.runActions() } )
                return
            }
            
            isOnStart = false
            runActions()
        }
    }
    
    func moveForward() -> SKAction {
        if floorPosition() == track.getFloorPositionAt(track.getNextRobotTrackPosition(direction)) {
            let move = SKAction.moveByX(Constants.BlockFace_Size.width * CGFloat(direction.rawValue), y: 0, duration: 1.6)
        
            let animate = SKAction.group([SKAction.animateWithTextures(MoveAnimationTextures(direction), timePerFrame: 0.04, resize: true, restore: false)])
            let repeatAnimation = SKAction.repeatAction(animate, count: 5)
        
            let nextTrackPosition = self.track.getNextRobotTrackPosition(direction)
            let setZPosition = SKAction.runBlock() {
                let nextFloorPosition = self.track.getFloorPositionAt(nextTrackPosition)
                let position = self.getNextZPosition(nextFloorPosition, trackPosition: nextTrackPosition)
            self.zPosition = position
            }
       
            let moveAndAnimate = SKAction.group([move, repeatAnimation, setZPosition])
        
            track.setNextRobotTrackPosition(direction)
        
            return moveAndAnimate
        } else {
            let nextTrackPosition = self.track.getNextRobotTrackPosition(direction)
            
            let move = SKAction.moveByX(Constants.BlockFace_Size.width * CGFloat(direction.rawValue)/5, y: 0, duration: 0.32)
            
            let animate = SKAction.group([SKAction.animateWithTextures(MoveAnimationTextures(direction), timePerFrame: 0.04, resize: true, restore: false)])
            let repeatAnimation = SKAction.repeatAction(animate, count: 1)
            
            let setZPosition = SKAction.runBlock() {
                let nextFloorPosition = self.track.getFloorPositionAt(nextTrackPosition)
                let position = self.getNextZPosition(nextFloorPosition, trackPosition: nextTrackPosition)
                self.zPosition = position
            }
            
            let moveAndAnimate = SKAction.group([move, repeatAnimation])
            let sequence = SKAction.sequence([moveAndAnimate, setZPosition, jump(true)])
            
            return sequence
        }
    }
    
    func turn() -> SKAction {
        let sound = SKAction.playSoundFileNamed("Reverse.mp3", waitForCompletion: false)
        let animate = SKAction.animateWithTextures(TurnAnimationTextures(direction), timePerFrame: 0.08, resize: true, restore: false)
        let changeAnimationDirection = SKAction.runBlock() {
            self.changeAnimationDirection()
        }
        changeDirection()
        
        let action = SKAction.group([changeAnimationDirection, sound, animate])
        return action
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !turnedToFront && isOnStart {
            runAction(turnToFront())
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    }
    
    func turnToFront() -> SKAction {
        var block = SKAction.runBlock() {
            for button in self.actionButtons {
                self.addChild(button)
                button.showButton()
            }
        
            let animate = SKAction.animateWithTextures(TurnToFrontAnimationTextures(.ToRight), timePerFrame: 0.05, resize: true, restore: false)
            self.runAction(animate)
            self.turnedToFront = true
        }
        
        return block
    }
    
    func turnFromFront() {
        let animate = SKAction.animateWithTextures(TurnFromFrontAnimationTextures(.ToRight), timePerFrame: 0.05, resize: true, restore: false)
        runAction(animate)
        turnedToFront = false
        for button in actionButtons {
            button.hideButton()
        }
    }
    
    func jump(afterStep: Bool) -> SKAction {
        let nextTrackPosition = self.track.getNextRobotTrackPosition(direction)
        var currentPositionPoint = getCurrentPositionPoint()
      
        if afterStep {
            let x = Int(currentPositionPoint.x) + Int(Constants.BlockFace_Size.width * CGFloat(direction.rawValue)/5)
            currentPositionPoint.x = CGFloat(x)
        }
    
        let path = UIBezierPath()
        path.moveToPoint(currentPositionPoint)
        var endPoint = CGPoint(x: getNextPositionPoint(direction).x , y: getNextPositionPoint(direction).y + 45)
        var controlPoint: CGPoint

        if floorPosition() != track.getFloorPositionAt(nextTrackPosition) {
            controlPoint = CGPoint(x: (getNextPositionPoint(direction).x + currentPositionPoint.x)/2, y: max(getNextPositionPoint(direction).y, currentPositionPoint.y) + UIImage(named: "block")!.size.height )
        } else {
            controlPoint = CGPoint(x: (getNextPositionPoint(direction).x + currentPositionPoint.x)/2, y: max(getNextPositionPoint(direction).y, currentPositionPoint.y) + UIImage(named: "block")!.size.height/2 )
        }
        path.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        
        let setZPosition = SKAction.runBlock() {
            let nextFloorPosition = self.track.getFloorPositionAt(nextTrackPosition)
            let position = self.getNextZPosition(nextFloorPosition, trackPosition: nextTrackPosition)
            self.zPosition = position
        }
        
        let animateBegin = SKAction.animateWithTextures(JumpAnimationTextures(direction), timePerFrame: 0.04, resize: true, restore: false)
        let moveByCurve = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: false, duration: 1)
        let animateEnd =  SKAction.group([SKAction.moveTo(self.getNextPositionPoint(direction), duration: 0.2), animateBegin.reversedAction()])
        
        let sound = SKAction.playSoundFileNamed("Jump.wav", waitForCompletion: false)
        
        let sequence = SKAction.sequence([animateBegin, sound, moveByCurve, setZPosition, animateEnd])
        
        track.setNextRobotTrackPosition(direction)
        
        return sequence
    }
    
    func push() -> SKAction {
        let sequence = SKAction.sequence([push_FirstPart(), track.moveBlock(direction), push_SecondPart()])
        return sequence
    }
    
    func push_FirstPart() -> SKAction {
        let animate = SKAction.animateWithTextures(PushAnimationTextures_FirstPart(direction), timePerFrame: 0.08, resize: true, restore: false)
        let sound = SKAction.playSoundFileNamed("CubePush.mp3", waitForCompletion: false)
        let action = SKAction.group([animate, sound])
        return action
    }
    
    func push_SecondPart() -> SKAction {
        let animate = SKAction.animateWithTextures(PushAnimationTextures_SecondPart(direction), timePerFrame: 0.08, resize: true, restore: false)
        
        return animate
    }
    
    func moveToStart() {
        isOnStart = true
        position = getCGPointOfPosition(track.getRobotStartPosition(), track.getFloorPositionAt(track.getRobotStartPosition()))
    }
    
    func getStartPosition() -> Int {
        return track.getRobotStartPosition()
    }
    
    func getCurrentPositionPoint() -> CGPoint {
        return getCGPointOfPosition(trackPosition(), floorPosition())
    }
    
    func getNextPositionPoint(direction: Direction) -> CGPoint {
        return getCGPointOfPosition(trackPosition() + direction.rawValue, track.getFloorPositionAt(trackPosition() + direction.rawValue))
    }
    
    func getDirection() -> Direction {
        return direction
    }
    
    func changeDirection() {
        if direction == .ToRight {
            direction = .ToLeft
        } else {
            direction = .ToRight
        }
    }
    
    func changeAnimationDirection() {
        if animationDirection == .ToRight {
            animationDirection = .ToLeft
        } else {
            animationDirection = .ToRight
        }
    }
    
    func isTurnedToFront() -> Bool {
        return turnedToFront
    }
    
    func isOnDetailPosition() -> Bool {
        return track.robotIsOnDetailPosition()
    }
    
    private func getNextZPosition(floorPosition: FloorPosition, trackPosition: Int) -> CGFloat {
        return CGFloat(trackPosition + floorPosition.rawValue * 7)
    }
    
    private func trackPosition() -> Int {
        return track.getCurrentRobotPosition()
    }
    
    private func floorPosition() -> FloorPosition {
        return track.getFloorPositionAt(trackPosition())
    }
}
