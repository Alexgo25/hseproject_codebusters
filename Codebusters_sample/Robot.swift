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
    
    func moveforward()
    {
        self.position.x += CGFloat(236 / 225 * size.width)
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
    
    
    
}
