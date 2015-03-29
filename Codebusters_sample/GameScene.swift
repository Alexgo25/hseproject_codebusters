//
//  GameScene.swift
//  Codebusters_sample
//
//  Created by Alexander on 28.03.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var background : SKSpriteNode?
    var button_pause : SKSpriteNode?
    var button_tips : SKSpriteNode?
    var button_moveforward : SKSpriteNode?
    var button_turn : SKSpriteNode?
    var Robot : SKSpriteNode?
    var RAM : SKSpriteNode?
    var button_Start : SKSpriteNode?
    var tempbutton_moveforward : SKSpriteNode?
    var tempbutton_turn : SKSpriteNode?
    var moves: [String]?
    var pos: CGPoint?
    
    override func didMoveToView(view: SKView) {
        background = SKSpriteNode(imageNamed: "background_upd")
        background?.size = self.size
        background?.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background!)
        
        button_pause = SKSpriteNode(imageNamed: "button_Paused")
        button_pause?.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_pause?.position = CGPoint(x: size.width * 128 / 2048, y: size.height * 1387 / 1536)
        addChild(button_pause!)
        
        button_tips = SKSpriteNode(imageNamed: "button_Tip")
        button_tips?.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_tips?.position = CGPoint(x: size.width * 128/2048, y: size.height * 1257/1536)
        addChild(button_tips!)
        
        Robot = SKSpriteNode(imageNamed: "robot")
        Robot?.size = CGSize(width: size.width * 225/2048, height: size.height * 356/1536)
        moveRobotToStart()
        addChild(Robot!)
        
        RAM = SKSpriteNode(imageNamed: "RAM")
        RAM?.size = CGSize(width: size.width * 238/2048, height: size.height * 81/1536)
        RAM?.position = CGPoint(x: size.width * 1506/2048, y: size.height * 989/1536)
        addChild(RAM!)
        
        button_Start = SKSpriteNode(imageNamed: "button_Start")
        button_Start?.size = CGSize(width: size.width * 169/2048, height: size.height * 169/1536)
        button_Start?.position = CGPoint(x: size.width * 1660/2048, y: size.height * 194/1536)
        addChild(button_Start!)
        
        button_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
        button_moveforward?.size = CGSize(width: size.width * 119/2048, height: size.height * 118/1536)
        button_moveforward?.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
        addChild(button_moveforward!)
        
        button_turn = SKSpriteNode(imageNamed: "button_Turn")
        button_turn?.size = CGSize(width: size.width * 119/2048, height: size.height * 118/1536)
        button_turn?.position = CGPoint(x: size.width * 560/2048, y: size.height * 218/1536)
        addChild(button_turn!)
        
        pos = CGPoint(x: size.width * 879/2048, y: size.height * 193/1536)
        
        moves = [String]()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches
        {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            
            if (touchedNode == button_Start) {
                for var i = 0; i < moves!.count; i++ {
                //for move in moves? {
                    if (moves![i] == "forward") {
                        Robot?.position.x += CGFloat(236 * size.width / 2048)
                    }
                    
                    if (moves![i] == "turn") {
                        
                    }
                }
            }
            
            if (moves!.count < 4) {
                if (touchedNode == button_moveforward ) {
                    moves!.append("forward")
                    tempbutton_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
                    tempbutton_moveforward!.size = button_moveforward!.size
                    tempbutton_moveforward!.position = pos!
                    tempbutton_moveforward!.zPosition = 1
                    addChild(tempbutton_moveforward!)
                    pos?.x += CGFloat(138 * size.width / 2048)
                }
            
                if (touchedNode == button_turn) {
                    moves!.append("turn")
                    tempbutton_turn = SKSpriteNode(imageNamed: "button_Turn")
                    tempbutton_turn!.size = button_turn!.size
                    tempbutton_turn!.position = pos!
                    tempbutton_turn!.zPosition = 1
                    addChild(tempbutton_turn!)
                    pos?.x += CGFloat(138 * size.width / 2048)
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches
        {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            
            if (touchedNode == tempbutton_moveforward ){
                
                tempbutton_moveforward!.position = touchLocation
                
            }
            if (touchedNode == tempbutton_turn)
            {
                tempbutton_turn!.position = touchLocation
            }
            
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch : AnyObject in touches
        {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            
          /*  if (touchedNode == button_turn)
            {
                button_turn?.removeFromParent()
                button_turn = nil
            }*/
        }
    }
    
    
    
    
    
    func moveRobotToStart()
    {
        Robot?.position = CGPoint(x: size.width * 515/2048, y: size.height * 1052/1536)
    }
    
    
    
    
}
