//
//  LevelScene.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 28.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class LevelScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    var currentLevel = 0
    var currentLevelPack = 0

    var levelBackground = SKSpriteNode(imageNamed: "levelBackground")
    var button_Pause = GameButton(type: .Pause)
    var button_Tip = GameButton(type: .Tip)
    var button_Start = GameButton(type: .Start)
    var button_Debug = GameButton(type: .Debug)
    var button_Clear = GameButton(type: .Clear)
    var gameButtons: [GameButton] = []
    
    var robot: Robot?
    var detail: Detail?
    var track: RobotTrack?
    private var blocksPattern: [FloorPosition] = []
    
    init(size: CGSize, levelPack: Int, level: Int) {
        currentLevelPack = levelPack
        currentLevel = level
        super.init(size: size)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func createScenery(levelData: [String : AnyObject]) {
        ActionCell.cellsLayer.removeFromParent()
        addChild(ActionCell.cellsLayer)
        ActionCell.resetCells()
        
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
        anchorPoint = CGPointZero
        
        addChild(levelBackground)
        addChild(button_Pause)
        addChild(button_Start)
        addChild(button_Tip)
        addChild(button_Debug)
        addChild(button_Clear)
        addChild(robot!)
        addChild(detail!)
        
        gameButtons = [button_Pause, button_Start, button_Debug, button_Clear, button_Tip]
        
        for var i = 1; i <= blocksPattern.count; i++ {
            for var j = 0; j < blocksPattern[i - 1].rawValue; j++ {
                addChild(track!.getBlockAt(i, floorPosition: j))
            }
        }
    }

    override func didMoveToView(view: SKView) {
        var config = getLevelsData()
        
        var levelPacks = config["levelPacks"] as! [[String : AnyObject]]
        var levelPackData = levelPacks[currentLevelPack]
        let levels = levelPackData["levels"] as! [[String : AnyObject]]
        let levelData = levels[currentLevel]
        
        createScenery(levelData)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        if levelPackData["cellState"] as! String == DetailCellState.NonActive.rawValue {
            levelPackData.updateValue(DetailCellState.Active.rawValue, forKey: "cellState")
            levelPacks[currentLevelPack] = levelPackData
            config.setValue(levelPacks, forKey: "levelPacks")
            config.writeToFile(getLevelsDataPath(), atomically: true)
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        swipeLeft.delegate = self
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        swipeUp.delegate = self
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        swipeDown.delegate = self
        view.addGestureRecognizer(swipeDown)
    }
    
    func swipedLeft(swipe: UISwipeGestureRecognizer) {
        if robot!.isOnStart {
            var touchLocation = swipe.locationInView(view)
            touchLocation.x *= 2
            touchLocation.y = 1536 - touchLocation.y * 2
            let node = nodeAtPoint(touchLocation)
            if node.isMemberOfClass(ActionCell) && node.alpha > 0 {
                var cell = node as! ActionCell
                
                cell = ActionCell.cells[cell.name!.toInt()!]
                let action = SKAction.group([SKAction.moveByX(-100, y: 0, duration: 0.2), SKAction.fadeOutWithDuration(0.2)])
            
                cell.runAction(SKAction.sequence([action, SKAction.removeFromParent()]), completion: {
                    ActionCell.cells.removeAtIndex(cell.name!.toInt()!)
                    
                    var array: [ActionCell] = []

                    self.robot!.resetActions()
                    
                    for cell in ActionCell.cells {
                        array.append(cell)
                        cell.removeFromParent()
                        ActionCell.cells.removeAtIndex(0)
                    }
            
                    for var i = 0; i < array.count; i++ {
                        self.robot!.appendAction(array[i].getActionType())
                    }
                } )
            }
        }
    }
    
    func swipedUp(swipe: UISwipeGestureRecognizer) {
        var touchLocation = swipe.locationInView(view)
        touchLocation.x *= 2
        touchLocation.y = 1536 - touchLocation.y * 2
        let node = nodeAtPoint(touchLocation)
        if node.isMemberOfClass(ActionCell) && !robot!.isDebuggingOrRunningActions() {
            ActionCell.moveCellsLayerUp()
        }
    }
    
    func swipedDown(swipe: UISwipeGestureRecognizer) {
        var touchLocation = swipe.locationInView(view)
        touchLocation.x *= 2
        touchLocation.y = 1536 - touchLocation.y * 2
        let node = nodeAtPoint(touchLocation)
        if node.isMemberOfClass(ActionCell) && !robot!.isDebuggingOrRunningActions() {
            ActionCell.moveCellsLayerDown()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case PhysicsCategory.Robot | PhysicsCategory.Detail:
            detail!.hideDetail()
            robot!.takeDetail()
            
            var config = getLevelsData()
            var levelPacks = config["levelPacks"] as! [[String : AnyObject]]
            var levelPackData = levelPacks[currentLevelPack]
            let levels = levelPackData["levels"] as! [[String : AnyObject]]
            
            if detail!.getDetailType() == DetailType.Crystall {
                if currentLevel < levels.count - 1 {
                    currentLevel++
                    runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.runBlock(newGame)]))
                }
            } else {
                if levelPackData["cellState"] as! String != DetailCellState.Placed.rawValue {
                    levelPackData.updateValue(DetailCellState.Placed.rawValue, forKey: "cellState")
                    levelPacks[currentLevelPack] = levelPackData
                    
                    if currentLevelPack < levelPacks.count - 1 {
                        if levelPacks[currentLevelPack + 1]["cellState"] as! String == DetailCellState.NonActive.rawValue {
                            var nextLevelPack = levelPacks[currentLevelPack + 1]
                            nextLevelPack.updateValue(DetailCellState.Active.rawValue, forKey: "cellState")
                            levelPacks[currentLevelPack + 1] = nextLevelPack
                        }
                    }
                    
                    config.setValue(levelPacks, forKey: "levelPacks")
                    config.writeToFile(getLevelsDataPath(), atomically: true)
                }
                
                view!.presentScene(MenuScene(), transition: SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 1))
                
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
            let touchLocation = touch.locationInNode(self)
            let node = nodeAtPoint(touchLocation)
            switch node {
            case button_Start, button_Pause, button_Tip, button_Debug, button_Clear:
                var button = node as! GameButton
                button.touched()
            default:
                if robot!.isTurnedToFront() && !node.isMemberOfClass(ActionCell) {
                    robot!.runAction(robot!.turnFromFront())
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
                if button_Start.isTouched {
                    button_Start.resetTexture()
                    runAction(SKAction.playSoundFileNamed("StartButton.mp3", waitForCompletion: false))
                    robot!.performActions()
                }
            case button_Pause:
                if button_Pause.isTouched {
                    button_Pause.resetTexture()
                    button_Pause.texture = SKTexture(imageNamed: "button_Pause")
                    runAction(SKAction.playSoundFileNamed("PauseButton.mp3", waitForCompletion: false))
                    let pauseView = PauseView()
                    addChild(pauseView)
                }
            case button_Tip:
                if button_Tip.isTouched {
                    button_Tip.resetTexture()
                    button_Tip.texture = SKTexture(imageNamed: "button_Tip")
                runAction(SKAction.playSoundFileNamed("TipButton.mp3", waitForCompletion: false))
                    view!.presentScene(MenuScene(), transition: SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 0.5))
                }
            case button_Clear:
                if button_Clear.isTouched && robot!.isOnStart {
                    button_Clear.resetTexture()
                    self.robot!.resetActions()
                
                    ActionCell.resetCells()
                }
            case button_Debug:
                if button_Debug.isTouched {
                    button_Debug.resetTexture()
                    runAction(SKAction.playSoundFileNamed("StartButton.mp3", waitForCompletion: false))
                    robot!.debug()
                }
            default:
                return
            }
     
            for button in gameButtons {
                if button.isTouched {
                    button.resetTexture()
                }
            }
        }
    }
    
    func newGame() {
        let scene = LevelScene(size: size, levelPack: currentLevelPack, level: currentLevel)
        view!.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
