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
    
    var background = SKSpriteNode(imageNamed: "menuBackground")
    var button_Pause: SKSpriteNode = SKSpriteNode(imageNamed: "button_Pause")
    
    var details: [DetailCell] = []

    /*static var details: [DetailCell] = [
        DetailCell(detailType: .CPU, cellState: .Active),
        DetailCell(detailType: .HardDrive, cellState: .NonActive),
        DetailCell(detailType: .RAM1, cellState: .NonActive),
        DetailCell(detailType: .RAM2, cellState: .NonActive),
        DetailCell(detailType: .Battery, cellState: .NonActive),
        DetailCell(detailType: .Fan, cellState: .NonActive)
    ]*/
    
    override init() {
        super.init(size: CGSize(width: 2048, height: 1536))
        background.anchorPoint = CGPointZero
        background.zPosition = -1
        addChild(background)
        userInteractionEnabled = true
        button_Pause.position = Constants.Button_PausePosition
    }
    
    override func didMoveToView(view: SKView) {
        let config = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Levels", ofType: "plist")!)!
        let levels = config["levels"] as! [[String : AnyObject]]
        for level in levels {
            let detailTypeString = level["detailType"] as! String
            let detailType = DetailType(rawValue: detailTypeString)
            
            let cellStateString = level["cellState"] as! String
            let cellState = DetailCellState(rawValue: cellStateString)
            
            let detailCell = DetailCell(detailType: detailType!, cellState: cellState!)
            details.append(detailCell)
            detailCell.texture = SKTexture(imageNamed: "\(detailCell.getDetailType().rawValue)\(detailCell.getCellState().rawValue)")
            detailCell.size = detailCell.texture!.size()
            addChild(detailCell)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            if node.isMemberOfClass(DetailCell) {
                var cell = node as! DetailCell
                switch cell.getCellState() {
                case .Active, .Placed:
                    for var i = 0; i < details.count; i++ {
                        if details[i].getDetailType() == cell.getDetailType() {
                            view!.presentScene(LevelScene(size: size, level: i), transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
                            break
                        }
                    }
                    
                case .NonActive:
                    return
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
