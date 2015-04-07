//
//  Robot.swift
//  Codebusters_sample
//
//  Created by Alexander on 01.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

class Robot: SKSpriteNode {
    
    var startingPosition: CGPoint?
    var robotwalkingFrames: [SKTexture] = []
    
    func moveForward()
    {
        let moveDifference =  CGFloat(236 / 225 * size.width)
        let location = CGPoint(x: self.position.x + moveDifference, y: self.position.y)
        let velocity  = self.size.width / 10
        let duration  = Double(moveDifference / velocity)
        let action = SKAction.moveTo(location, duration: duration)
        walkingForwardAnimated()
        self.runAction(action)
        //actionEnded()
    }
    
    func turn()
    {
        self.xScale = self.xScale * (-1)
    }
    
    func jump()
    {
        
    }
    
    func push()
    {
        
    }
    
    func moveToStart()
    {
        self.position = startingPosition!
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(startPosition: CGPoint, size: CGSize) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "robot")
        self.init(texture: texture, color: color, size: size)
        self.startingPosition = startPosition
        for var i = 0; i < 8 ; i++
        {
            var str = "Robot\(i+1)"
            var texture = SKTexture(imageNamed: str)
            robotwalkingFrames.append(texture)
        }
        moveToStart()
    }
    
    func walkingForwardAnimated()
    {
       self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(robotwalkingFrames, timePerFrame: 0.1)))
        
    }
    
    func actionEnded()
    {
        self.removeAllActions()
    }
    
    
}
