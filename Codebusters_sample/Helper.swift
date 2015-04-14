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

struct Constants {
    static let ScreenSize = UIScreen.mainScreen().bounds
    static let ActionCellSize = CGSize(width: ScreenSize.width * 239/2048, height: ScreenSize.height * 66/1536)
    static let ActionCellFirstPosition = CGPoint(x: ScreenSize.width * 1748/2048, y: ScreenSize.height * 1241/1536)
    static let ActionButtonSize = CGSize(width: ScreenSize.width * 84/2048, height: ScreenSize.height * 84/1536)
    static let Button_MoveForwardPosition = CGPoint(x: ScreenSize.width * 166/2048, y: ScreenSize.height * 915/1536)
    static let Button_TurnPosition = CGPoint(x: ScreenSize.width * 481/2048, y: ScreenSize.height * 915/1536)
    static let Button_PushPosition = CGPoint(x: ScreenSize.width * 384/2048, y: ScreenSize.height * 984/1536)
    static let Button_JumpPosition = CGPoint(x: ScreenSize.width * 263/2048, y: ScreenSize.height * 984/1536)
    static let Button_StartPosition = CGPoint(x: ScreenSize.width * 1742/2048, y: ScreenSize.height * 213/1536)
    static let Button_PausePosition = CGPoint(x: ScreenSize.width * 102/2048, y: ScreenSize.height * 1436/1536)
    static let Button_TipsPosition = CGPoint(x: ScreenSize.width * 102/2048, y: ScreenSize.height * 1316/1536)
    static let Button_PauseSize = CGSize(width: ScreenSize.width * 94/2048, height: ScreenSize.height * 94/1536)
    static let Robot_StartPosition = CGPoint(x: ScreenSize.width * 323/2048, y: ScreenSize.height * 760/1536)
    static let Button_StartSize = CGSize(width: ScreenSize.width * 169/2048, height: ScreenSize.height * 169/1536)
    static let Robot_Size = CGSize(width: ScreenSize.width * 192/2048, height: ScreenSize.height * 304/1536)
    static let Block_Size = CGSize(width: ScreenSize.width * 316/2048, height: ScreenSize.height * 263/1536)
    static let Block_FirstPosition = CGPoint(x: ScreenSize.width * 327/2048, y: ScreenSize.height * 523/1536)
    static let BlockFace_Size = CGSize(width: ScreenSize.width * 202/2048, height: ScreenSize.height * 199/1536)
    static let GroundFloor = ScreenSize.height * 934/1536
    static let FirstFloor = ScreenSize.height * 1052/1536
    static let SecondFloor = ScreenSize.height * 1170/1536
}

func getXBlockPosition(trackPosition: Int) -> CGFloat {
    return Constants.Block_FirstPosition.x + CGFloat(trackPosition) * Constants.BlockFace_Size.width
}

func getYBlockPosition(floorPosition: FloorPosition.RawValue) -> CGFloat {
    return Constants.Block_FirstPosition.y + CGFloat(floorPosition - 1) * Constants.BlockFace_Size.height
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

func getYPosition(floorPosition: FloorPosition) -> CGFloat {
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
    return CGPoint(x: blockPosition.x + Constants.Block_Size.width, y: blockPosition.y)
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
            image = UIImage(CGImage: image?.CGImage, scale: 1.0, orientation: .Left)
            textures.append(SKTexture(image: image!))
        }
    }
    
    return textures
}

func PushAnimationTextures(direction: Direction) -> [SKTexture] {
    var textures: [SKTexture] = []
    
    if direction == .ToRight {
        for var i = 1; i <= 8; i++ {
            var imageString = "Push\(i)"
            textures.append(SKTexture(imageNamed: imageString))
        }
    } else {
        for var i = 1; i <= 8; i++ {
            var imageString = "Push\(i)"
            var image = UIImage(named: imageString)
            image = UIImage(CGImage: image?.CGImage, scale: 1.0, orientation: .Left)
            textures.append(SKTexture(image: image!))
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
            image = UIImage(CGImage: image?.CGImage, scale: 1.0, orientation: .Left)
            textures.append(SKTexture(image: image!))
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
            image = UIImage(CGImage: image?.CGImage, scale: 1.0, orientation: .Left)
            textures.append(SKTexture(image: image!))
        }
    }
    
    return textures
}

