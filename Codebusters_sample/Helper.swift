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
    case moveForward = "button_MoveForward",
    turn = "button_Turn",
    push = "button_Push",
    jump = "button_Jump",
    none = "none"
}

enum FloorPosition: Int {
    case ground = 0,
    first = 1,
    second = 2
}



struct Constants {
    static let ScreenSize = UIScreen.mainScreen().bounds
    static let ActionButtonSize = CGSize(width: ScreenSize.width * 119/2048, height: ScreenSize.height * 118/1536)
    static let Button_MoveForwardPosition = CGPoint(x: ScreenSize.width * 362/2048, y: ScreenSize.height * 218/1536)
    static let Button_TurnPosition = CGPoint(x: ScreenSize.width * 560/2048, y: ScreenSize.height * 218/1536)
    static let Button_StartPosition = CGPoint(x: ScreenSize.width * 1660/2048, y: ScreenSize.height * 194/1536)
    static let Button_PausePosition = CGPoint(x: ScreenSize.width * 128/2048, y: ScreenSize.height * 1387/1536)
    static let Button_TipsPosition = CGPoint(x: ScreenSize.width * 128/2048, y: ScreenSize.height * 1257/1536)
    static let Robot_StartPosition = CGPoint(x: ScreenSize.width * 515/2048, y: ScreenSize.height * 1052/1536)
    static let Robot_Size = CGSize(width: ScreenSize.width * 225/2048, height: ScreenSize.height * 356/1536)
    static let GroundFloor = ScreenSize.height * 934/1536
    static let FirstFloor = ScreenSize.height * 1052/1536
    static let SecondFloor = ScreenSize.height * 1170/1536
}

func getYPosition(floorPosition: FloorPosition) -> CGFloat {
    var y: CGFloat
    switch floorPosition {
    case .ground:
        y = Constants.GroundFloor
    case .first:
        y = Constants.FirstFloor
    case .second:
        y = Constants.SecondFloor
    }
    return y
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


