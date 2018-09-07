//
//  GameMenu.swift
//  TapCars
//
//  Created by Sehaj Chawla on 06/04/18.
//  Copyright © 2018 Sehaj Chawla. All rights reserved.
//

import Foundation
import SpriteKit


class GameMenu: SKScene {
    
    //initializing variable for start game label
    var startGame = SKSpriteNode()
    var moreCars = SKSpriteNode()
    var howToPlay = SKSpriteNode()
    
    //initializing variables for the best score
    var bestScore = SKLabelNode()
    var gameSettings = Settings.sharedInstance
    
    var coins = SKLabelNode()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //function to start game if the start game label is touched
        
        for touch in touches {
            let touchLoaction = touch.location(in: self)
            if atPoint(touchLoaction).name == "startGame" {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
            }
            if atPoint(touchLoaction).name == "moreCars" {
                let gameScene = SKScene(fileNamed: "MoreCars")!
                gameScene.scaleMode = .aspectFill
                
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
            }
            if atPoint(touchLoaction).name == "howToPlayButton" {
                let gameScene = SKScene(fileNamed: "HowToPlay")!
                gameScene.scaleMode = .aspectFill
                
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
            }
            
        }
    }
    
    
    override func didMove(to view: SKView) {
        //initializing the anchorpoint
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //connecting the variable to the node in the scene
        startGame = self.childNode(withName: "startGame") as! SKSpriteNode
        moreCars = self.childNode(withName: "moreCars") as! SKSpriteNode
        
        //connecting variables to best score (using user defaults to get the high score from the device)
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        var highScoreDefault = UserDefaults.standard
        
        coins = self.childNode(withName: "coins") as! SKLabelNode
        var coinsDefault = UserDefaults.standard
        
        //making sure it's not empty (for example when starting game for first time)
        if(highScoreDefault.value(forKey: "Highscore") != nil){
            var highscore = highScoreDefault.value(forKey: "Highscore") as! NSInteger
            bestScore.text = "Best: \(highscore)"
        }
        if(coinsDefault.value(forKey: "Coins") != nil){
            var coin = coinsDefault.value(forKey: "Coins") as! NSInteger
            coins.text = " \(coin)"
        }
    }
    
}
