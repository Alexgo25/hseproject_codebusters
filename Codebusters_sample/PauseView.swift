//
//  PauseView.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 15.05.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class PauseView: SKSpriteNode {
    
    private var backgroundRightPart = SKSpriteNode(imageNamed: "pauseBackgroundRightPart")
    private var backgroundLeftPart = SKSpriteNode(imageNamed: "pauseBackgroundLeftPart")
    private var buttonReset = SKSpriteNode(imageNamed: "button_Reset")
    private var buttonContinue = SKSpriteNode(imageNamed: "button_Continue")
    
    init() {
        let texture = SKTexture(imageNamed: "pauseBackgroundRightPart")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        zPosition = 100
        alpha = 0
        anchorPoint = CGPointZero
        backgroundLeftPart.anchorPoint = CGPointZero
        backgroundLeftPart.position.x = -backgroundLeftPart.size.width
        addChild(backgroundLeftPart)
        buttonReset.position = Constants.Button_ResetPosition
        buttonContinue.position = Constants.Button_ContinuePosition
        backgroundLeftPart.addChild(buttonReset)
        backgroundLeftPart.addChild(buttonContinue)
        show()
        userInteractionEnabled = true
    }
    
    func show() {
        let appear = SKAction.fadeInWithDuration(0.15)
        let moveLeftPart = SKAction.moveByX(backgroundLeftPart.size.width, y: 0, duration: 0.15)
        backgroundLeftPart.runAction(moveLeftPart)
        let pause = SKAction.runBlock() {
            self.scene!.paused = true
        }
        runAction(SKAction.sequence([appear, pause]))
    }
    
    func hide() {
        self.scene!.paused = false
        let disappear = SKAction.fadeOutWithDuration(0.15)
        let moveLeftPart = SKAction.moveByX(-backgroundLeftPart.size.width, y: 0, duration: 0.15)
        backgroundLeftPart.runAction(moveLeftPart)
        runAction(SKAction.sequence([disappear, SKAction.removeFromParent()]))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            switch node {
            case buttonContinue:
                buttonContinue.alpha = 0.5
            case buttonReset:
                buttonReset.alpha = 0.5
            case backgroundLeftPart:
                return
            default:
                hide()
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            switch node {
            case buttonReset:
                buttonReset.alpha = 1
                self.scene!.paused = false
                let scene = self.scene as! LevelScene
                scene.newGame()
                
            case backgroundLeftPart:
                return
            case buttonContinue:
                buttonContinue.alpha = 1
                fallthrough
            default:
                hide()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
