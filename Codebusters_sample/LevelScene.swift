//
//  LevelScene.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 28.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class LevelScene: SKScene, SKPhysicsContactDelegate {

    var levelBackground: LevelBackground
    
    init(blocksPattern: [FloorPosition], robotPosition: Int, detailType: DetailType, detailPosition: Int, detailFloorPosition: FloorPosition) {
        
        levelBackground = LevelBackground(blocksPattern: blocksPattern, robotPosition: robotPosition, detailType: detailType, detailPosition: detailPosition, detailFloorPosition: detailFloorPosition)
        
        super.init(size: CGSize(width: 1024, height: 768))
        addChild(levelBackground)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        levelBackground.revertChanges()
       // levelBackground = LevelBackground(blocksPattern: [.first, .second, .first, .first, .first], robotPosition: 1, detailType: .CPU, detailPosition: 5, detailFloorPosition: .first)
        //addChild(levelBackground!)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
