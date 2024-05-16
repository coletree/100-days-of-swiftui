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

/// Tag 相关的测试用例（继承自BaseTestCase）
final class TagTests: BaseTestCase {

    /// 测试用例：标签/问题的创建与获取，其数量是否能保持一致（例如创建 10 个标签，每个标签 10 个问题，最终应得到 10 个标签和 100 个问题）
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

    /// 测试用例：标签与问题是否独立（例如删除标签后，不会删除该标签下的问题，因为用的 nullify 关联模式）
    func testDeletingTagDoesNotDeleteIssues() throws {
        dataController.createSampleData()
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)

        dataController.delete(tags[0])
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "Expected 4 tags after deleting 1.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "Expected 50 issues after deleting a tag.")
    }

}
