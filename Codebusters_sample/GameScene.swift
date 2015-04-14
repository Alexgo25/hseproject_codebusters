//
//  GameScene.swift
//  Codebusters_sample
//
//  Created by Alexander on 28.03.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit


enum SceneState {
    case Normal,Tips
}

enum NodeType: UInt32 {
    case ActionButton = 1,
    ActionCell = 2,
    Touch = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //кнопки, фон и робот
    var background: SKSpriteNode?
    var button_pause: SKSpriteNode?
    var button_tips: SKSpriteNode?
    var button_moveforward: ActionButton?
    var button_turn: ActionButton?
    var button_push: ActionButton?
    var button_jump: ActionButton?
    var robot: Robot = Robot()
    var RAM: SKSpriteNode?
    var button_Start: SKSpriteNode?
    
    var selectedNode: SKNode?
    var sceneState: SceneState = SceneState.Normal
    
    var Track: RobotTrack?
    var Touch: SKSpriteNode?
    
    func defaultScene() {
        self.removeAllChildren()
        
        background = SKSpriteNode(imageNamed: "background")
        background!.size = self.size
        background!.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background!)
        
        button_pause = SKSpriteNode(imageNamed: "button_Paused")
        button_pause!.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_pause!.position = Constants.Button_PausePosition
        addChild(button_pause!)
        
        button_tips = SKSpriteNode(imageNamed: "button_Tip")
        button_tips!.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_tips!.position = Constants.Button_TipsPosition
        addChild(button_tips!)
        
        robot = Robot()
        addChild(robot)
        
        RAM = SKSpriteNode(imageNamed: "RAM")
        RAM!.size = CGSize(width: size.width * 238/2048, height: size.height * 81/1536)
        RAM!.position = CGPoint(x: size.width * 1163/2048, y: size.height * 753/1536)
        addChild(RAM!)
        
        button_Start = SKSpriteNode(imageNamed: "button_Start")
        button_Start!.size = CGSize(width: size.width * 169/2048, height: size.height * 169/1536)
        button_Start!.position = Constants.Button_StartPosition
        addChild(button_Start!)

        button_moveforward = ActionButton(buttonType: .moveForward)
        addChild(button_moveforward!)
        
        button_turn = ActionButton(buttonType: .turn)
        addChild(button_turn!)
        
        button_push = ActionButton(buttonType: .push)
        addChild(button_push!)
        
        button_jump = ActionButton(buttonType: .jump)
        addChild(button_jump!)
        
        Touch = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 1, height: 1))
        Touch!.physicsBody = SKPhysicsBody()
        Touch!.physicsBody!.categoryBitMask = NodeType.Touch.rawValue
        
        Track = RobotTrack(robotPosition: 0)
        
        for var i = 0; i < 5; i++ {
            let standing = RobotStanding(trackPosition: i, floorPosition: .first)
            for var j = 0; j < standing.getFloorPosition().rawValue; j++ {
                addChild(standing.blocks[j])
            }
            Track!.append(standing)
        }
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        defaultScene()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case NodeType.ActionButton.rawValue | NodeType.Touch.rawValue:
            var action = contact.bodyB.node as! ActionButton?
            action!.showLabel()
        default:
            return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case NodeType.ActionButton.rawValue | NodeType.ActionCell.rawValue:
            var action = contact.bodyB.node as! ActionButton?
            action!.hideLabel()
        default:
            return
        }
    }
    
    func beginAlgorithm() {
        if robot.position == robot.getStartPosition() {
            for cell in ActionCell.cells {
                if (Track!.canPerformActionWithDirection(cell.getActionType(), direction: robot.getDirection())) {
                    robot.appendAction(cell.getActionType())
                }
            }
            robot.performActions()
        }

            if (robot.position == CGPoint(x: size.width * 515/2048 + 4 * CGFloat(236 / 2048 * size.width), y: size.height * 1052/1536)) {
                RAM!.removeFromParent()
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) -> () {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            
            if touchedNode.isKindOfClass(Robot) && !robot.isTurnedToFront() {
                robot.turnToFront(robot.getDirection())
                button_moveforward?.showButton()
                button_turn?.showButton()
                button_jump?.showButton()
                button_push?.showButton()
            }
            
            if touchedNode == background && robot.isTurnedToFront() {
                robot.turnFromFront(robot.getDirection())
                button_moveforward?.hideButton()
                button_turn?.hideButton()
                button_jump?.hideButton()
                button_push?.hideButton()
            }

            if touchedNode.isKindOfClass(ActionButton) {
                var node = touchedNode as! ActionButton
                var cell = ActionCell(actionType: node.getActionType())
                addChild(cell)
            }
            
            if touchedNode == button_Start {
                if robot.isTurnedToFront() {
                    robot.turnFromFront(robot.getDirection())
                    button_moveforward?.hideButton()
                    button_turn?.hideButton()
                    button_jump?.hideButton()
                    button_push?.hideButton()
                }
                beginAlgorithm()
            }
            /*if touchedNode.isKindOfClass(ActionButton) && selectedNode == nil {
                var touchedButton = touchedNode as? ActionButton
                var tempButton = ActionButton(buttonType: touchedButton!.getActionType())
                tempButton.zPosition = 1
                addChild(tempButton)
                
                selectedNode = tempButton
            } else if touchedNode.isKindOfClass(ActionCell) {
                var touchedAction = touchedNode as? ActionCell
                if touchedAction!.getActionType() != ActionType.none {
                var tempButton = ActionButton(buttonType: touchedAction!.getActionType())
                tempButton.zPosition = 1
                touchedAction!.setActionType(.none)
                addChild(tempButton)
                
                selectedNode = tempButton
                }
            }*/
            
            
            if (sceneState == SceneState.Normal) {
                switch touchedNode {
                case button_tips!:
                    sceneState = SceneState.Tips
                    var newBackground = SKSpriteNode(imageNamed: "tips")
                    newBackground.size = size
                    newBackground.position = CGPoint(x: size.width/2, y: size.height/2)
                    newBackground.zPosition = 2
                    addChild(newBackground)
                default:
                    return
                }
            } else {
                sceneState = SceneState.Normal
                defaultScene()
            }
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var touchedNode = nodeAtPoint(touchLocation)
            if touchedNode == Touch {
            selectedNode = Touch
            var previousLocation = touch.previousLocationInNode(self)
            
            var translation = CGPointMake(touchLocation.x - previousLocation.x, touchLocation.y - previousLocation.y)
            
            panForTranslation(translation)
            }
        }
    }
    
    func panForTranslation(translation: CGPoint) {
        var position = selectedNode!.position
        if (selectedNode?.isKindOfClass(ActionButton) != nil) {
            selectedNode!.position = CGPoint(x: selectedNode!.position.x + translation.x, y: selectedNode!.position.y + translation.y)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        selectedNode?.removeFromParent()
        selectedNode = nil
    }
}
