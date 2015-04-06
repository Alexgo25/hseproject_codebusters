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
    
    func moveForward() {
        self.position.x += CGFloat(236 / 225 * size.width)
    }
    
    func turn() {
        self.xScale = self.xScale * (-1)
    }
    
    func jump() {
        
    }
    
    func push() {
        
    }
    
    func moveToStart() {
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
        moveToStart()
    }
}
