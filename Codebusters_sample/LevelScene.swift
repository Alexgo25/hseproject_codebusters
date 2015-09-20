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

    let background = SKNode()
    let trackLayer = SKNode()
    
    let levelBackground1 = SKSpriteNode(imageNamed: "levelBackground1")
    let levelBackground2 = SKSpriteNode(imageNamed: "levelBackground2")
    
    let button_Pause = GameButton(type: .Pause)
    let button_Restart = GameButton(type: .Restart)
    let button_Tips = GameButton(type: .Tips)
    let button_Start = GameButton(type: .Start)
    let button_Debug = GameButton(type: .Debug)
    let button_Clear = GameButton(type: .Clear)
    
    var robot: Robot?
    var detail: Detail?
    var track: RobotTrack?
    
    var selectedNode = SKNode()
    
    private var blocksPattern: [FloorPosition] = []
    
    init(size: CGSize, levelPack: Int, level: Int) {
        currentLevelPack = levelPack
        currentLevel = level
        super.init(size: size)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func createTrackLayer(levelData: [String : AnyObject]) {
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
        
        trackLayer.addChild(robot!)
        trackLayer.addChild(detail!)
        
        for var i = 1; i <= blocksPattern.count; i++ {
            for var j = 0; j < blocksPattern[i - 1].rawValue; j++ {
                trackLayer.addChild(track!.getBlockAt(i, floorPosition: j))
            }
        }

        background.addChild(trackLayer)
    }
    
    override func didMoveToView(view: SKView) {
        var config = getLevelsData()
        
        var levelPacks = config["levelPacks"] as! [[String : AnyObject]]
        var levelPackData = levelPacks[currentLevelPack]
        let levels = levelPackData["levels"] as! [[String : AnyObject]]
        let levelData = levels[currentLevel]
        
        userInteractionEnabled = true
        anchorPoint = CGPointZero
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        ActionCell.cellsLayer.removeFromParent()
        addChild(ActionCell.cellsLayer)
        ActionCell.resetCells()
        
        ActionCell.cells.removeAll(keepCapacity: false)
        
        createBackground()
        createTrackLayer(levelData)
        
        if levelPackData["cellState"] as! String == DetailCellState.NonActive.rawValue {
            levelPackData.updateValue(DetailCellState.Active.rawValue, forKey: "cellState")
            levelPacks[currentLevelPack] = levelPackData
            config.setValue(levelPacks, forKey: "levelPacks")
            config.writeToFile(getLevelsDataPath(), atomically: true)
        }
        
        if let count = view.gestureRecognizers?.count {
            if count > 0 {
                view.gestureRecognizers?.removeAll(keepCapacity: false)
            }
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
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = convertPointFromView(touchLocation)
            selectNodeForTouch(touchLocation)
            
        } else if recognizer.state == .Changed && selectedNode.isEqualToNode(trackLayer) {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            panForTranslation(translation)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        } else if recognizer.state == .Ended && selectedNode.isEqualToNode(trackLayer) {
            let scrollDuration = 0.1
            let velocity = recognizer.velocityInView(recognizer.view)
            let pos = selectedNode.position
            
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            
            var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
            newPos = boundLayerPos(newPos)
            selectedNode.removeAllActions()
            
            let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
            moveTo.timingMode = .EaseOut
            selectedNode.runAction(moveTo)
            selectedNode = SKNode()
        }
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        let touchedNode = nodeAtPoint(touchLocation)
        if levelBackground1.containsPoint(touchLocation) && !levelBackground2.containsPoint(touchLocation) && !touchedNode.isMemberOfClass(GameButton) && !touchedNode.isMemberOfClass(Robot) && !touchedNode.isMemberOfClass(ActionButton) && !touchedNode.isMemberOfClass(SKLabelNode) {
            selectedNode = trackLayer
            selectedNode.removeAllActions()
        } else {
            selectedNode = SKNode()
        }
    }
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        selectedNode.position = boundLayerPos(aNewPosition)
    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        var winSize = size
        winSize.width = winSize.width - levelBackground2.size.width
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(track!.trackLength) + winSize.width))
        retval.y = position.y
    
        return retval
    }
    
    func swipedLeft(swipe: UISwipeGestureRecognizer) {
        if robot!.isOnStart {
            var touchLocation = swipe.locationInView(view)
            touchLocation = convertPointFromView(touchLocation)
            let node = nodeAtPoint(touchLocation)
            if node.isMemberOfClass(ActionCell) {
                var cell = node as! ActionCell
                ActionCell.deleteCell(cell.name!.toInt()!)
            } else if node.parent!.isMemberOfClass(ActionCell) {
                var cell = node.parent! as! ActionCell
                ActionCell.deleteCell(cell.name!.toInt()!)
            }
        }
    }
    
    func swipedUp(swipe: UISwipeGestureRecognizer) {
        var touchLocation = swipe.locationInView(view)
        touchLocation = convertPointFromView(touchLocation)
        let node = nodeAtPoint(touchLocation)
        if node.isMemberOfClass(ActionCell) && node.alpha > 0 && !robot!.isRunningActions() {
            ActionCell.moveCellsLayerUp()
        }
    }
    
    func swipedDown(swipe: UISwipeGestureRecognizer) {
        var touchLocation = swipe.locationInView(view)
        touchLocation = convertPointFromView(touchLocation)
        let node = nodeAtPoint(touchLocation)
        if node.isMemberOfClass(ActionCell) && node.alpha > 0 && !robot!.isRunningActions() {
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            let node = nodeAtPoint(touchLocation)
            switch node {
            case button_Start, button_Pause, button_Tips, button_Debug, button_Restart, button_Clear:
                return
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
                robot!.performActions()
            case button_Pause:
                pauseGame()
            case button_Tips:
                view!.presentScene(MenuScene(), transition: SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 0.5))
            case button_Clear:
                ActionCell.resetCellTextures()
                robot!.resetActions()
            case button_Debug:
                robot!.debug()
            case button_Restart:
                newGame()
            default:
                return
            }
        }
    }
    
    func createBackground() {
        levelBackground1.anchorPoint = CGPointZero
        levelBackground1.zPosition = -2
        background.addChild(levelBackground1)
        
        levelBackground2.anchorPoint = CGPointZero
        levelBackground2.position = CGPoint(x: size.width - levelBackground2.size.width, y: 0)
        levelBackground2.zPosition = 1000
        background.addChild(levelBackground2)
        
        addChild(background)
        
        background.addChild(createLabel("Программа", UIColor.blackColor(), 46, CGPoint(x: 1773, y: 1429)))
        background.addChild(createLabel("По одной", UIColor.blackColor(), 29, CGPoint(x: 1648, y: 390)))
        background.addChild(createLabel("Запуск", UIColor.blackColor(), 29, CGPoint(x: 1769, y: 217)))
        background.addChild(createLabel("Сброс", UIColor.blackColor(), 29, CGPoint(x: 1892, y: 390)))
        background.addChild(createLabel("ПОСЛЕ ЗАПУСКА", UIColor.whiteColor(), 23, CGPoint(x: 1773, y: 1296)))
        
        addChild(button_Pause)
        addChild(button_Start)
        addChild(button_Tips)
        addChild(button_Restart)
        addChild(button_Debug)
        addChild(button_Clear)
    }
    
    func pauseGame() {
        background.paused = true
        let pauseView = PauseView()
        addChild(pauseView)
    }
    
    func newGame() {
        let scene = LevelScene(size: size, levelPack: currentLevelPack, level: currentLevel)
        view!.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkRobotPosition() {
        var winSize = size
        winSize.width = winSize.width - levelBackground2.size.width
        
        if  robot!.position.x + trackLayer.position.x > winSize.width - 200 {
            trackLayer.position.x--
        }
        
        /*var retval = robot!.position
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(track!.trackLength) + winSize.width))
        retval.y = position.y
        */
    }
    
    override func update(currentTime: CFTimeInterval) {
        checkRobotPosition()
    }
}
