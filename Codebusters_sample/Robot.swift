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
        position = Constants.Robot_StartPosition
    }
    
    func getStartPosition() -> CGPoint {
        return Constants.Robot_StartPosition
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override convenience init() {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "robot")
        let size = Constants.Robot_Size
        self.init(texture: texture, color: color, size: size)
        moveToStart()
    }
}
