//
//  LevelScene.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 28.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class LevelScene: SKScene, SKPhysicsContactDelegate {
    var currentLevel = 0

    var levelBackground = SKSpriteNode(imageNamed: "levelBackground")
    var button_Pause = SKSpriteNode(imageNamed: "button_Pause")
    var button_Tip = SKSpriteNode(imageNamed: "button_Tip")
    var button_Start = SKSpriteNode(imageNamed: "button_Start")
    var robot: Robot
    var detail: Detail
    private let blocksPattern: [FloorPosition]
    
    init(blocksPattern: [FloorPosition], robotPosition: Int, detailType: DetailType, detailPosition: Int, detailFloorPosition: FloorPosition) {
        
        var track = RobotTrack(pattern: blocksPattern, robotPosition: robotPosition, detailPosition: detailPosition)
        robot = Robot(track: track)
        self.blocksPattern = blocksPattern
        detail = Detail(detailType: detailType, trackPosition: detailPosition, floorPosition: detailFloorPosition)
        levelBackground.anchorPoint =  CGPointZero
        super.init(size: CGSize(width: 2048, height: 1536))
        
        self.userInteractionEnabled = true
        button_Pause.position = Constants.Button_PausePosition
        button_Tip.position = Constants.Button_TipsPosition
        button_Start.position = Constants.Button_StartPosition
        anchorPoint = CGPointZero
    }
    
    override func didMoveToView(view: SKView) {
        revertChanges()
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    func revertChanges() {
        removeAllChildren()
        addChild(levelBackground)
        addChild(button_Pause)
        addChild(button_Start)
        addChild(button_Tip)
        
        let robotPosition = robot.getStartPosition()
        let detailTrackPosition = detail.getTrackPosition()
        let detailFloorPosition = detail.getFloorPosition()
        let detailType = detail.getDetailType()
        
        var track = RobotTrack(pattern: blocksPattern, robotPosition: robotPosition, detailPosition: detailTrackPosition)
        robot = Robot(track: track)
        detail = Detail(detailType: detailType, trackPosition: detailTrackPosition, floorPosition: detailFloorPosition)
        
        addChild(robot)
        addChild(detail)
        
        for var i = 1; i <= blocksPattern.count; i++ {
            for var j = 0; j < blocksPattern[i - 1].rawValue; j++ {
                addChild(track.getBlockAt(i, floorPosition: j))
            }
        }
        
        ActionCell.cells.removeAll(keepCapacity: false)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case PhysicsCategory.Robot | PhysicsCategory.Detail:
            detail.hideDetail()
            robot.takeDetail()
            if currentLevel < 6 {
                currentLevel++
            }
            runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.runBlock(newGame)]))
        default:
            return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            switch node {
            case button_Start:
                return
            case button_Pause:
                button_Pause.texture = SKTexture(imageNamed: "button_Pause_Pressed")
            case button_Tip:
                button_Tip.texture = SKTexture(imageNamed: "button_Tip_Pressed")
            default:
                if robot.isTurnedToFront() {
                    robot.turnFromFront()
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            
            switch node {
            case button_Start:
                runAction(SKAction.playSoundFileNamed("StartButton.mp3", waitForCompletion: false))
                robot.performActions()
            case button_Pause:
                button_Pause.texture = SKTexture(imageNamed: "button_Pause")
                runAction(SKAction.playSoundFileNamed("PauseButton.mp3", waitForCompletion: false))
                let pauseView = PauseView()
                addChild(pauseView)
            case button_Tip:
                button_Tip.texture = SKTexture(imageNamed: "button_Tip")
                runAction(SKAction.playSoundFileNamed("TipButton.mp3", waitForCompletion: false))
            default:
                return
            }
        }
    }
    
    class func level(levelNumber: Int) -> LevelScene? {
        var scene = getLevel(levelNumber)
        scene!.scaleMode = .AspectFill
        scene!.currentLevel = levelNumber
        return scene
    }

    func newGame() {
        if let scene = LevelScene.level(currentLevel) {
            self.view!.presentScene(scene)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
