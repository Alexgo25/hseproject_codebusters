//
//  DetailCell.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 28.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class DetailCell: SKSpriteNode {

    private var cellState: DetailCellState
    private var detailType: DetailType
    
    init(detailType: DetailType, cellState: DetailCellState) {
        var texture = SKTexture(imageNamed: "\(detailType.rawValue)_\(cellState.rawValue)")
        self.cellState = cellState
        self.detailType = detailType
        super.init(texture: texture, color: UIColor(), size: texture.size())
        
        position = getDetailCellPosition(detailType)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCellState() -> DetailCellState {
        return cellState
    }
    
    func setCellState(cellState: DetailCellState) {
        self.cellState = cellState
        self.texture = SKTexture(imageNamed: "\(detailType.rawValue)_\(cellState.rawValue)")
        println("\(detailType.rawValue)_\(cellState.rawValue)")
        self.size = texture!.size()
    }
    
    func getDetailType() -> DetailType {
        return detailType
    }
}

