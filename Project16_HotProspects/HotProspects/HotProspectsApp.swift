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
        //这为 Prospect 类创建了存储空间，同时也将共享的 SwiftData 模型上下文放置到应用程序中的每个 SwiftUI 视图中
    }
}
