//
//  ActionCell.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 05.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class ActionCell: SKSpriteNode {
    
    private var actionType: ActionType = .none
    static var cells: [ActionCell] = []
    static var cellsCount = 0
    static var cellsLayer = SKNode()
    private static var upperCellIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func resetCells() {
        cellsCount = 0
        cellsLayer.removeAllChildren()
        upperCellIndex = 0
        cells = []
        cellsLayer.position = CGPoint(x: 1748, y: 1238)
    }
    
    init(actionType: ActionType) {
        let texture = SKTexture(imageNamed: "cell_\(actionType.rawValue)")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        self.actionType = actionType
        position = getNextPosition()
        ActionCell.cells.append(self)
        alpha = 0
        runAction(SKAction.fadeInWithDuration(0.2))
        name = "\(ActionCell.cells.count - 1)"
    }
    
    func setActionType(actionType: ActionType) {
        self.actionType = actionType
        texture = SKTexture(imageNamed: actionType.rawValue)
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
    
    func getNextPosition() -> CGPoint {
        return CGPoint(x: 0, y: -CGFloat(ActionCell.cells.count) * texture!.size().height)
    }
    
    func highlightBegin() -> SKAction {
        return SKAction.runBlock() {
            self.texture = SKTexture(imageNamed: "cell_\(self.actionType.rawValue)_Highlighted")
        }
    }
    
    func highlightEnd() -> SKAction {
        return SKAction.runBlock() {
            self.texture = SKTexture(imageNamed: "cell_\(self.actionType.rawValue)")
        }
    }
    
    class func isArrayOfCellsFull() -> Bool {
        return cells.count > 24
    }
    
    static func appendCellWithMovingLayer() {
        if upperCellIndex + 12 == cellsCount {
            cellsLayer.runAction(SKAction.moveByX(0, y: Constants.ActionCellSize.height + 2, duration: 0.2))
            cells[upperCellIndex].runAction(SKAction.fadeOutWithDuration(0.2))
            upperCellIndex++
        } else {
            let downCellsQuantity = cellsCount - 11 - upperCellIndex
            cellsLayer.runAction(SKAction.moveByX(0, y: (Constants.ActionCellSize.height + 2) * CGFloat(downCellsQuantity + 1), duration: 0.3))
            let timePerCell = 0.3 / Double(downCellsQuantity)
            for var i = upperCellIndex + 10; i < cellsCount; i++ {
                cells[i - upperCellIndex - 10].runAction(SKAction.fadeOutWithDuration(timePerCell))
                cells[i].runAction(SKAction.fadeInWithDuration(timePerCell))
            }
            
            cells[upperCellIndex].runAction(SKAction.fadeOutWithDuration(0.2))
            upperCellIndex++
        }
    }
    
    static func canMoveCellsLayerUp() -> Bool {
        return cellsCount - upperCellIndex - 11 > 0
    }
    
    static func moveCellsLayerToTop() {
        let topCellsQuantity = upperCellIndex
        if Bool(topCellsQuantity) {
            cellsLayer.runAction(SKAction.moveByX(0, y: -(Constants.ActionCellSize.height + 2) * CGFloat(topCellsQuantity), duration: 0.5))
            let timePerCell = 0.25 / Double(topCellsQuantity)
            for var i = upperCellIndex - 1; i >= 0; i-- {
                cells[i].runAction(SKAction.fadeInWithDuration(0.5))
                cells[i + 11].runAction(SKAction.fadeOutWithDuration(0.5))
                upperCellIndex--
            }
        }
    }
    
    static func moveCellsLayerUp() {
        if canMoveCellsLayerUp() {
            cellsLayer.runAction(SKAction.moveByX(0, y: Constants.ActionCellSize.height + 2, duration: 0.25))
            cells[upperCellIndex].runAction(SKAction.fadeOutWithDuration(0.25))
            cells[upperCellIndex + 11].runAction(SKAction.fadeInWithDuration(0.25))
            
            upperCellIndex++
        }
    }
    
    static func moveCellsLayerDown() {
        if upperCellIndex > 0 {
            cellsLayer.runAction(SKAction.moveByX(0, y: -Constants.ActionCellSize.height - 2, duration: 0.25))
            cells[upperCellIndex - 1].runAction(SKAction.fadeInWithDuration(0.25))
            cells[upperCellIndex + 10].runAction(SKAction.fadeOutWithDuration(0.25))
            upperCellIndex--
        }
    }
}
