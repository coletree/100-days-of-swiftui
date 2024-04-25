//
//  DataController.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/24.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "CoreDataProject")

    init() {
        container.loadPersistentStores { 
            description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            //这要求 Core Data 根据对象的属性合并重复对象 - 它尝试使用新版本中的属性智能地覆盖其数据库中的版本。
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
}

