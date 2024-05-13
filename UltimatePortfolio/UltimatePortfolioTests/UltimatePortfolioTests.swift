//
//  UltimatePortfolioTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/11.
//

import CoreData
import XCTest

// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio

class BaseTestCase: XCTestCase {
    
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
    
}
