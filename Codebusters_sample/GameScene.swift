//
//  GameScene.swift
//  Codebusters_sample
//
//  Created by Alexander on 28.03.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit

enum NodeType: UInt32 {
    case ActionButton = 1,
    ActionCell = 2,
    Touch = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKSpriteNode?
    var RAM: SKSpriteNode?
    
    var selectedNode: SKNode?
    
    func defaultScene() {
        RAM = SKSpriteNode(imageNamed: "RAM")
        RAM!.size = CGSize(width: size.width * 238/2048, height: size.height * 81/1536)
        RAM!.position = CGPoint(x: size.width * 1163/2048, y: size.height * 753/1536)
        addChild(RAM!)
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        background = Background(blocksPattern: [.first, .second, .first, .first, .first], robotPosition: 1, detailType: .RAM, detailPosition: 5, detailFloorPosition: .first)
        addChild(background!)
    }
    
    /*func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case NodeType.ActionButton.rawValue | NodeType.Touch.rawValue:
            var action = contact.bodyB.node as! ActionButton?
            action!.showLabel()
        default:
            return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case NodeType.ActionButton.rawValue | NodeType.ActionCell.rawValue:
            var action = contact.bodyB.node as! ActionButton?
            action!.hideLabel()
        default:
            return
        }
    }*/
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    /*override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            
            var touchedNode = nodeAtPoint(touchLocation)
            var previousLocation = touch.previousLocationInNode(self)
            
            var translation = CGPointMake(touchLocation.x - previousLocation.x, touchLocation.y - previousLocation.y)
            
            panForTranslation(translation)
        }
    }
    
    func panForTranslation(translation: CGPoint) {
        var position = selectedNode!.position
        if (selectedNode?.isKindOfClass(ActionButton) != nil) {
            selectedNode!.position = CGPoint(x: selectedNode!.position.x + translation.x, y: selectedNode!.position.y + translation.y)
        }
    }*/
}
