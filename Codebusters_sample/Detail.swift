//
//  Detail.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 21.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import SpriteKit
import UIKit

enum DetailType: String {
    case Battery = "Battery",
    CPU = "CPU",
    Fan = "Fan",
    HardDrive = "HardDrive",
    RAM1 = "RAM1",
    RAM2 = "RAM2"
}

class Detail: SKSpriteNode {
    private var detailType: DetailType
    private var trackPosition: Int
    private var floorPosition: FloorPosition
    
    init(detailType: DetailType, trackPosition: Int, floorPosition: FloorPosition) {
        let texture = SKTexture(imageNamed: "\(detailType.rawValue)__")
        self.detailType = detailType
        self.trackPosition = trackPosition
        self.floorPosition = floorPosition
        super.init(texture: texture, color: UIColor(), size: texture.size())
        position = getCGPointOfPosition(trackPosition, floorPosition)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideDetail() -> SKAction {
        /*let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("", forKey: "\(detailType.rawValue)")*/
        
        var fadeOut = SKAction.fadeOutWithDuration(0.2)
        var remove = SKAction.removeFromParent()
        var sequence = SKAction.sequence([fadeOut, remove])
        return SKAction.runBlock( {
            self.runAction(sequence)
            self.runAction(SKAction.playSoundFileNamed("DetailAchievement.wav", waitForCompletion: false))
        } )
        
        
    }
    
    func getDetailType() -> DetailType {
        return detailType
    }
    
    func getTrackPosition() -> Int {
        return trackPosition
    }
    
    func getFloorPosition() -> FloorPosition {
        return floorPosition
    }
}
