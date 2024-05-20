//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/14.
//

import CoreData
import XCTest

// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio

final class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() {

        // 不需要进行基准测试的代码部分，请放到 measure() 之外。例如，这里的设置工作实际上不影响性能，因此我们不希望对其进行测量
        for _ in 1...100 {
            dataController.createSampleData()
        }
        let awards = Array(repeating: Award.allAwards, count: 40).joined()

        // 断言所有徽章的数量
        XCTAssertEqual(awards.count, 800, "This checks the awards count is constant. Change this if you add awards.")

        // 最重要的部分是调用 measure() 方法，把需要进行性能测试的核心代码放到里面
        measure {
            // awards 数组调用 filter() 方法会根据谓词函数过滤每个奖项
            // 它把每个 award 拿出来，执行 dataController 的 hasEarned 方法，如果返回 true，则保留该 award
            // 这里代码只有一行，它创建了一个数组，其中包含迄今为止【获得的】所有奖项
            // 这里闭包简写成了一行，实际是有个 award 参数，要传入 hasEarned 方法的
            _ = awards.filter(dataController.hasEarned)
        }

    }

}
