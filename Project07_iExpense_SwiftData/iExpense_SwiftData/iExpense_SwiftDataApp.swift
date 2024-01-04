//
//  iExpense_SwiftDataApp.swift
//  iExpense_SwiftData
//
//  Created by coletree on 2024/1/4.
//
import SwiftData
import SwiftUI


@main
struct iExpense_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //创建底层数据库文件，modelContainer 是 SwiftData 存储数据位置的名称
        .modelContainer(for: ExpenseItem.self)
    }
}
