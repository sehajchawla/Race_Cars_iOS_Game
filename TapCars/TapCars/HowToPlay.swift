//
//  HowToPlay.swift
//  TapCars
//
//  Created by Sehaj Chawla on 27/07/18.
//  Copyright © 2018 Sehaj Chawla. All rights reserved.
//

import Foundation
import SpriteKit


class HowToPlay: SKScene {
    
    var back = SKSpriteNode()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLoaction = touch.location(in: self)
            if atPoint(touchLoaction).name == "backButton" {
                let gameMenu = SKScene(fileNamed: "GameMenu")!
                gameMenu.scaleMode = .aspectFill
                
                view?.presentScene(gameMenu, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
            }
        }
    }
    override func didMove(to view: SKView) {
        back = self.childNode(withName: "backButton") as! SKSpriteNode
    }
    
    
    
}
