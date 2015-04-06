//
//  Helper.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 06.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit

enum ActionButtonType: String {
    case moveForwardButton = "button_MoveForward",
    turnButton = "button_Turn",
    pushButton = "button_Push",
    jumpButton = "button_Jump",
    none = "none"
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
}



