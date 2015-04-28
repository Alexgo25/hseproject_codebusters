//
//  MenuBackground.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 27.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import UIKit
import SpriteKit

enum DetailCellState: String {
    case NonActive = "_NonActive",
    Active = "_Active",
    Placed = "_"
}

class MenuBackground: SKSpriteNode {

    var button_Pause: SKSpriteNode = SKSpriteNode(imageNamed: "button_Pause")
    static var details: [DetailCell] =
    [
        DetailCell(detailType: .CPU, cellState: .Placed),
        DetailCell(detailType: .HardDrive, cellState: .Placed),
        DetailCell(detailType: .RAM1, cellState: .Placed),
        DetailCell(detailType: .RAM2, cellState: .Placed),
        DetailCell(detailType: .Battery, cellState: .Placed),
        DetailCell(detailType: .Fan, cellState: .Placed)
    ]
    
    static var currentLevel = 0

    init() {
        var texture = SKTexture(imageNamed: "menuBackground")
        
        super.init(texture: texture, color: UIColor(), size: texture.size())
        xScale = Constants.ScreenSize.width/2048
        yScale = Constants.ScreenSize.height/1536
        anchorPoint = CGPoint.zeroPoint
        userInteractionEnabled = true
        for detail in MenuBackground.details {
            detail.texture = SKTexture(imageNamed: "\(detail.getDetailType().rawValue)_\(detail.getCellState().rawValue)")
            addChild(detail)
        }
        
        /*let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject("Active", forKey: "CPU")
        defaults.setObject("NonActive", forKey: "HardDrive")
        defaults.setObject("NonActive", forKey: "RAM1")
        defaults.setObject("NonActive", forKey: "RAM2")
        defaults.setObject("NonActive", forKey: "Battery")
        defaults.setObject("NonActive", forKey: "Fan")*/
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDetails() {
        for var i = 0; i < MenuBackground.currentLevel; i++ {
            MenuBackground.details[i].setCellState(.Placed)
        }
        
        MenuBackground.details[MenuBackground.currentLevel].setCellState(.Active)
        for var i = MenuBackground.currentLevel + 1; i < 6; i++ {
            MenuBackground.details[i].setCellState(.NonActive)
        }
        
        
        /*
        for detail in MenuBackground.details {
            detail.texture = SKTexture(imageNamed: "\(detail.getDetailType().rawValue)_\(detail.getCellState().rawValue)")
            addChild(detail)
        }*/

        
        /*let defaults = NSUserDefaults.standardUserDefaults()
        for detail in MenuBackground.details {
            var cellStateString = defaults.objectForKey(detail.getDetailType().rawValue) as! String
            if let cellState = DetailCellState(rawValue: cellStateString) {
                detail.setCellState(cellState)
                println("\(cellState.rawValue)")
            }
        }*/
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchesSet = touches as! Set<UITouch>
        for touch in touchesSet {
            var touchLocation = touch.locationInNode(self)
            var node = nodeAtPoint(touchLocation)
            if node.isMemberOfClass(DetailCell) {
                var cell = node as! DetailCell
                switch cell.getCellState() {
                case .Active:
                    self.scene!.view!.presentScene(getLevel(cell.getDetailType()))
                case .NonActive:
                    return
                case .Placed:
                    self.scene!.view!.presentScene(getLevel(cell.getDetailType()))
                }
            }
        }
    }
}
