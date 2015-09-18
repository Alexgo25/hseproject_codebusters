//
//  DetailCell.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 28.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

enum DetailCellState: String {
    case NonActive = "NonActive",
    Active = "Active",
    Placed = ""
}

class DetailCell: SKSpriteNode {

    private var cellState: DetailCellState
    private var detailType: DetailType
    private var atlas = SKTextureAtlas(named: "DetailCells")
    
    init(detailType: DetailType, cellState: DetailCellState) {
        var texture = SKTexture()
        
        switch cellState {
        case .Active, .NonActive:
            atlas = SKTextureAtlas(named: "DetailCells")
            texture = atlas.textureNamed("DetailCell_\(detailType.rawValue)_\(cellState.rawValue)")
        case .Placed:
            atlas = SKTextureAtlas(named: "Details")
            texture = atlas.textureNamed("Detail_\(detailType.rawValue)")
        }
        
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
        
        switch cellState {
        case .Active, .NonActive:
            atlas = SKTextureAtlas(named: "DetailCells")
            texture = atlas.textureNamed("DetailCell_\(detailType.rawValue)_\(cellState.rawValue)")
        case .Placed:
            atlas = SKTextureAtlas(named: "Details")
            texture = atlas.textureNamed("Detail_\(detailType.rawValue)")
        }
    }
    
    func getDetailType() -> DetailType {
        return detailType
    }
}

