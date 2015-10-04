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
        GameProgress.sharedInstance.writePropertyListFileToDevice()

        showDetails()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            let touchLocation = touch.locationInNode(self)
            if let cell = nodeAtPoint(touchLocation) as? DetailCell {
                switch cell.getCellState() {
                case .Active, .Placed:
                    for var i = 0; i < details.count; i++ {
                        if details[i].getDetailType() == cell.getDetailType() {
                            GameProgress.sharedInstance.setLevel(i, level: 0)
                            GameProgress.sharedInstance.newGame(view!)
                           // view!.presentScene(LevelScene(size: size, levelPack: i, level: 0), transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
                            break
                        }
                    }
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
            
            let detailCell = DetailCell(detailType: detailType!, cellState: cellState!)
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