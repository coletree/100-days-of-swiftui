//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/14.
//

import CoreData
import XCTest


// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio


/// 关于扩展的测试用例
/// 例如：是否能按照预期读取或写入基础 Core Data 属性值
final class ExtensionTests: BaseTestCase {

    /// 测试用例：
    func testIssueTitleUnwrap() {
        let issue = Issue(context: managedObjectContext)

        issue.title = "Example issue"
        XCTAssertEqual(issue.issueTitle, "Example issue", "Changing title should also change issueTitle.")

        issue.issueTitle = "Updated issue"
        XCTAssertEqual(issue.title, "Updated issue", "Changing issueTitle should also change title.")
    }

}
