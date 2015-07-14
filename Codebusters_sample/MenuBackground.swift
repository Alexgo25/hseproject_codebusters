//
//  MenuBackground.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 27.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//
/*
import UIKit
import SpriteKit

class MenuBackground: SKSpriteNode {

    //var button_Pause: SKSpriteNode = SKSpriteNode(imageNamed: "button_Pause")
    /*static var details: [DetailCell] = [
        DetailCell(detailType: .CPU, cellState: .Placed),
        DetailCell(detailType: .HardDrive, cellState: .Placed),
        DetailCell(detailType: .RAM1, cellState: .Placed),
        DetailCell(detailType: .RAM2, cellState: .Placed),
        DetailCell(detailType: .Battery, cellState: .Placed),
        DetailCell(detailType: .Fan, cellState: .Placed)
    ]*/
    
    //static var currentLevel = 0

    init() {
    //    var texture = SKTexture(imageNamed: "menuBackground")

    //    button_Pause.position = Constants.Button_PausePosition
    //    super.init(texture: texture, color: UIColor(), size: texture.size())
    //    anchorPoint = CGPoint.zeroPoint
    //    userInteractionEnabled = true

        /*let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject("Active", forKey: "CPU")
        defaults.setObject("NonActive", forKey: "HardDrive")
        defaults.setObject("NonActive", forKey: "RAM1")
        defaults.setObject("NonActive", forKey: "RAM2")
        defaults.setObject("NonActive", forKey: "Battery")
        defaults.setObject("NonActive", forKey: "Fan")*/
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
}*/
