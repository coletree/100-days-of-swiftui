//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/24.
//

import CoreData
import SwiftUI


@main
struct CoreDataProjectApp: App {
    
    
    // MARK: - 属性

    //创建 DataController 的实例，其初始化方法里就会加载 Core data 数据
    @StateObject private var dataController = DataController()
    
    
    
    
    // MARK: - 根视图
    
    var body: some Scene {
        WindowGroup {
            HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
    
    
}
