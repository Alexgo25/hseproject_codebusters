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
    var robot: Robot?
    var detail: Detail?
    var track: RobotTrack?
    private var blocksPattern: [FloorPosition] = []
    
    init(size: CGSize, level: Int) {
        currentLevel = level
        super.init(size: size)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func createScenery(levelData: [String:AnyObject]) {
        ActionCell.cells.removeAll(keepCapacity: false)
        
        let blocks: AnyObject? = levelData["blocksPattern"]
        if let pattern = blocks as? [Int] {
            for block in pattern {
                if let floor = FloorPosition(rawValue: block) {
                    blocksPattern.append(floor)
                }
            }
        }
        
        let robotPosition = levelData["robotPosition"] as! Int
        let detailPosition = levelData["detailPosition"] as! Int
        
        let detailFloorPositionInt = levelData["detailFloorPosition"] as! Int
        let detailFloorPosition = FloorPosition(rawValue: detailFloorPositionInt)
        
        track = RobotTrack(pattern: blocksPattern, robotPosition: robotPosition, detailPosition: detailPosition)
        
        robot = Robot(track: track!)

        let detailTypeString  = levelData["detailType"] as! String
        if let detailType = DetailType(rawValue: detailTypeString) {
            detail = Detail(detailType: detailType, trackPosition: detailPosition, floorPosition: detailFloorPosition!)
        }
        
        levelBackground.anchorPoint =  CGPointZero
        levelBackground.zPosition = -1
        
        userInteractionEnabled = true
        button_Pause.position = Constants.Button_PausePosition
        button_Tip.position = Constants.Button_TipsPosition
        button_Start.position = Constants.Button_StartPosition
        anchorPoint = CGPointZero
        
        addChild(levelBackground)
        addChild(button_Pause)
        addChild(button_Start)
        addChild(button_Tip)
        addChild(robot!)
        addChild(detail!)
        
        for var i = 1; i <= blocksPattern.count; i++ {
            for var j = 0; j < blocksPattern[i - 1].rawValue; j++ {
                addChild(track!.getBlockAt(i, floorPosition: j))
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        var path = NSBundle.mainBundle().pathForResource("Levels", ofType: "plist")
        var config = NSMutableDictionary(contentsOfFile: path!)!
        var levels = config["levels"] as! [[String : AnyObject]]
        var levelData = levels[currentLevel]
        
        createScenery(levelData)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        if levelData["cellState"] as! String == DetailCellState.NonActive.rawValue {
            levelData.updateValue(DetailCellState.Active.rawValue, forKey: "cellState")
            levels[currentLevel] = levelData
            config.setValue(levels, forKey: "levels")
            config.writeToFile(path!, atomically: true)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case PhysicsCategory.Robot | PhysicsCategory.Detail:
            detail!.hideDetail()
            robot!.takeDetail()
            
            var path = NSBundle.mainBundle().pathForResource("Levels", ofType: "plist")
            var config = NSMutableDictionary(contentsOfFile: path!)!
            var levels = config["levels"] as! [[String : AnyObject]]
            var levelData = levels[currentLevel]
            
            if levelData["cellState"] as! String != DetailCellState.Placed.rawValue {
                levelData.updateValue(DetailCellState.Placed.rawValue, forKey: "cellState")
                levels[currentLevel] = levelData
                config.setValue(levels, forKey: "levels")
                config.writeToFile(path!, atomically: true)
            }
            
            if currentLevel < 5 {
                currentLevel++
                runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.runBlock(newGame)]))
            } else {
                
                runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.runBlock(newGame)]))
            }
        
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
                if robot!.isTurnedToFront() {
                    robot!.turnFromFront()
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
                robot!.performActions()
            case button_Pause:
                button_Pause.texture = SKTexture(imageNamed: "button_Pause")
                runAction(SKAction.playSoundFileNamed("PauseButton.mp3", waitForCompletion: false))
                let pauseView = PauseView()
                addChild(pauseView)
            case button_Tip:
                button_Tip.texture = SKTexture(imageNamed: "button_Tip")
                runAction(SKAction.playSoundFileNamed("TipButton.mp3", waitForCompletion: false))
                view!.presentScene(MenuScene(), transition: SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 0.5))
            default:
                return
            }
        }
    }
    
    /*class func level(levelNumber: Int) -> LevelScene? {
        var scene = getLevel(levelNumber)
        scene!.scaleMode = .AspectFill
        scene!.currentLevel = levelNumber
        return scene
    }*/

    func newGame() {
        let scene = LevelScene(size: size, level: currentLevel)
        view!.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
