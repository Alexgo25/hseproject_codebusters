//
//  GameScene.swift
//  Codebusters_sample
//
//  Created by Alexander on 28.03.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //кнопки, фон и робот
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
    
    //блоки программы
    var firstblockButton : SKSpriteNode?
    var secndBlockButton : SKSpriteNode?
    var thirdBlockButton : SKSpriteNode?
    var fourthBlockButton : SKSpriteNode?
    
    //центры блоков
    var firstBlockCenter : CGPoint?
    var secondBlockCenter : CGPoint?
    var thirdBlockCenter : CGPoint?
    var fourthBlockCenter : CGPoint?
    
    
    
    
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
        
        
        
        firstBlockCenter = CGPoint(x: size.width * 879/2048, y: size.height * 193/1536)
       
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches
        {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(touchLocation)
            
            if (touchedNode == button_moveforward ){
                if (tempbutton_moveforward == nil){
                    tempbutton_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
                    tempbutton_moveforward!.size = button_moveforward!.size
                    tempbutton_moveforward!.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
                    tempbutton_moveforward!.zPosition = 1
                    addChild(tempbutton_moveforward!)}
                
                
            }
            if (touchedNode == button_turn){
                if (tempbutton_turn == nil){
                    tempbutton_turn = SKSpriteNode(imageNamed: "button_Turn")
                    tempbutton_turn!.size = button_turn!.size
                    tempbutton_turn!.position = CGPoint(x: size.width * 560/2048, y: size.height * 218/1536)
                    tempbutton_turn!.zPosition = 1
                    addChild(tempbutton_turn!)
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
                if (detailIsNearTheCenterPosition(firstBlockCenter!, detail: tempbutton_moveforward!))
                {
                    firstblockButton = SKSpriteNode(imageNamed: "button_moveforward")
                    firstblockButton!.size = button_moveforward!.size
                    firstblockButton!.position = firstBlockCenter!
                    addChild(firstblockButton!)
                    tempbutton_moveforward!.removeFromParent()
                    tempbutton_moveforward = nil
                    
                }
                
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
            
           if (touchedNode == tempbutton_turn)
            {
                tempbutton_turn?.removeFromParent()
                tempbutton_turn = nil
            }
            if (touchedNode == tempbutton_moveforward)
            {
                tempbutton_moveforward?.removeFromParent()
                tempbutton_moveforward = nil
            }
        }
    }
    
    
    
    
    
    func moveRobotToStart()
    {
        Robot?.position = CGPoint(x: size.width * 515/2048, y: size.height * 1052/1536)
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
    
    
    
    
}
