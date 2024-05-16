//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by coletree on 2024/5/15.
//

import XCTest

final class UltimatePortfolioUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI 测试必须在测试前启动应用程序。以下代码将创建默认应用程序的一个实例
        let app = XCUIApplication()
        // 然后通过 launch 启动应用程序实例，以准备开始测试
        app.launch()

        // 使用 XCTAssert 断言和相关方法，去验证测试结果
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
