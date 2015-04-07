//
//  GameScene.swift
//  Codebusters_sample
//
//  Created by Alexander on 28.03.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit


enum SceneState{
    case Normal,Tips
}

class GameScene: SKScene {
    
    //кнопки, фон и робот
    var background: SKSpriteNode?
    var button_pause: SKSpriteNode?
    var button_tips: SKSpriteNode?
    var button_moveforward: SKSpriteNode?
    var button_turn: SKSpriteNode?
    var robot: Robot?
    var RAM: SKSpriteNode?
    var button_Start: SKSpriteNode?
    var tempbutton_moveforward: SKSpriteNode?
    var tempbutton_turn: SKSpriteNode?
    
    //блоки программы
    var firstBlockButton: SKSpriteNode?
    var secondBlockButton: SKSpriteNode?
    var thirdBlockButton: SKSpriteNode?
    var fourthBlockButton: SKSpriteNode?
    
    //центры блоков
    var firstBlockCenter: CGPoint?
    var secondBlockCenter: CGPoint?
    var thirdBlockCenter: CGPoint?
    var fourthBlockCenter: CGPoint?
    
    var selectedNode: SKNode?
    
    var sceneState: SceneState = SceneState.Normal
    
    var moves: [String] = []
    
    func defaultScene() {
        self.removeAllChildren()
        
        background = SKSpriteNode(imageNamed: "background_upd")
        background?.size = self.size
        background?.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background!)
        
        button_pause = SKSpriteNode(imageNamed: "button_Paused")
        button_pause?.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_pause?.position = CGPoint(x: size.width * 128 / 2048, y: size.height * 1387 / 1536)
        button_pause?.name = "pause"
        addChild(button_pause!)
        
        button_tips = SKSpriteNode(imageNamed: "button_Tip")
        button_tips?.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_tips?.position = CGPoint(x: size.width * 128/2048, y: size.height * 1257/1536)
        button_tips?.name = "tips"
        addChild(button_tips!)
        
        robot = Robot(startPosition : CGPoint(x: size.width * 515/2048, y: size.height * 1052/1536),
                      size :CGSize(width: size.width * 225/2048, height: size.height * 356/1536))
        robot?.name = "robot"
        addChild(robot!)
        
        RAM = SKSpriteNode(imageNamed: "RAM")
        RAM?.size = CGSize(width: size.width * 238/2048, height: size.height * 81/1536)
        RAM?.position = CGPoint(x: size.width * 1506/2048, y: size.height * 989/1536)
        RAM?.name = "RAM"
        addChild(RAM!)
        
        button_Start = SKSpriteNode(imageNamed: "button_Start")
        button_Start?.size = CGSize(width: size.width * 169/2048, height: size.height * 169/1536)
        button_Start?.position = CGPoint(x: size.width * 1660/2048, y: size.height * 194/1536)
        button_Start?.name = "start"
        addChild(button_Start!)
        
        button_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
        button_moveforward?.size = CGSize(width: size.width * 119/2048, height: size.height * 118/1536)
        button_moveforward?.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
        button_moveforward?.name = "moveforward"
        addChild(button_moveforward!)
        
        button_turn = SKSpriteNode(imageNamed: "button_Turn")
        button_turn?.size = CGSize(width: size.width * 119/2048, height: size.height * 118/1536)
        button_turn?.position = CGPoint(x: size.width * 560/2048, y: size.height * 218/1536)
        button_turn?.name = "turn"
        addChild(button_turn!)
        
        
        
