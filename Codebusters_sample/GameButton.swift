//
//  GameButton.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 21.07.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

enum GameButtonType: String {
    case Pause = "Pause",
    Tip = "Tip",
    Debug = "Debug",
    Clear = "Clear",
    Start = "Start"
}

class GameButton: SKSpriteNode {
    
    private var gameButtonType: GameButtonType
    var isTouched = false
    
    init(type: GameButtonType) {
        let texture = SKTexture(imageNamed: "button_\(type.rawValue)")
        gameButtonType = type
        super.init(texture: texture, color: UIColor(), size: texture.size())
        position = getGameButtonPosition(type)
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func touched() {
        texture = SKTexture(imageNamed: "button_\(gameButtonType.rawValue)_Pressed")
        size = texture!.size()
        isTouched = true
    }
    
    func resetTexture() {
        texture = SKTexture(imageNamed: "button_\(gameButtonType.rawValue)")
        size = texture!.size()
        isTouched = false
    }
    
    func getActionType() -> GameButtonType {
        return gameButtonType
    }
}
