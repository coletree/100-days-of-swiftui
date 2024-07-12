//
//  RollDiceApp.swift
//  RollDice
//
//  Created by coletree on 2024/3/1.
//

import SwiftUI


@main
struct RollDiceApp: App {

    // 数据模型
    @State var store = DiceRollStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }

}