        firstBlockCenter = CGPoint(x: size.width * 879/2048, y: size.height * 193/1536)
        secondBlockCenter = CGPoint(x: size.width * 1017/2048, y: size.height * 193/1536)
        thirdBlockCenter = CGPoint(x: size.width * 1155/2048, y: size.height * 193/1536)
        fourthBlockCenter = CGPoint(x: size.width * 1293/2048, y: size.height * 193/1536)
    }
    
    override func didMoveToView(view: SKView) {
        defaultScene()
    }
    
    func beginAlgorithm() {
        if robot?.position == robot?.startingPosition {
            for move in moves {
                switch move {
                case "forward":
                    robot?.moveForward()
                case "turn":
                    robot?.turn()
                default:
                    return
                }
            }
            
            if (robot?.position == CGPoint(x: size.width * 515/2048 + 4 * CGFloat(236 / 2048 * size.width), y: size.height * 1052/1536)) {
                RAM?.removeFromParent()
            }
        }
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches
        {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            selectedNode = touchedNode
            
            if (sceneState == SceneState.Normal) {
                beginAlgorithm()
            
                /*
                if (robot?.position == robot?.startingPosition) {
                    if (touchedNode == button_Start) {
                        for move in moves {
                            if (move == "forward") {
                                robot!.moveForward()
                            }
                    
                            if (move == "turn") {
                                robot!.turn()
                            }
                        }
                    
                        if (robot?.position == CGPoint(x: size.width * 515/2048 + 4 * CGFloat(236 / 2048 * size.width), y: size.height * 1052/1536)) {
                            RAM?.removeFromParent()
                        }
                    }
                }*/
            
                /*if (touchedNode == button_moveforward ) {
                    if (tempbutton_moveforward == nil) {
                        tempbutton_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
                        tempbutton_moveforward!.size = button_moveforward!.size
                        tempbutton_moveforward!.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
                        tempbutton_moveforward!.zPosition = 1
                        addChild(tempbutton_moveforward!)
                    }
                }
               
                if (touchedNode == button_turn) {
                    if (tempbutton_turn == nil) {
                        tempbutton_turn = SKSpriteNode(imageNamed: "button_Turn")
                        tempbutton_turn!.size = button_turn!.size
                        tempbutton_turn!.position = CGPoint(x: size.width * 560/2048, y: size.height * 218/1536)
                        tempbutton_turn!.zPosition = 1
                        addChild(tempbutton_turn!)
                    }
                }*/
          
                if (touchedNode == button_tips) {
                    sceneState = SceneState.Tips
                    var newBackground = SKSpriteNode(imageNamed : "tips")
                    newBackground.size = size
                    newBackground.position = CGPoint(x: size.width/2, y: size.height/2)
                    newBackground.zPosition = 2
                    addChild(newBackground)
                    
                }
                if (touchedNode == button_pause)
                {
                    robot?.moveForward()
                }
            }
            
            else if (sceneState == SceneState.Tips) {
                sceneState = SceneState.Normal
                defaultScene()
            }
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            var translation = CGPointMake(touchLocation.x - previousLocation.x, touchLocation.y - previousLocation.y)
            
            panForTranslation(translation)
            
            //let touchedNode = nodeAtPoint(touchLocation)
            //if (touchedNode == tempbutton_moveforward ) {
            //    tempbutton_moveforward!.position = touchLocation
            //}
            //else if (touchedNode == tempbutton_turn) {
            //    tempbutton_turn!.position = touchLocation
            //}
        }
    }
    
    func panForTranslation(translation: CGPoint) {
        var position = selectedNode?.position
        if (selectedNode == button_moveforward || selectedNode == button_turn) {
            selectedNode?.position = CGPoint(x: selectedNode!.position.x + translation.x, y: selectedNode!.position.y + translation.y)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch : AnyObject in touches
        {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            
            if (touchedNode == tempbutton_turn)
            {
                if (detailIsNearTheCenterPosition(firstBlockCenter!, detail: tempbutton_turn!))
                {
                    firstBlockButton = SKSpriteNode(imageNamed: "button_Turn")
                    firstBlockButton!.size = button_turn!.size
                    firstBlockButton!.position = firstBlockCenter!
                    addChild(firstBlockButton!)
                    tempbutton_turn!.removeFromParent()
                    tempbutton_turn = nil
                    moves.append("turn")
                }
                else if (detailIsNearTheCenterPosition(secondBlockCenter!, detail: tempbutton_turn!))
                {
                    secondBlockButton = SKSpriteNode(imageNamed: "button_Turn")
                    secondBlockButton!.size = button_turn!.size
                    secondBlockButton!.position = secondBlockCenter!
                    addChild(secondBlockButton!)
                    tempbutton_turn!.removeFromParent()
                    tempbutton_turn = nil
                    moves.append("turn")
                }
                else if (detailIsNearTheCenterPosition(thirdBlockCenter!, detail: tempbutton_turn!))
                {
                    thirdBlockButton = SKSpriteNode(imageNamed: "button_Turn")
                    thirdBlockButton!.size = button_turn!.size
                    thirdBlockButton!.position = thirdBlockCenter!
                    addChild(thirdBlockButton!)
                    tempbutton_turn!.removeFromParent()
                    tempbutton_turn = nil
                    moves.append("turn")
                }
                else if (detailIsNearTheCenterPosition(fourthBlockCenter!, detail: tempbutton_turn!))
                {
                    fourthBlockButton = SKSpriteNode(imageNamed: "button_Turn")
                    fourthBlockButton!.size = button_turn!.size
                    fourthBlockButton!.position = fourthBlockCenter!
                    addChild(fourthBlockButton!)
                    tempbutton_turn!.removeFromParent()
                    tempbutton_turn = nil
                    moves.append("turn")
                }

                else {
                tempbutton_turn?.removeFromParent()
                tempbutton_turn = nil
                }
            }

            if (touchedNode == tempbutton_moveforward)
            {
                if (detailIsNearTheCenterPosition(firstBlockCenter!, detail: tempbutton_moveforward!))
                {
                    firstBlockButton = SKSpriteNode(imageNamed: "button_moveforward")
                    firstBlockButton!.size = button_moveforward!.size
                    firstBlockButton!.position = firstBlockCenter!
                    addChild(firstBlockButton!)
                    tempbutton_moveforward!.removeFromParent()
                    tempbutton_moveforward = nil
                    moves.append("forward")
                }
                else if (detailIsNearTheCenterPosition(secondBlockCenter!, detail: tempbutton_moveforward!))
                {
                    secondBlockButton = SKSpriteNode(imageNamed: "button_moveforward")
                    secondBlockButton!.size = button_moveforward!.size
                    secondBlockButton!.position = secondBlockCenter!
                    addChild(secondBlockButton!)
                    tempbutton_moveforward!.removeFromParent()
                    tempbutton_moveforward = nil
                    moves.append("forward")
                }
                else if (detailIsNearTheCenterPosition(thirdBlockCenter!, detail: tempbutton_moveforward!))
                {
                    thirdBlockButton = SKSpriteNode(imageNamed: "button_moveforward")
                    thirdBlockButton!.size = button_moveforward!.size
                    thirdBlockButton!.position = thirdBlockCenter!
                    addChild(thirdBlockButton!)
                    tempbutton_moveforward!.removeFromParent()
                    tempbutton_moveforward = nil
                    moves.append("forward")
                }
                else if (detailIsNearTheCenterPosition(fourthBlockCenter!, detail: tempbutton_moveforward!))
                {
                    fourthBlockButton = SKSpriteNode(imageNamed: "button_moveforward")
                    fourthBlockButton!.size = button_moveforward!.size
                    fourthBlockButton!.position = fourthBlockCenter!
                    addChild(fourthBlockButton!)
                    tempbutton_moveforward!.removeFromParent()
                    tempbutton_moveforward = nil
                    moves.append("forward")
                }
                else {
                tempbutton_moveforward?.removeFromParent()
                tempbutton_moveforward = nil
                }
            }
        }
    }
    
 
    
    func detailIsNearTheCenterPosition(centerPosition : CGPoint , detail : SKNode) ->Bool
    {
        if (detail.position.x > centerPosition.x - 10 && detail.position.x < centerPosition.x + 10 && detail.position.y > centerPosition.y - 10 && detail.position.y < centerPosition.y + 10 )
        {
            return true
        }
        else {
            return false
        }
    }
    
    func createCloneForNode(node : SKSpriteNode)
    {
        if (node.name == "moveforward")
        {
            if (tempbutton_moveforward == nil) {
                tempbutton_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
                tempbutton_moveforward!.size = button_moveforward!.size
                tempbutton_moveforward!.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
                tempbutton_moveforward!.zPosition = 1
                addChild(tempbutton_moveforward!)
        }
        }
        else if (node.name == "turn")
        {
            if (tempbutton_turn == nil) {
                tempbutton_turn = SKSpriteNode(imageNamed: "button_moveforward")
                tempbutton_turn!.size = button_moveforward!.size
                tempbutton_turn!.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
                tempbutton_turn!.zPosition = 1
                addChild(tempbutton_turn!)
        }
        
        
    }
    }
    
    
    
    
    
    
}
