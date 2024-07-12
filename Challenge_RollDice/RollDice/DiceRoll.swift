//
//  DiceRoll.swift
//  RollDice
//
//  Created by coletree on 2024/7/10.
//

import Foundation


struct DiceRoll: Codable, Identifiable {

    var id = UUID()
    let faces: Int
    let result: Int
    let date: Date

}
