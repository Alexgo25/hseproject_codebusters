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
    
    private var floorPosition: FloorPosition
    var blocks: [Block] = []
    private var trackPosition: Int
    
    func getFloorPosition() -> FloorPosition {
        return self.floorPosition
    }
    
    func setFloorPosition(floorPosition: FloorPosition) {
        self.floorPosition = floorPosition
    }
    
    init (trackPosition: Int, floorPosition: FloorPosition) {
        self.floorPosition = floorPosition
        self.trackPosition = trackPosition
        for var i = 1; i <= floorPosition.rawValue; i++ {
            blocks.append(Block(trackPosition: trackPosition, floorPosition: i))
        }
    }
}
