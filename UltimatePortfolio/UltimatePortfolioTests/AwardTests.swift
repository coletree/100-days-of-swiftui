//
//  AwardTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/13.
//

import CoreData
import XCTest

// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio

/// Award 相关的测试用例（继承自BaseTestCase）
final class AwardTests: BaseTestCase {

    // 由于将大量使用awards，因此添加 Awards.allAwards 作为本地属性会更快捷
    let awards = Award.allAwards

    /// 测试用例：检查每个 Award 的 ID 和 name 是否相同
    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    /// 测试用例：确保新用户进入应用时，不会获得任何奖励
    func testNewUserHasUnlockedNoAwards() {
        // 之前的 DataController(inMemory: true) 代码其实是存在内存中的，每次启动都会重来，所以已经确保是新用户了
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }

    /// 测试用例：如何验证 “由问题提出数量决定是否能获得的徽章” 的有效性
    func testCreatingIssuesUnlocksAwards() {
        // 获得 Award 的规则是 1、10、20，然后是 50、100、250、500，最后是 1000。我们声明这些精确数量的数组，然后遍历它们以创建要匹配的确切数量的问题
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        // 通过 enumerated 方法将数组转化成二元序列
        for (count, value) in values.enumerated() {
            var issues = [Issue]()
            // 创建数量为 value 的问题
            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issues.append(issue)
            }
            // 在所有 Awards 里过滤出符合条件的 Award
            let matches = awards.filter { award in
                award.criterion == "issues" && dataController.hasEarned(award: award)
            }
            // 断言：符合条件的 Award 数量，应该等于二元序列中的整数序号
            XCTAssertEqual(matches.count, count + 1, "Adding \(value) issues should unlock \(count + 1) awards.")
            // 完成后把所有创建的问题删除，再进入下一个循环测试
            dataController.deleteAll()
        }
    }

    /// 测试用例：如何验证 “由问题关闭数量决定是否能获得的徽章” 的有效性
    func testClosedAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        // 通过 enumerated 方法将数组转化成二元序列
        for (count, value) in values.enumerated() {
            var issues = [Issue]()
            // 创建数量为 value 的问题，同时问题的 completed 属性为 true
            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issue.completed = true
                issues.append(issue)
            }
            // 在所有 Awards 里过滤出符合条件的 Award
            let matches = awards.filter { award in
                award.criterion == "closed" && dataController.hasEarned(award: award)
            }
            // 断言：符合条件的 Award 数量，应该等于二元序列中的整数序号
            XCTAssertEqual(matches.count, count + 1, "Completing \(value) issues should unlock \(count + 1) awards.")
            // 完成后把所有创建的问题删除，再进入下一个循环测试
            for issue in issues {
                dataController.delete(issue)
            }
        }
    }

}
