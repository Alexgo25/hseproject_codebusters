//
//  RobotTrack.swift
//  Codebusters_sample
//
//  Created by Alexander on 11.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

class RobotTrack {
    
    private var track : [RobotStanding] = []
    private var currentRobotPosition : Int?
    
    func canPerformActionWithDirection(action : ActionButtonType , direction : Direction) -> Bool {
        switch action {
        case .moveForwardButton:
            return track[currentRobotPosition!].getFloorPosition().rawValue == track[getNextStanding(direction)!].getFloorPosition().rawValue
        case .jumpButton:
            return track[currentRobotPosition!].getFloorPosition() != .ground
        case .pushButton:
            return track[currentRobotPosition!].getFloorPosition().rawValue < track[getNextStanding(direction)!].getFloorPosition().rawValue
        default:
            return true
        }
    }
    
    func getNextStanding(direction: Direction) -> Int? {
        if direction == .ToLeft {
            return currentRobotPosition!--
        } else {
            return currentRobotPosition!++
        }
    }
    
    init (robotPosition : Int){
        self.currentRobotPosition = robotPosition
    }
    
    func append(robotStanding : RobotStanding) {
        self.track.append(robotStanding)
    }
    
    func setNextStanding(direction : Direction)
    {
        self.currentRobotPosition! = getNextStanding(direction)!
    }
}