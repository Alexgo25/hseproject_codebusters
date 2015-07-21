//
//  Helper.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 06.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

enum ActionType: String {
    case move = "Move",
    turn = "Turn",
    push = "Push",
    jump = "Jump",
    none = "none"
}

enum FloorPosition: Int {
    case ground = 0,
    first = 1,
    second = 2
}

enum DetailCellState: String {
    case NonActive = "_NonActive",
    Active = "_Active",
    Placed = ""
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Robot: UInt32 = 0b1  // 1
    static let Detail: UInt32 = 0b10  // 2
}

struct MenuConstants {
    static let CPUPosition = CGPoint(x: 1510, y: 813)
    static let HardDrivePosition = CGPoint(x: 1070, y: 730)
    static let RAM2Position = CGPoint(x: 1649, y: 664)
    static let RAM1Position = CGPoint(x: 1351, y: 664)
    static let BatteryPosition = CGPoint(x: 1194, y: 1000)
    static let FanPosition = CGPoint(x: 1669, y: 992)
}

func getDetailCellPosition(detailType: DetailType) -> CGPoint {
    switch detailType {
    case .Battery:
        return MenuConstants.BatteryPosition
    case .HardDrive:
        return MenuConstants.HardDrivePosition
    case .RAM1:
        return MenuConstants.RAM1Position
    case .RAM2:
        return MenuConstants.RAM2Position
    case .CPU:
        return MenuConstants.CPUPosition
    default:
        return MenuConstants.FanPosition
    }
}

struct Constants {
    static let ScreenSize = UIScreen.mainScreen().bounds
    static let ActionCellSize = CGSize(width: 239, height: 66)
    static let ActionCellFirstPosition = CGPoint(x: 1748, y: 1238)
    static let Button_MovePosition = CGPoint(x: -168, y: 156)    //(x: 166, y: 915)
    static let Button_TurnPosition = CGPoint(x: -61, y: 224)            //(x: 481, y: 915)
    static let Button_PushPosition = CGPoint(x: 94, y: 224)             //(x: 384, y: 984)
    static let Button_JumpPosition = CGPoint(x: 205, y: 156)            //(x: 263, y: 984)
    //static let Button_StartPosition = CGPoint(x: 1742, y: 213)
    static let Button_StartPosition = CGPoint(x: 1751, y: 153)
    static let Button_ClearPosition = CGPoint(x: 1875, y: 323)
    static let Button_DebugPosition = CGPoint(x: 1628, y: 323)
    static let Button_PausePosition = CGPoint(x:102, y: 1436)
    static let Button_TipsPosition = CGPoint(x: 102, y: 1316)
    static let Button_ResetPosition = CGPoint(x: 306, y: 730)
    static let Button_ContinuePosition = CGPoint(x: 306, y: 882)
    static let Robot_FirstBlockPosition = CGPoint(x: 315, y: 760)
    static let Block_FirstPosition = CGPoint(x: 125, y: 523)
    static let BlockFace_Size = CGSize(width: 202, height: 199)
    static let GroundFloor = CGFloat(561)
    static let FirstFloor = CGFloat(760)
    static let SecondFloor = CGFloat(959)
}

func getXBlockPosition(trackPosition: Int) -> CGFloat {
    return Constants.Block_FirstPosition.x + CGFloat(trackPosition) * Constants.BlockFace_Size.width
}

func getYBlockPosition(floorPosition: FloorPosition) -> CGFloat {
    return Constants.Block_FirstPosition.y + CGFloat(floorPosition.rawValue - 1) * Constants.BlockFace_Size.height
}

func getGameButtonPosition(type: GameButtonType) -> CGPoint {
    switch type {
    case .Clear:
        return Constants.Button_ClearPosition
    case .Debug:
        return Constants.Button_DebugPosition
    case .Pause:
        return Constants.Button_PausePosition
    case .Start:
        return Constants.Button_StartPosition
    case .Tip:
        return Constants.Button_TipsPosition
    }
}

