//
//  Block.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 13.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

class Block: SKSpriteNode {
   
    private var floorPosition: FloorPosition = .ground
    private var trackPosition: Int = 0
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(trackPosition: Int, floorPosition: FloorPosition.RawValue) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "block")
        self.init(texture: texture, color: color, size: Constants.ActionButtonSize)
        size = Constants.Block_Size
        self.trackPosition = trackPosition
        position = CGPoint(x: getXBlockPosition(trackPosition), y: getYBlockPosition(floorPosition))
    }
    
    func moveToNextPosition(direction: Direction, floorPosition: FloorPosition) {
        let moveByX = SKAction.moveTo(getNextPosition(direction), duration: 1)
        let moveByY = SKAction.moveTo(getNextPosition(direction, floorPosition: floorPosition), duration: 1)
        let sequence = SKAction.sequence([moveByX, moveByY])
        runAction(sequence)
        self.floorPosition = floorPosition
        trackPosition += direction.rawValue
    }
    
    func getNextPosition(direction: Direction) -> CGPoint {
        return CGPoint(x: getXBlockPosition(trackPosition + direction.rawValue), y: getYBlockPosition(floorPosition.rawValue))
    }
    
    func getNextPosition(direction: Direction, floorPosition: FloorPosition) -> CGPoint {
        return CGPoint(x: getXBlockPosition(trackPosition + direction.rawValue), y: getYBlockPosition(floorPosition.rawValue))
    }
}