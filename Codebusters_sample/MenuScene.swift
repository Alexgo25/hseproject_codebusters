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
    
    var menuBackground: MenuBackground?
    
    override init() {
        menuBackground = MenuBackground()
        super.init(size: CGSize(width: 1024, height: 768))
        addChild(menuBackground!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        //menuBackground!.updateDetails()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    
    
}
