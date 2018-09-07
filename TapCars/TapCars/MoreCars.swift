//
//  MoreCars.swift
//  TapCars
//
//  Created by Sehaj Chawla on 25/07/18.
//  Copyright © 2018 Sehaj Chawla. All rights reserved.
//

import Foundation
import SpriteKit


class MoreCars: SKScene {

    var back = SKSpriteNode()
    var descriptionCars = SKLabelNode()
    
    var coins = SKLabelNode()
    
    var car_2_locked = SKSpriteNode()
    var car_3_locked = SKSpriteNode()
    var car_4_locked = SKSpriteNode()
    var label_car_2 = SKLabelNode()
    var label_car_3 = SKLabelNode()
    var label_car_4 = SKLabelNode()
    var buyButton_1 = SKSpriteNode()
    var buyButton_2 = SKSpriteNode()
    var buyButton_3 = SKSpriteNode()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLoaction = touch.location(in: self)
            if atPoint(touchLoaction).name == "backButton" {
                let gameMenu = SKScene(fileNamed: "GameMenu")!
                gameMenu.scaleMode = .aspectFill
                
                view?.presentScene(gameMenu, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
            }
            if atPoint(touchLoaction).name == "car_1" {
                descriptionCars.text = "Beetle: A small, sturdy car! "
            }
            if atPoint(touchLoaction).name == "car_2" {
                descriptionCars.text = "Spider: Switches between lanes faster! "
            }
            if atPoint(touchLoaction).name == "car_3" {
                descriptionCars.text = "Eagle: Gives a headstart of 100 everytime!"
            }
            if atPoint(touchLoaction).name == "car_4" {
                descriptionCars.text = "Cheetah: So fast it slows down time!"
            }
            if atPoint(touchLoaction).name == "buyButton_1" {
                var coinsDefault = UserDefaults.standard
                var coin = coinsDefault.value(forKey: "Coins") as! NSInteger
                
                if coin > 1000 {
                    coin = coin - 1000
                    coinsDefault.setValue(coin, forKey: "Coins")
                    coinsDefault.synchronize()
                    
                    buyButton_1.removeFromParent()
                    label_car_2.removeFromParent()
                    car_2_locked.removeFromParent()
                    
                }
                else {
                    descriptionCars.text = "Get more coins by clicking on +"
                }
            }
            if atPoint(touchLoaction).name == "buyButton_2" {
                var coinsDefault = UserDefaults.standard
                var coin = coinsDefault.value(forKey: "Coins") as! NSInteger
                
                if coin > 100000 {
                    coin = coin - 100000
                    coinsDefault.setValue(coin, forKey: "Coins")
                    coinsDefault.synchronize()
                    
                    buyButton_2.removeFromParent()
                    label_car_3.removeFromParent()
                    car_3_locked.removeFromParent()
                }
                else {
                    descriptionCars.text = "Get more coins by clicking on +"
                }
            }
            if atPoint(touchLoaction).name == "buyButton_3" {
                var coinsDefault = UserDefaults.standard
                var coin = coinsDefault.value(forKey: "Coins") as! NSInteger
                
                if coin > 1000000 {
                    coin = coin - 1000000
                    coinsDefault.setValue(coin, forKey: "Coins")
                    coinsDefault.synchronize()
                    
                    
                    buyButton_3.removeFromParent()
                    label_car_4.removeFromParent()
                    car_4_locked.removeFromParent()
                }
                else {
                    descriptionCars.text = "Get more coins by clicking on +"
                }
            }
        }
    }
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        //connecting the variable to the node in the scene
        back = self.childNode(withName: "backButton") as! SKSpriteNode
        descriptionCars = self.childNode(withName: "descriptionCars") as! SKLabelNode
        
        car_2_locked = self.childNode(withName: "car_2_locked") as! SKSpriteNode
        car_3_locked = self.childNode(withName: "car_3_locked") as! SKSpriteNode
        car_4_locked = self.childNode(withName: "car_4_locked") as! SKSpriteNode
        
        label_car_2 = self.childNode(withName: "label_car_2") as! SKLabelNode
        label_car_3 = self.childNode(withName: "label_car_3") as! SKLabelNode
        label_car_4 = self.childNode(withName: "label_car_4") as! SKLabelNode
        
        buyButton_1 = self.childNode(withName: "buyButton_1") as! SKSpriteNode
        buyButton_2 = self.childNode(withName: "buyButton_2") as! SKSpriteNode
        buyButton_3 = self.childNode(withName: "buyButton_3") as! SKSpriteNode
        
        
        coins = self.childNode(withName: "coins") as! SKLabelNode
        var coinsDefault = UserDefaults.standard
        
        if(coinsDefault.value(forKey: "Coins") != nil){
            var coin = coinsDefault.value(forKey: "Coins") as! NSInteger
            coins.text = "\(coin)"
        }

    }
    
    
    
    
    
}
