//
//  TagTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/12.
//

import CoreData
import XCTest

// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio

/// 一个 tag 测试用例
final class TagTests: BaseTestCase {

    /// 测试标签/问题创建与获取的数量是否一致（要求 Core Data 创建 10 个标签，每个标签 10 个问题，最终应得到 10 个标签和 100 个问题）
    func testCreatingTagsAndIssues() {
        let count = 10
        let issueCount = count * count

        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)
            for _ in 0..<count {
                let issue = Issue(context: managedObjectContext)
                tag.addToIssues(issue)
            }
        }

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), count, "Expected \(count) tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), issueCount, "Expected \(issueCount) issues.")
    }
    
    /// 测试是否删除标签后，会删除该标签下的所有问题
    func testDeletingTagDoesNotDeleteIssues() throws {
        
        dataController.createSampleData()
        
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)
        
        dataController.delete(tags[0])
        
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "Expected 4 tags after deleting 1.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "Expected 50 issues after deleting a tag.")
        
    }

}
