//
//  GameProgress.swift
//  Codebusters_sample
//
//  Created by Владислав Кутейников on 02.10.15.
//  Copyright (c) 2015 Kids'n'Code. All rights reserved.
//

import Foundation
import SpriteKit

public class GameProgress {
    public static let sharedInstance = GameProgress()
    
    var currentLevel = 0
    var currentLevelPack = 0
    
    func changeSetting(key: String, value: String) {
        var settings = getLevelsData()["settings"] as! [String : AnyObject]
        settings.updateValue(value, forKey: key)
        
        var config = getLevelsData()
        
        config.setValue(settings, forKey: "settings")
        config.writeToFile(getLevelsDataPath(), atomically: true)
    }
    
    func writePropertyListFileToDevice() {
        let path = getLevelsDataPath()
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path) {
            if let bundle = NSBundle.mainBundle().pathForResource("Levels", ofType: "plist") {
                fileManager.copyItemAtPath(bundle, toPath: path, error: nil)
            }
        }
        
        getSettings()
    }
    
    func getLevelPacks() -> [[String : AnyObject]] {
        let path = getLevelsDataPath()
        let config = NSDictionary(contentsOfFile: path)!
        
        let levelPacks = config["levelPacks"] as! [[String : AnyObject]]
        return levelPacks
    }

    func setLevel(levelPack: Int, level: Int) {
        currentLevel = level
        currentLevelPack = levelPack
    }
    
    func newGame(view: SKView) {
        if currentLevel != -1 {
            let scene = LevelScene(size: view.scene!.size)
            view.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.4))
        } else {
            goToMenu(view)
        }
    }

    func getLevelsData() -> NSDictionary {
        let path = getLevelsDataPath()
        let config = NSMutableDictionary(contentsOfFile: path)!
        return config
    }

    func getLevelsDataPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as? String
        let path = documentsDirectory?.stringByAppendingPathComponent("Levels.plist")
        return path!
    }
    
    func getCurrentLevelData() -> [String : AnyObject] {
        var levelPacks = getLevelPacks()
        var levelPackData = levelPacks[currentLevelPack]
        let levels = levelPackData["levels"] as! [[String : AnyObject]]
        let levelData = levels[currentLevel]
        
        if levelPackData["cellState"] as! String == DetailCellState.NonActive.rawValue {
            levelPackData.updateValue(DetailCellState.Active.rawValue, forKey: "cellState")
            levelPacks[currentLevelPack] = levelPackData

            writeToPropertyListFile(levelPacks)
        }

        return levelData
    }
    
    func writeToPropertyListFile(levelPacks: [[String : AnyObject]]) {
        var config = getLevelsData()
        
        config.setValue(levelPacks, forKey: "levelPacks")
        config.writeToFile(getLevelsDataPath(), atomically: true)
    }

    func setNextLevel() {
        let levelPackData = getLevelPacks()[currentLevelPack]
        let levels = levelPackData["levels"] as! [[String : AnyObject]]
        
        if currentLevel < levels.count - 1 {
            currentLevel++
        } else {
            currentLevel = -1
        }
    }
    
    func checkDetailCellState() {
        var levelPacks = getLevelPacks()
        var levelPackData = levelPacks[currentLevelPack]
        
        if levelPackData["cellState"] as! String != DetailCellState.Placed.rawValue {
            levelPackData.updateValue(DetailCellState.Placed.rawValue, forKey: "cellState")
            levelPacks[currentLevelPack] = levelPackData
            
            if currentLevelPack < levelPacks.count - 1 {
                if levelPacks[currentLevelPack + 1]["cellState"] as! String == DetailCellState.NonActive.rawValue {
                    var nextLevelPack = levelPacks[currentLevelPack + 1]
                    nextLevelPack.updateValue(DetailCellState.Active.rawValue, forKey: "cellState")
                    levelPacks[currentLevelPack + 1] = nextLevelPack
                }
            }
            
            writeToPropertyListFile(levelPacks)
        }
    }
    
    func goToMenu(view: SKView) {
        currentLevel = -1
        currentLevelPack = -1
        
        view.presentScene(MenuScene(), transition: SKTransition.crossFadeWithDuration(0.4))
    }
    
    func getSettings() {
        let settings = getLevelsData()["settings"] as! [String : AnyObject]
        if settings["sounds"] as! String == "Off" {
            AudioPlayer.sharedInstance.soundsSwitcher.switchOff()
        }
        
        if settings["music"] as! String == "Off" {
            AudioPlayer.sharedInstance.musicSwitcher.switchOff()
        }
    }
}