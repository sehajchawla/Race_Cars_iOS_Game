//
//  GameScene.swift
//  TapCars
//
//  Created by Sehaj Chawla on 05/04/18.
//  Copyright © 2018 Sehaj Chawla. All rights reserved.
//

import SpriteKit
import GameplayKit




class GameScene: SKScene, SKPhysicsContactDelegate {
   
    //making variables for the users cars
    var leftCar = SKSpriteNode()
    var rightCar = SKSpriteNode()

    //making boolean variables for car movement
    var canMove = false
    var leftToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    
    //making float values for car movement
    var centerPoint : CGFloat!
    let leftCarMinimumX : CGFloat = -280
    let leftCarMaximumX : CGFloat = -100
    
    let rightCarMinimumX : CGFloat = 100
    let rightCarMaximumX : CGFloat = 280
    
    
    //variables for countdown
    var countDown = 1
    var stopEverything = true
    
    //score variables
    var scoreText = SKLabelNode()
    var score = 0
    
    
    //highscore variables
    var gameSetting = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
      
        //setting the scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //calling functions
        setup()
        
        //making the entire scene such that it can have the contact physics in it
        physicsWorld.contactDelegate = self
        
        //making a timer for the countdown
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)
        
        //making a timer for the road strips and traffic, and calling the functions every few seconds
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        //the time interval here is a random value between 0 and 1.8 to make better gameplay
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil, repeats: true)
        
        //removing all the items that exited the screen every 2 seconds
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        
        
        //score implementing
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)

            })
        
    }
    
    func setup() {
        //linking to the variables
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        
        //finding value for center point
        centerPoint = self.frame.size.width / self.frame.size.height
        
        //making collision definitions for the different bodies
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        rightCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        rightCar.physicsBody?.collisionBitMask = 0
        
        //score card in the making
        let scoreBackground = SKShapeNode(rect: CGRect(x: -self.size.width/2 + 70, y: self.size.height/2 - 130, width: 180, height: 80), cornerRadius: 20)
        scoreBackground.zPosition = 4
        scoreBackground.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackground.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackground)
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width/2 + 160, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //getting locations of the touch
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            //next 20 lines are basically the logic behind the car movements
            if touchLocation.x > centerPoint {
                if rightCarAtLeft {
                    rightCarAtLeft = false
                    rightCarToMoveRight = true
                } else {
                    rightCarAtLeft = true
                    rightCarToMoveRight = false
                }
            } else {
                if leftCarAtRight {
                    leftCarAtRight = false
                    leftToMoveLeft = true
                } else {
                    leftCarAtRight = true
                    leftToMoveLeft = false
                }
            }
            canMove = true
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        showRoadSrip()
        if canMove {
            move(leftSide: leftToMoveLeft)
            moveRight(rightSide: rightCarToMoveRight)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //function for when a collision takes place
        
        //initializing variables
        var firstBody = SKPhysicsBody()
        
        //checking which body is the user car and ensures "firstbody" is the player
        if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar" {
            firstBody = contact.bodyA
        } else {
            firstBody = contact.bodyB
        }
        
        //remove the player
        firstBody.node?.removeFromParent()
    
        //calling the function that codes for the collision
        afterCollision()
    }
    
    @objc func createRoadStrip() {
        
        //making the two road strips (left and right)
        
        let leftRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
    }
    
    
    func showRoadSrip() {
        
        //changing the road strips' y position to 30 pts down, the enumerate function basically identifies all the strips using the names. NB: we're using the same function for traffic as well
        enumerateChildNodes(withName: "leftRoadStrip", using: {(roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        enumerateChildNodes(withName: "rightRoadStrip", using: {(roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        enumerateChildNodes(withName: "orangeCar", using: {(leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 15
        })
        
        enumerateChildNodes(withName: "greenCar", using: {(leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 15
        })
        
        
        
        
    }
    
    @objc func removeItems() {
        //for code optimization, we are removing all the road strip and car items that have left the screen (i.e. gone below the screen)
        for child in children {
            if (child.position.y < -self.size.height - 100) {
                child.removeFromParent()
            }
        }
    }
    
    
    func move(leftSide: Bool) {
        //for the left car
        //if it is in the left side it will move towards the right side and vica versa
        if leftSide {
            leftCar.position.x -= 20
            //setting minimum maximum borders of the lateral movement
            if leftCar.position.x < leftCarMinimumX {
               leftCar.position.x = leftCarMinimumX
            }
        } else {
            leftCar.position.x += 20
            //setting minimum maximum borders of the lateral movement
            if leftCar.position.x > leftCarMaximumX {
                leftCar.position.x = leftCarMaximumX
            }
        }
    }
    
    func moveRight(rightSide: Bool) {
        //same as "move" method but for right Car
        if rightSide {
            rightCar.position.x += 20
            if rightCar.position.x > rightCarMaximumX {
                rightCar.position.x = rightCarMaximumX
            }
        } else {
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarMinimumX {
                rightCar.position.x = rightCarMinimumX
            }
            
        }
    }
    
    @objc func  leftTraffic() {
        
        //waiting for the countdown to end
        if !stopEverything{
        //initializing the traffic that comes in in a random manner
        let leftTrafficItem: SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
        
        //switch statement that generates the two different cars
        switch Int(randomNumber) {
        case 1...3:
            leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            leftTrafficItem.name = "orangeCar"
            break
        case 4...6:
            leftTrafficItem = SKSpriteNode(imageNamed: "greenCar")
            leftTrafficItem.name = "greenCar"
            break
        default:
            leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            leftTrafficItem.name = "orangeCar"
            break
        }
        
        //making sure that the sprites location is defined by the center point of the sprite
        leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        leftTrafficItem.zPosition = 10
        
        //switch statemnt that generates the position of the cars
        let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
        
        switch Int(randomNum) {
        case 1...4:
            leftTrafficItem.position.x = -280
            break
        case 5...10:
            leftTrafficItem.position.x = -100
            break
        default:
            leftTrafficItem.position.x = -280
            break
        }
        
        //setting y position for the cars
        leftTrafficItem.position.y = 700
        
        //setting physics definitions
        leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
        leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        leftTrafficItem.physicsBody?.collisionBitMask = 0
        leftTrafficItem.physicsBody?.affectedByGravity = false
        
        
        //finally adding it to the scene
        addChild(leftTrafficItem)
        }
    }
    
    @objc func  rightTraffic() {
        
        //waiting for the countdown to end
        if !stopEverything{
        //initializing the traffic that comes in in a random manner
        let rightTrafficItem: SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
        
        //switch statement that generates the two different cars
        switch Int(randomNumber) {
        case 1...3:
            rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            rightTrafficItem.name = "orangeCar"
            break
        case 4...6:
            rightTrafficItem = SKSpriteNode(imageNamed: "greenCar")
            rightTrafficItem.name = "greenCar"
            break
        default:
            rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            rightTrafficItem.name = "orangeCar"
            break
        }
        
        //making sure that the sprites location is defined by the center point of the sprite
        rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        rightTrafficItem.zPosition = 10
        
        //switch statemnt that generates the position of the cars
        let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
        
        switch Int(randomNum) {
        case 1...4:
            rightTrafficItem.position.x = 280
            break
        case 5...10:
            rightTrafficItem.position.x = 100
            break
        default:
            rightTrafficItem.position.x = 280
            break
        }
        
        //setting y position for the cars
        rightTrafficItem.position.y = 700
        
        
        //setting physics definitions
        rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height/2)
        rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        rightTrafficItem.physicsBody?.collisionBitMask = 0
        rightTrafficItem .physicsBody?.affectedByGravity = false
        
        
        //finally adding it to the scene
        addChild(rightTrafficItem)
        }
    }
    
    func afterCollision () {
        //saves the score after the collision if it is higher than high score (using user defaults for highscore)
        var highScoreDefault = UserDefaults.standard
        var highscore = highScoreDefault.value(forKey: "Highscore") as! NSInteger
        if highscore < score {
            gameSetting.highScore = score
            
            //saving the high score to user defaults so that it stays there even when the application is shut
            highScoreDefault.set(score, forKey: "Highscore")
            highScoreDefault.synchronize()
            
        }
        
        
        
        
        
        var coinsDefault = UserDefaults.standard
        if coinsDefault.value(forKey: "Coins") == nil {
            coinsDefault.setValue(0, forKey: "Coins")
            coinsDefault.synchronize()

        } else {
        var coin = coinsDefault.value(forKey: "Coins") as! NSInteger
        coin = coin + score
        
        coinsDefault.setValue(coin, forKey: "Coins")
        coinsDefault.synchronize()
        }

    
        
        
        //function that transitions to the menu scene if player lost
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(1)))
    }
    
    @objc func startCountDown() {
        //function for the count down
        
        if countDown > 0 {
            if countDown < 4 {
                
                //creating and displaying the countdown
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenirNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.zPosition = 300
                countDownLabel.position = CGPoint(x: 0.5, y: 0.5)
                countDownLabel.name = "cLabel"
                countDownLabel.horizontalAlignmentMode = .center
                addChild(countDownLabel)
                
                
                //terminating the label after 0.5 seconds
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                    countDownLabel.removeFromParent()
                    })
            }
            //incrementing count down
            countDown += 1
            
            //countDown only goes 1..2..3
            if countDown == 4 {
                self.stopEverything = false
            }
            
        }
        
    }
    
    @objc func increaseScore() {
        //simple function that makes sure game is still going on and increments the score and changes the text of the label to the score. Function is implemented above in the timers section multiple times.
        if !stopEverything {
            score += 1
            scoreText.text = String(score)
        }
    }
    
    
    
   
    
    
}
