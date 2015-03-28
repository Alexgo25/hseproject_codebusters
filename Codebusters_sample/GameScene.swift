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
    
    override func didMoveToView(view: SKView) {
        background = SKSpriteNode(imageNamed: "background")
        background?.size = self.size
        background?.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background!)
       
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
