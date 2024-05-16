//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by coletree on 2024/5/15.
//

import XCTest

final class UltimatePortfolioUITests: XCTestCase {


    // 将应用程序作为属性，在该方法中去配置和启动
    var app: XCUIApplication!


    /// setUpWithError：该方法会在该类中的其他每个测试用例启动前被调用
    override func setUpWithError() throws {

        // 对 UI 测试来说，最好是遭遇失败时立即停止运行
        continueAfterFailure = false

        // 设置初始状态对 UI 测试非常重要，例如设备方向等，这些配置放在该方法最合适
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

    }


    /// UI 测试用例：测试导航栏是否存在
    func testAppStartsWithNavigationBar() throws {
        // 使用 XCTAssert 断言和相关方法，去验证测试结果
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")
    }


    /// UI 测试用例：验证各类按钮是否都存在：
    func testAppHasBasicButtonsOnLaunch() throws {
        // XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button launch.")
        // XCTAssertTrue(app.navigationBars.buttons["Add tag"].exists, "There should be a Add tag button launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Issue2"].exists, "There should be a New Issue button launch.")
    }
    
    
    /// UI 测试用例：检查初始状态的 cell
    func testNoIssuesAtStart() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
    }
    
    
    /// UI 测试用例：创建5个问题，过程中检查 cell
    func testCreatingIssues() {
        
        for tapCount in 1...5 {
            // 模拟点击 New Issue 按钮，然后再点击 Issues 按钮返回
            app.buttons["New Issue2"].tap()
            app.buttons["Issues"].tap()
            // 点完两个按钮，断言 1 次，最终总共断言 5 次
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
        
        // 通过删除 Issue 来进一步进行此测试
        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
        
    }
    

}



// 添加扩展
extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement.")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}
