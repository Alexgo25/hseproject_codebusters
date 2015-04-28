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
    case moveForward = "MoveForward",
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

struct LevelPatterns {
    static let CPU: [FloorPosition] = [.first, .first, .first, .first, .first]
    static let HardDrive: [FloorPosition] = [.first, .first, .first, .first, .first]
    static let RAM1: [FloorPosition] = [.first, .first, .first, .first, .second]
    static let RAM2: [FloorPosition] = [.first, .first, .second, .ground, .first]
    static let Battery: [FloorPosition] = [.first, .ground, .second, .first, .first]
    static let Fan: [FloorPosition] = [.first, .first, .second, .first, .first]
}

struct Levels {
    static let CPU: LevelScene = LevelScene(blocksPattern: LevelPatterns.CPU, robotPosition: 1, detailType: DetailType.CPU, detailPosition: 5, detailFloorPosition: FloorPosition.first)
    static let HardDrive: LevelScene = LevelScene(blocksPattern: LevelPatterns.HardDrive, robotPosition: 4, detailType: DetailType.HardDrive, detailPosition: 1, detailFloorPosition: FloorPosition.first)
    static let RAM1: LevelScene = LevelScene(blocksPattern: LevelPatterns.RAM1, robotPosition: 1, detailType: DetailType.RAM1, detailPosition: 5, detailFloorPosition: FloorPosition.second)
    static let RAM2: LevelScene = LevelScene(blocksPattern: LevelPatterns.RAM2, robotPosition: 1, detailType: DetailType.RAM2, detailPosition: 5, detailFloorPosition: FloorPosition.first)
    static let Battery: LevelScene = LevelScene(blocksPattern: LevelPatterns.Battery, robotPosition: 3, detailType: DetailType.Battery, detailPosition: 1, detailFloorPosition: FloorPosition.first)
    static let Fan: LevelScene = LevelScene(blocksPattern: LevelPatterns.Fan, robotPosition: 1, detailType: DetailType.Fan, detailPosition: 1, detailFloorPosition: FloorPosition.second)
}

func getLevel(detailType: DetailType) -> LevelScene {
    switch detailType {
    case .CPU:
        return Levels.CPU
    case .HardDrive:
        return Levels.HardDrive
    case .RAM1:
        return Levels.RAM1
    case .RAM2:
        return Levels.RAM2
    case .Battery:
        return Levels.Battery
    case .Fan:
        return Levels.Fan
    }
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
    static let Button_MoveForwardPosition = CGPoint(x: -138, y: 156)    //(x: 166, y: 915)
    static let Button_TurnPosition = CGPoint(x: -41, y: 224)            //(x: 481, y: 915)
    static let Button_PushPosition = CGPoint(x: 74, y: 224)             //(x: 384, y: 984)
    static let Button_JumpPosition = CGPoint(x: 175, y: 156)            //(x: 263, y: 984)
    static let Button_StartPosition = CGPoint(x: 1742, y: 213)
    static let Button_PausePosition = CGPoint(x:102, y: 1436)
    static let Button_TipsPosition = CGPoint(x: 102, y: 1316)
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

func getActionButtonPosition(actionType: ActionType) -> CGPoint {
    switch actionType {
    case .moveForward:
        return Constants.Button_MoveForwardPosition
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
            var imageString = "MoveForward\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 1; i <= 8; i++ {
            var imageString = "MoveBack\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    }
    
    return textures
}

func JumpAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i <= 8; i++ {
            var imageString = "Jump\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 1; i <= 8; i++ {
            var imageString = "Jump\(i)"
            var image = UIImage(named: imageString)
            
            textures.append(SKTexture(image: image!.imageRotatedByDegrees(0, flip: true)))
        }
    }
    
    return textures
}

func PushAnimationTextures_FirstPart(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i <= 5; i++ {
            var imageString = "Push\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 1; i <= 5; i++ {
            var imageString = "Push\(i)"
            var image = UIImage(named: imageString)

            textures.append(SKTexture(image: image!.imageRotatedByDegrees(0, flip: true)))
        }
    }
    
    return textures
}


func PushAnimationTextures_SecondPart(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 6; i <= 9; i++ {
            var imageString = "Push\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 6; i <= 9; i++ {
            var imageString = "Push\(i)"
            var image = UIImage(named: imageString)
            
            textures.append(SKTexture(image: image!.imageRotatedByDegrees(0, flip: true)))
        }
    }
    
    return textures
}

func TurnAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 7; i >= 1; i-- {
            var imageString = "Turn\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 1; i <= 7; i++ {
            var imageString = "Turn\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    }
    
    return textures
}

func TurnToFrontAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i < 6; i++ {
            var imageString = "TurnToFront\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 1; i < 6; i++ {
            var imageString = "TurnToFront\(i)"
            var image = UIImage(named: imageString)
            
            textures.append(SKTexture(image: image!.imageRotatedByDegrees(0, flip: true)))
        }
    }
    
    return textures
}

func TurnFromFrontAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 5; i > 0; i-- {
            var imageString = "TurnToFront\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 5; i > 0; i-- {
            var imageString = "TurnToFront\(i)"
            var image = UIImage(named: imageString)
           
            textures.append(SKTexture(image: image!.imageRotatedByDegrees(0, flip: true)))
        }
    }
    
    return textures
}

extension UIImage {
        func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}