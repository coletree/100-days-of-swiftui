//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//
import SwiftData
import SwiftUI



@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
