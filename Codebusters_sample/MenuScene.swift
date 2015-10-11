//
//  MenuScene.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 28.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "menuBackground")
    
    var details: [DetailCell] = []

    override init() {
        super.init(size: CGSize(width: 2048, height: 1536))
        background.anchorPoint = CGPointZero
        background.zPosition = -1
        addChild(background)
        userInteractionEnabled = true
    }
    
    override func didMoveToView(view: SKView) {
        if let recognizers = view.gestureRecognizers {
            view.gestureRecognizers!.removeAll(keepCapacity: false)
        }
        
        GameProgress.sharedInstance.writePropertyListFileToDevice()
        showDetails()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            
            if let cell = nodeAtPoint(touchLocation) as? DetailCell {
                switch cell.getCellState() {
                case .Active, .Placed:
                    addChild(LevelSelectionView(levelPackIndex: cell.name!.toInt()!))
                case .NonActive:
                    return
                }
            }
        }
    }
    
    func showDetails() {
        let levelPacks = GameProgress.sharedInstance.getLevelPacks()
        for levelPack in levelPacks {
            let detailTypeString = levelPack["detailType"] as! String
            let detailType = DetailType(rawValue: detailTypeString)
            
            let cellStateString = levelPack["cellState"] as! String
            let cellState = DetailCellState(rawValue: cellStateString)
            
            let detailCell = DetailCell(detailType: detailType!, cellState: cellState!, name: String(details.count))
            details.append(detailCell)
            addChild(detailCell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}