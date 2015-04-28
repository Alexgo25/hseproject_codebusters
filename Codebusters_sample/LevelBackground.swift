//
//  LevelBackground.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 20.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit
import UIKit

class LevelBackground: SKSpriteNode {
    
    var button_Pause: SKSpriteNode = SKSpriteNode(imageNamed: "button_Pause")
    var button_Tip: SKSpriteNode = SKSpriteNode(imageNamed: "button_Tip")
    var button_Start: SKSpriteNode = SKSpriteNode(imageNamed: "button_Start")
    var robot: Robot
    var detail: Detail
    private let blocksPattern: [FloorPosition]

    init(blocksPattern: [FloorPosition], robotPosition: Int, detailType: DetailType, detailPosition: Int, detailFloorPosition: FloorPosition) {
        var track = RobotTrack(pattern: blocksPattern, robotPosition: robotPosition, detailPosition: detailPosition)
        robot = Robot(track: track)
        self.blocksPattern = blocksPattern
        detail = Detail(detailType: detailType, trackPosition: detailPosition, floorPosition: detailFloorPosition)
        
        var texture = SKTexture(imageNamed: "levelBackground")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        xScale = Constants.ScreenSize.width/2048
        yScale = Constants.ScreenSize.height/1536
        anchorPoint = CGPoint.zeroPoint
        userInteractionEnabled = true

        button_Pause.position = Constants.Button_PausePosition
        addChild(button_Pause)
        
        button_Tip.position = Constants.Button_TipsPosition
        addChild(button_Tip)
        
        button_Start.position = Constants.Button_StartPosition
        addChild(button_Start)
    
        addChild(robot)
        addChild(detail)
        
        for var i = 1; i <= blocksPattern.count; i++ {
            for var j = 0; j < blocksPattern[i - 1].rawValue; j++ {
                addChild(track.getBlockAt(i, floorPosition: j))
            }
        }
        
        ActionCell.cells.removeAll(keepCapacity: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func revertChanges() {
        removeAllChildren()
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            
            switch node {
            case button_Start:
                runAction(SKAction.playSoundFileNamed("StartButton.mp3", waitForCompletion: false))
                if robot.isOnStart {
                    if robot.isOnDetailPosition() {
                        robot.takeDetail(detail.hideDetail())
                    }
                    robot.performActions()
                }
            case button_Pause:
                /*let texture = SKTexture(imageNamed: "pauseBackground")
                let background = SKSpriteNode(texture: texture, color: UIColor(), size: texture.size())
                background.anchorPoint = CGPoint.zeroPoint
                background.position = CGPoint.zeroPoint
                let continueTexture = SKTexture(imageNamed: "continue")
                let continueButton = SKSpriteNode(texture: continueTexture, color: UIColor(), size: continueTexture.size())*/
                
                
                runAction(SKAction.playSoundFileNamed("PauseButton.mp3", waitForCompletion: false))
                revertChanges()
            case button_Tip:
                runAction(SKAction.playSoundFileNamed("TipButton.mp3", waitForCompletion: false))
            default:
                if robot.isTurnedToFront() {
                    robot.turnFromFront(robot.getDirection())
                }
            }
        }
    }
}