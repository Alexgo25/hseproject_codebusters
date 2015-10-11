//
//  LevelSelectionView.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 10.10.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class LevelSelectionView: SKSpriteNode {
    
    let levelPackIndex: Int
    
    init(levelPackIndex: Int) {
        
        let texture = SKTexture(imageNamed: "LevelSelectionView_Background")
        self.levelPackIndex = levelPackIndex
        
        super.init(texture: texture, color: SKColor(), size: texture.size())
        
        let levels = GameProgress.sharedInstance.getLevelPackData(levelPackIndex)
        
        Battery.count = 0
        
        for levelResult in levels {
            if let batteryType = Type(rawValue: levelResult) {
                addChild(Battery(type: batteryType))
            }
        }
        
        anchorPoint = CGPointZero
        zPosition = 3000
        userInteractionEnabled = true
        
        show()
    }
    
    func show() {
        alpha = 0
        let appear = SKAction.fadeInWithDuration(0.2)
        runAction(appear)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            if let battery = nodeAtPoint(touchLocation) as? Battery {
                if battery.type.rawValue >= 0 {
                    GameProgress.sharedInstance.setLevel(levelPackIndex, level: battery.name!.toInt()!)
                    GameProgress.sharedInstance.newGame(scene!.view!)
                }
            } else {
                runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.2), SKAction.removeFromParent()]))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal enum Type: Int {
    case Excellent = 3,
    Good = 2,
    Bad = 1,
    Opened = 0,
    Closed = -1
}

internal class Battery: SKSpriteNode {

    static let firstPositionFirstRow = CGPoint(x: 711.5, y: 842)
    static let secondPositionFirstRow = CGPoint(x: 871.5, y: 562)
    static var count: CGFloat = 0
    
    private let type: Type
    
    init(type: Type) {
        self.type = type
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize())

        name = String(Int(Battery.count))
        position = getNextPosition()
        Battery.count++
        zPosition = 1003
        
        var battery = SKSpriteNode(imageNamed: "battery_\(type.rawValue)")
        
        if type.rawValue < 0 {
            battery = SKSpriteNode(imageNamed: "battery_0")
        }
        
        battery.zPosition = -1002
        
        if type.rawValue > 0 {
            battery.setScale(1/2.78)
        }
        
        addChild(battery)
        
        switch type {
        case .Excellent, .Good, .Bad:
            let number = SKSpriteNode(imageNamed: "nonActive")
            number.zPosition = -1002
            number.addChild(createLabel(String(Int(Battery.count)), SKColor(red: 255/255.0, green: 251/255.0, blue: 233/255.0, alpha: 1), 36, CGPointZero))
            number.position.y = 114
            addChild(number)
        case .Opened:
            let number = SKSpriteNode(imageNamed: "active")
            number.zPosition = -1002
            number.addChild(createLabel(String(Int(Battery.count)), SKColor(red: 255/255.0, green: 251/255.0, blue: 233/255.0, alpha: 1), 36, CGPointZero))
            number.position.y = 114
            addChild(number)
        
        case .Closed:
            let number = SKSpriteNode(imageNamed: "nonActive")
            number.alpha = 0.5
            number.zPosition = -1002
            number.addChild(createLabel(String(Int(Battery.count)), SKColor(red: 255/255.0, green: 251/255.0, blue: 233/255.0, alpha: 1), 36, CGPointZero))
            number.position.y = 114
            addChild(number)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNextPosition() -> CGPoint {
        let dx: CGFloat = 322
        
        if Battery.count < 3 {
            return CGPoint(x: Battery.firstPositionFirstRow.x + dx * (Battery.count), y: Battery.firstPositionFirstRow.y)
        } else {
            return CGPoint(x: Battery.secondPositionFirstRow.x + dx * (Battery.count - 3), y: Battery.secondPositionFirstRow.y)
        }
    }
}
