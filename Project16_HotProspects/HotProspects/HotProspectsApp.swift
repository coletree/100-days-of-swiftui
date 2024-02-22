//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by coletree on 2024/1/30.
//

import SwiftData
import SwiftUI



@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