func getActionButtonPosition(actionType: ActionType) -> CGPoint {
    switch actionType {
    case .move:
        return Constants.Button_MovePosition
    case .turn:
        return Constants.Button_TurnPosition
    case .push:
        return Constants.Button_PushPosition
    default:
        return Constants.Button_JumpPosition
    }
}

func getCGPointOfPosition(trackPosition: Int, floorPosition: FloorPosition) -> CGPoint {
    return CGPoint(x: getXRobotPosition(trackPosition), y: getYRobotPosition(floorPosition))
}

func getXRobotPosition(trackPosition: Int) -> CGFloat {
    return Constants.Robot_FirstBlockPosition.x + CGFloat(trackPosition - 1) * Constants.BlockFace_Size.width
}

func getYRobotPosition(floorPosition: FloorPosition) -> CGFloat {
    switch floorPosition {
    case .ground:
        return Constants.GroundFloor
    case .first:
        return Constants.FirstFloor
    case .second:
        return Constants.SecondFloor
    }
}

func getNextBlockPosition(blockPosition: CGPoint) -> CGPoint {
    return CGPoint(x: blockPosition.x + UIImage(named: "block")!.size.width, y: blockPosition.y)
}

func MoveAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i <= 8; i++ {
            textures.append(SKTexture(imageNamed: "Move\(i)_ToRight"))
        }
    } else {
        for var i = 1; i <= 8; i++ {
            textures.append(SKTexture(imageNamed: "Move\(i)_ToLeft"))
        }
    }
    
    return textures
}

func JumpAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i <= 8; i++ {
            textures.append(SKTexture(imageNamed: "Jump\(i)_ToRight"))
        }
    } else {
        for var i = 1; i <= 8; i++ {
            textures.append(SKTexture(imageNamed: "Jump\(i)_ToLeft"))
        }
    }
    
    return textures
}

func PushAnimationTextures_FirstPart(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i <= 5; i++ {
            textures.append(SKTexture(imageNamed: "Push\(i)_ToRight"))
        }
    } else {
        for var i = 1; i <= 5; i++ {
            textures.append(SKTexture(imageNamed: "Push\(i)_ToLeft"))
        }
    }
    
    return textures
}

func PushAnimationTextures_SecondPart(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 6; i <= 9; i++ {
            textures.append(SKTexture(imageNamed: "Push\(i)_ToRight"))
        }
    } else {
        for var i = 6; i <= 9; i++ {
            textures.append(SKTexture(imageNamed: "Push\(i)_ToLeft"))
        }
    }
    
    return textures
}

func TurnAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 7; i >= 1; i-- {
            textures.append(SKTexture(imageNamed: "Turn\(i)"))
        }
    } else {
        for var i = 1; i <= 7; i++ {
            textures.append(SKTexture(imageNamed: "Turn\(i)"))
        }
    }
    
    return textures
}

func TurnToFrontAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i < 6; i++ {
            textures.append(SKTexture(imageNamed: "TurnToFront\(i)_ToRight"))
        }
    } else {
        for var i = 1; i < 6; i++ {
            textures.append(SKTexture(imageNamed: "TurnToFront\(i)_ToLeft"))
        }
    }
    
    return textures
}

func TurnFromFrontAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 5; i > 0; i-- {
            textures.append(SKTexture(imageNamed: "TurnToFront\(i)_ToRight"))
        }
    } else {
        for var i = 5; i > 0; i-- {
            textures.append(SKTexture(imageNamed: "TurnToFront\(i)_ToRight"))
        }
    }
    
    return textures
}

func MistakeAnimationTextures() -> [SKTexture] {
    var textures: [SKTexture] = []
    
    for var i = 1; i < 10; i++ {
        textures.append(SKTexture(imageNamed: "Mistake\(i)"))
    }
    
    return textures
}

func getLevelsData() -> NSDictionary {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0] as? String
    let path = documentsDirectory?.stringByAppendingPathComponent("Levels.plist")
    let config = NSMutableDictionary(contentsOfFile: path!)!
    return config
}

func getLevelsDataPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0] as? String
    let path = documentsDirectory?.stringByAppendingPathComponent("Levels.plist")
    return path!
}