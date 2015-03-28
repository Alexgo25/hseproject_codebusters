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
    
    override func didMoveToView(view: SKView) {
        background = SKSpriteNode(imageNamed: "background")
        background?.size = self.size
        background?.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background!)
        
        button_pause = SKSpriteNode(imageNamed: "button_Paused")
        button_pause?.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_pause?.position = CGPoint(x: size.width * 120 / 2048, y: size.height * 1420 / 1536)
        addChild(button_pause!)
        
        button_tips = SKSpriteNode(imageNamed: "button_Tip")
        button_tips?.size = CGSize(width: size.width * 110/2048, height: size.height * 110/1536)
        button_tips?.position = CGPoint(x: size.width * 120/2048, y: size.height * 1300/1536)
        addChild(button_tips!)
        
        button_moveforward = SKSpriteNode(imageNamed: "button_moveforward")
        button_moveforward?.size = CGSize(width: size.width * 119/2048, height: size.height * 118/1536)
        button_moveforward?.position = CGPoint(x: size.width * 362/2048, y: size.height * 218/1536)
        addChild(button_moveforward!)
        
        button_turn = SKSpriteNode(imageNamed: "button_Turn")
        button_turn?.size = CGSize(width: size.width * 119/2048, height: size.height * 118/1536)
        button_turn?.position = CGPoint(x: size.width * 560/2048, y: size.height * 218/1536)
        addChild(button_turn!)
        
        
        
       
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
