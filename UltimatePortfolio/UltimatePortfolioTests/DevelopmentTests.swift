//
//  DevelopmentTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/13.
//

import CoreData
import XCTest


// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio


/// 开发过程的相关测试用例
/// 例如：编写测试以确保我们的示例代码正确加载
/// 例如：编写测试以确保我们 deleteAll() 的方法有效
/// 例如：编写测试以确保我们 Tag 和 Issue 类都有良好的示例数据
final class DevelopmentTests: BaseTestCase {

    /// 测试用例：当创建示例数据时，确保会得到 5 个标签和 50 个问题
    func testSampleDataCreationWorks() {
        dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "There should be 5 sample tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "There should be 50 sample issues.")
    }

    /// 测试用例：确保该 deleteAll 方法确实删除了所有内容
    func testDeleteAllClearsEverything() {
        let tagCount = 5
        let issueCount = 10
        for _ in 0..<tagCount {
            let tag = Tag(context: managedObjectContext)
            for _ in 0..<issueCount {
                let issue = Issue(context: managedObjectContext)
                tag.addToIssues(issue)
            }
            dataController.save()
        }
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "deleteAll() should leave 0 tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 0, "deleteAll() should leave 0 issues.")
    }

    /// 测试用例：确保在创建示例 Tag 时，它内部没有关联任何 Issue
    func testExampleTagHasNoIssues() {
        let tag = Tag(context: managedObjectContext)
        XCTAssertEqual(tag.issues?.count, 0, "The example tag should has 0 issue.")
    }

    /// 测试用例：确保在创建示例 Issue 时，其优先级属性为 high
    func testExampleIssueIsHighPriority() {
        let issue = Issue.example
        // let issue = Issue(context: managedObjectContext)
        XCTAssertEqual(issue.priority, 2, "The example issue's priority should be 2.")
    }

}
