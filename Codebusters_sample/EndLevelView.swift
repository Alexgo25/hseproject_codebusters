//
//  EndLevelView.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 03.10.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class EndLevelView: SKSpriteNode {
    private let background = SKSpriteNode(imageNamed: "EndLevelView_Background")
    
    private let buttonRestart = GameButton(type: .Restart_EndLevelView)
    private let buttonNextLevel = GameButton(type: .NextLevel_EndLevelView)
    private let buttonExit = GameButton(type: .Exit_EndLevelView)
    
    private let battery = SKSpriteNode(imageNamed: "battery_3")
    
    init() {
        let texture = background.texture!
        super.init(texture: texture, color: UIColor(), size: texture.size())
        zPosition = 2000
        alpha = 0
        anchorPoint = CGPointZero
        background.anchorPoint = CGPointZero
        
        addChild(buttonRestart)
        addChild(createLabel("Заново", UIColor.blackColor(), 29, CGPoint(x: 1018.5, y: 670)))
        
        addChild(buttonNextLevel)
        addChild(createLabel("Играть дальше", UIColor.blackColor(), 29, CGPoint(x: 1363, y: 670)))
        
        addChild(buttonExit)
        addChild(createLabel("Выйти в меню", UIColor.blackColor(), 29, CGPoint(x: 672, y: 670)))
        
        battery.position = Constants.Battery_EndLevelViewPosition
        addChild(battery)
        
        show()
        userInteractionEnabled = true
    }
    
    func show() {
        let appear = SKAction.fadeInWithDuration(0.15)
        runAction(appear)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            let node = nodeAtPoint(touchLocation)
            switch node {
            case buttonNextLevel, buttonRestart, buttonExit:
                let button = node as! GameButton
                button.touched()
            default:
                return
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        let touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            let node = nodeAtPoint(touchLocation)
            switch node {
            case buttonNextLevel, buttonRestart, buttonExit:
                let button = node as! GameButton
                button.resetTexture()
            default:
                return
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            let node = nodeAtPoint(touchLocation)
            switch node {
            case buttonRestart:
                buttonRestart.resetTexture()
                GameProgress.sharedInstance.newGame(scene!.view!)
            case buttonNextLevel:
                GameProgress.sharedInstance.setNextLevel()
                GameProgress.sharedInstance.newGame(scene!.view!)
            case buttonExit:
                GameProgress.sharedInstance.goToMenu(scene!.view!)
            default:
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
