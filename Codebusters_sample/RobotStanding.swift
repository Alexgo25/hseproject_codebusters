//
//  RobotStanding.swift
//  Codebusters_sample
//
//  Created by Alexander on 11.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit



class RobotStanding {
    
    private var floorPosition : FloorPosition?
    private var xPosition : CGFloat?
    
    
    func getFloorPosition() ->FloorPosition {
        return self.floorPosition!
    }
    
    func setFloorPosition(floorPosition : FloorPosition) {
        self.floorPosition! = floorPosition
    }
    
    init (floorPosition : FloorPosition , xPosition : CGFloat)
    {
        self.floorPosition = floorPosition
        self.xPosition = xPosition
    }
    
    
}
