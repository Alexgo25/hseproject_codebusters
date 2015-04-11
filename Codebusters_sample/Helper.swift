//
//  Helper.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 06.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

enum ActionButtonType: String {
    case moveForwardButton = "button_MoveForward",
    turnButton = "button_Turn",
    pushButton = "button_Push",
    jumpButton = "button_Jump",
    none = "none"
}

enum BlockFloor : Int{
    case Normal = 1,
    None = 0,
    FirstFloor = 2
}

enum RobotState  {
    case TurnedLeft,
    TurnedRight
    
}

struct Constants {
    static let ScreenSize = UIScreen.mainScreen().bounds
    static let ActionButtonSize = CGSize(width: ScreenSize.width * 119/2048, height: ScreenSize.height * 118/1536)
    static let Button_MoveForwardPosition = CGPoint(x: ScreenSize.width * 362/2048, y: ScreenSize.height * 218/1536)
    static let Button_TurnPosition = CGPoint(x: ScreenSize.width * 560/2048, y: ScreenSize.height * 218/1536)
    static let Button_StartPosition = CGPoint(x: ScreenSize.width * 1660/2048, y: ScreenSize.height * 194/1536)
    static let Button_PausePosition = CGPoint(x: ScreenSize.width * 128 / 2048, y: ScreenSize.height * 1387 / 1536)
    static let Button_TipsPosition = CGPoint(x: ScreenSize.width * 128/2048, y: ScreenSize.height * 1257/1536)
    static let Robot_StartPosition = CGPoint(x: ScreenSize.width * 515/2048, y: ScreenSize.height * 1052/1536)
    static let Robot_Size = CGSize(width: ScreenSize.width * 225/2048, height: ScreenSize.height * 356/1536)
    static let FirstBlockPosition = CGPoint(x: ScreenSize.width * 515/2048, y: ScreenSize.height * 1052/1536)
    static let SecondBlockPosition = CGPoint(x: ScreenSize.width * 751/2048, y: ScreenSize.height * 1052/1536)
    static let ThirdBlockPosition = CGPoint(x: ScreenSize.width * 987/2048, y: ScreenSize.height * 1052/1536)
    static let FourthBlockPosition = CGPoint(x: ScreenSize.width * 1223/2048, y: ScreenSize.height * 1052/1536)
}



func MoveForwardAnimationTextures() -> [SKTexture] {
    var textures: [SKTexture] = []
    for var i = 1; i <= 8; i++ {
        var imageString = "MoveForward\(i)"
        textures.append(SKTexture(imageNamed: imageString))
    }
    return textures
}

func compareBlockTypeWithActionType(blockType : BlockType , actionType : ActionButtonType) -> Bool
{
    return Bool()
}















