//
//  Dice.swift
//  RollDice
//
//  Created by coletree on 2024/3/1.
//

import Foundation


struct Dice {
    
    var sided : Int = 6
    
    init(sided: Int) {
        self.sided = sided
    }
    
    func rollDice() -> Int {
        let array = Array(1...sided)
        let result = array.randomElement() ?? 1
        return result
    }
    
}
