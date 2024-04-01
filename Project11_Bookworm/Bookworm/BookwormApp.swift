//
//  BookwormApp.swift
//  Bookworm
//
//  Created by coletree on 2023/12/26.
//


import Foundation
import SwiftData
import SwiftUI


@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
        //创建 swiftData 数据库，是 for 书籍对象的
    }
}
