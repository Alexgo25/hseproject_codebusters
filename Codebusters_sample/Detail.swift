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
    RAM = "RAM"
}

class Detail: SKSpriteNode {
    init(detailType: DetailType, trackPosition: Int, floorPosition: FloorPosition) {
        let texture = SKTexture(imageNamed: detailType.rawValue)
        super.init(texture: texture, color: UIColor(), size: texture.size())
        position = getCGPointOfPosition(trackPosition, floorPosition)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideDetail() -> SKAction {
        var fadeOut = SKAction.fadeOutWithDuration(0.5)
        var remove = SKAction.removeFromParent()
        var sequence = SKAction.sequence([fadeOut, remove])
        return SKAction.runBlock( { self.runAction(sequence) } )
    }
}
