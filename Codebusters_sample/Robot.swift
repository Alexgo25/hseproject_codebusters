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
    private var tempPosition: Int = 0
    private var turnedToFront: Bool = false
    var track: RobotTrack
    private let actionButtons: [ActionButton] = [ActionButton(type: .moveForward), ActionButton(type: .turn), ActionButton(type: .push), ActionButton(type: .jump)]
    var isOnStart = true
    
    
    init(track: RobotTrack) {
        var texture = SKTexture(imageNamed: "robot")
        self.track = track
        super.init(texture: texture, color: UIColor(), size: texture.size())
        tempPosition = trackPosition()
        zPosition = CGFloat(floorPosition().rawValue * 7 + trackPosition())
        moveToStart()
        actions = []
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func canPerformAction(actionType: ActionType) -> Bool {
        return track.canPerformActionWithDirection(actionType, direction: direction)
    }
    
    func appendAction(actionType: ActionType) {
        parent!.addChild(ActionCell(actionType: actionType))
        if canPerformAction(actionType) {
            actions.append(ActionCell.cells.last!.highlightBegin())
            switch actionType {
            case .moveForward:
                actions.append(moveForward(direction))
                
            case .turn:
                actions.append(turn(direction))
            
            case .jump:
                actions.append(jump(direction))
            
            case .push:
                actions.append(push_FirstPart(direction))
                actions.append(track.moveBlock(direction))
                actions.append(push_SecondPart(direction))
            
            default:
                println()
            }
            actions.append(ActionCell.cells.last!.highlightEnd())
        } else {
            let turn = SKAction.animateWithTextures(TurnToFrontAnimationTextures(direction), timePerFrame: 0.05)
            actions.append(turn)
            actions.append(SKAction.runBlock( { self.removeActionForKey("sequence") } ))
        }
    }
    
    func performActions() {
        if turnedToFront {
            turnFromFront(direction)
        }
        
        let sequence = SKAction.sequence(actions)
        if !actions.isEmpty {
            isOnStart = false
            runAction(sequence, withKey: "sequence")
        }
    }
    
    func moveForward(direction: Direction) -> SKAction {
        let move = SKAction.moveTo(getNextTempPositionCGPoint(direction), duration: 1.6)
        let animate = SKAction.group([SKAction.animateWithTextures(MoveAnimationTextures(direction), timePerFrame: 0.04, resize: true, restore: false)])
        let repeatAnimation = SKAction.repeatAction(animate, count: 5)
        
        let position = getZPosition(track.getFloorPositionAt(track.getNextRobotTrackPosition(direction)), tempPosition: tempPosition)
        let action = SKAction.runBlock( {
            self.zPosition = position
        } )
        let moveAndAnimate = SKAction.group([move, repeatAnimation, action])
        
        tempPosition += direction.rawValue
        track.setNextRobotTrackPosition(direction)
        
        return moveAndAnimate
    }
    
    func turn(direction: Direction) -> SKAction {
        let sound = SKAction.playSoundFileNamed("Reverse.mp3", waitForCompletion: false)
        
        let animate = SKAction.animateWithTextures(TurnAnimationTextures(direction), timePerFrame: 0.08, resize: true, restore: false)
        
        changeDirection()
        let action = SKAction.group([sound, animate])
        return action
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !turnedToFront {
            runAction(turnToFront(direction))
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    }
    
    func turnToFront(direction: Direction) -> SKAction {
        var block = SKAction.runBlock( {
        for button in self.actionButtons {
            self.addChild(button)
            button.showButton()
        }
        
        let animate = SKAction.animateWithTextures(TurnToFrontAnimationTextures(direction), timePerFrame: 0.05, resize: true, restore: false)
        self.runAction(animate)
        self.turnedToFront = true
        } )
        return block
    }
    
    func turnFromFront(direction: Direction) {
        let animate = SKAction.animateWithTextures(TurnFromFrontAnimationTextures(direction), timePerFrame: 0.05, resize: true, restore: false)
        runAction(animate)
        turnedToFront = false
        for button in actionButtons {
            button.hideButton()
        }
    }
    
    func jump(direction: Direction) -> SKAction {
        
        /*let moveUp = SKAction.moveToY(max(getNextTempPositionCGPoint(direction).y, getTempPositionCGPoint().y) + Constants.BlockFace_Size.height/3, duration: 0.5)
        let move = SKAction.moveToX(getNextTempPositionCGPoint(direction).x, duration: 0.5)
        let moveDown = SKAction.moveTo(getNextTempPositionCGPoint(direction), duration: 0.5)
        let action = SKAction.runBlock( { self.zPosition = self.getTempZPosition(self.track.getNextTrackFloorPosition(direction)) } )
        let animateBegin = SKAction.animateWithTextures(JumpAnimationTextures(direction), timePerFrame: 0.04, resize: true, restore: false)
        let animateEnd = animateBegin.reversedAction()
        let sequence = SKAction.sequence([animateBegin, moveUp, action, move, moveDown, animateEnd])
        */
        
        let path = UIBezierPath()
        path.moveToPoint(getTempPositionCGPoint())
        var endPoint = CGPoint(x: getNextTempPositionCGPoint(direction).x, y: getNextTempPositionCGPoint(direction).y + 45)
        var controlPoint = CGPoint(x: (getNextTempPositionCGPoint(direction).x + getTempPositionCGPoint().x)/2, y: max(getNextTempPositionCGPoint(direction).y, getTempPositionCGPoint().y) + UIImage(named: "block")!.size.height )
        
        path.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        
        let position = getZPosition(track.getFloorPositionAt(track.getNextRobotTrackPosition (direction)), tempPosition: tempPosition)
        let action = SKAction.runBlock( { self.zPosition = position } )
        
        let animateBegin = SKAction.animateWithTextures(JumpAnimationTextures(direction), timePerFrame: 0.04, resize: true, restore: false)
        let moveByCurve = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: false, duration: 1)
        let animateEnd =  SKAction.group([SKAction.moveTo(self.getNextTempPositionCGPoint(direction), duration: 0.2), animateBegin.reversedAction()])
        let sound = SKAction.playSoundFileNamed("Jump.wav", waitForCompletion: false)
        
        let sequence = SKAction.sequence([animateBegin, sound, moveByCurve, action, animateEnd])
        
        tempPosition += direction.rawValue
        track.setNextRobotTrackPosition(direction)
        
        return sequence
    }
    
    func push_FirstPart(direction: Direction) -> SKAction {
        let animate = SKAction.animateWithTextures(PushAnimationTextures_FirstPart(direction), timePerFrame: 0.08, resize: true, restore: false)
        let sound = SKAction.playSoundFileNamed("CubePush.mp3", waitForCompletion: false)
        let action = SKAction.group([animate, sound])
        return action
    }
    
    func push_SecondPart(direction: Direction) -> SKAction {
        let animate = SKAction.animateWithTextures(PushAnimationTextures_SecondPart(direction), timePerFrame: 0.08, resize: true, restore: false)
        
        return animate
    }
    
    func takeDetail(action: SKAction) {
        actions.append(action)
        let turn = SKAction.animateWithTextures(TurnToFrontAnimationTextures(direction), timePerFrame: 0.05)
        actions.append(turn)
        let sound = SKAction.playSoundFileNamed("LevelCompleted.mp3", waitForCompletion: false)
        actions.append(sound)
        //MenuBackground.details[MenuBackground.currentLevel].setCellState(.Placed)
        if MenuBackground.currentLevel < 6 {
            MenuBackground.currentLevel++
            //MenuBackground.details[MenuBackground.currentLevel].setCellState(.Active)
        }
        
        let transition = SKAction.runBlock( {
            let scene: SKScene
            if MenuBackground.currentLevel < 6 {
                scene = getLevel(MenuBackground.details[MenuBackground.currentLevel].getDetailType())
            } else {
                scene = MenuScene()
            }
            let transition = SKTransition.crossFadeWithDuration(0.7)
            let action: Void? = self.scene?.view?.presentScene(scene, transition: transition)
        } )
        actions.append(transition)
    }
    
    func moveToStart() {
        isOnStart = true
        position = getCGPointOfPosition(track.getRobotStartPosition(), track.getFloorPositionAt(track.getRobotStartPosition()))
        tempPosition = track.getCurrentRobotPosition()
    }
    
    func getStartPosition() -> Int {
        return track.getRobotStartPosition()
    }
    
    func getTempPositionCGPoint() -> CGPoint {
        return getCGPointOfPosition(tempPosition, track.getFloorPositionAt(tempPosition))
    }
    
    func getNextTempPositionCGPoint(direction: Direction) -> CGPoint {
        return getCGPointOfPosition(tempPosition + direction.rawValue, track.getFloorPositionAt(tempPosition + direction.rawValue))
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
    
    /*func iSOnStart() -> Bool {
        return position == getCGPointOfPosition(getStartPosition(), track.getFloorPositionAt(getStartPosition()))
    }*/
    
    func isOnDetailPosition() -> Bool {
        return track.robotIsOnDetailPosition()
    }
    
    private func getZPosition(floorPosition: FloorPosition, tempPosition: Int) -> CGFloat {
        return CGFloat(tempPosition + floorPosition.rawValue * 7)
    }
    
    private func trackPosition() -> Int {
        return track.getCurrentRobotPosition()
    }
    
    private func floorPosition() -> FloorPosition {
        return track.getFloorPositionAt(trackPosition())
    }
}
