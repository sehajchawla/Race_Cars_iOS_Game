//
//  Helper.swift
//  TapCars
//
//  Created by Sehaj Chawla on 06/04/18.
//  Copyright © 2018 Sehaj Chawla. All rights reserved.
//

import Foundation
import UIKit

struct ColliderType {
    //assigning identifiers to the different types of objects so e can easily rfer to them in the colliding code
    static let CAR_COLLIDER: UInt32 = 0
    static let ITEM_COLLIDER: UInt32 = 1
    static let ITEM_COLLIDER_1: UInt32 = 2
}

class Helper: NSObject {
    func randomBetweenTwoNumbers(firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat {
        //as the name suggests this function returns a random number between two given numbers. It gets a random value multiplies it with the difference and adds it to the lesser of the two. SO for eg: between 4 and 5, the rado gives 0.25 so 0.25(5-4) = 0.25 -> 0.25+4 = 4.25 is the returned val.
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
}


class Settings {
    //high score method
    static let sharedInstance = Settings()
    
    private init() {
         
        
    }
    
    var highScore = 0
    var coin = 0
    
}
