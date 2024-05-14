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

/// 测试用例的基础：便于后续测试用例继承
/// 主要是创建 dataController 和 managedObjectContext，后续的测试用例都继承它就可以都获得数据模型的功能
class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    // setUpWithError 是执行测试前运行的方法，在这里初始化 dataController 和 managedObjectContext
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
