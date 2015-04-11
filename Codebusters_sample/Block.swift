//
//  Block.swift
//  Codebusters_sample
//
//  Created by Alexander on 08.04.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit



class Block {
    
    var blockType : BlockFloor?
    var position : CGPoint?
    var previousBlock : Block? = nil
    var nextBlock : Block? = nil
    
    init(blockType : BlockFloor , position : CGPoint)
    {
        self.blockType? = blockType
        self.position? = position
    }
    
    func getBlockType() -> BlockType {
        return self.blockType!
    }
    
    func getBlockPosition() ->CGPoint {
        return self.position!
    }
    
    func linkNextBlock(block : Block) {
        self.nextBlock = block
        block.previousBlock = self
    }
    
    func canPerformActionFromButtonTypeWithState(actionType : ActionButtonType, state : RobotState) -> Bool {
        return Bool()
    }
    
}