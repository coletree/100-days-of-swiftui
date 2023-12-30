//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by coletree on 2023/12/29.
//

import SwiftData
import SwiftUI


@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //创建模型容器和模型上下文
        .modelContainer(for: User.self)
    }
}
