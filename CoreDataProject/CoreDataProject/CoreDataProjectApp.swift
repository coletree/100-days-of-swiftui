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
    
    
    //创建 dataController 的实例，其初始化方法里就会加载 Core data 数据
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
    
    
}
