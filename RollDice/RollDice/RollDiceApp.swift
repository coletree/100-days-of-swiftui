//
//  RollDiceApp.swift
//  RollDice
//
//  Created by coletree on 2024/3/1.
//

import SwiftUI

@main
struct RollDiceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(myDice: Dice(sided: 6))
        }
    }
}
