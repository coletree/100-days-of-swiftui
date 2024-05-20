//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by coletree on 2024/5/15.
//

import XCTest

final class UltimatePortfolioUITests: XCTestCase {

    /// 将应用程序作为属性，在该方法中去配置和启动
    var app: XCUIApplication!

    /// setUpWithError：该方法会在该类中的其他每个测试用例启动前被调用
    override func setUpWithError() throws {
        // 对 UI 测试来说，最好是遭遇失败时立即停止运行
        continueAfterFailure = false
        // 设置初始状态对 UI 测试非常重要，例如设备方向等，这些配置放在该方法最合适
        app = XCUIApplication()
        // 设置启动参数 launchArguments ，这是一个数组，现在放了3个参数，包含自定义的，以及使用英语作为语言的
        app.launchArguments = ["enable-testing", "-AppleLanguages", "(en)"]
        app.launch()

    }

    /// UI 测试用例：测试导航栏是否存在
    func testAppStartsWithNavigationBar() throws {
        // 使用 XCTAssert 断言和相关方法，去验证测试结果
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")
    }

    /// UI 测试用例：验证各类按钮是否都存在：
    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button launch.")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filter button launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Issue"].exists, "There should be a New Issue button launch.")
    }

    /// UI 测试用例：检查初始状态的 cell
    func testNoIssuesAtStart() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
    }

    /// UI 测试用例：创建5个问题，过程中检查 cell
    func testCreatingIssues() {

        for tapCount in 1...5 {
            // 模拟点击 New Issue 按钮，然后再点击 Issues 按钮返回
            app.buttons["New Issue"].tap()
            // app.buttons["Issues"].tap()
            app.buttons.element(boundBy: 0).tap()
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

    /// UI 测试用例：编辑问题标题
    func testEditingIssueTitleUpdatesCorrectly() {

        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
        app.buttons["New Issue"].tap()

        // 填写问题标题
        app.textFields["Enter the issue title here"].tap()
        app.textFields["Enter the issue title here"].clear()
        app.typeText("My New Issue")

        // 返回问题列表
        app.buttons["Issues"].tap()
        // XCTAssertTrue(app.cells["My New Issue"].exists, "A My New Issue cell should now exist.")
        XCTAssertTrue(app.buttons["My New Issue"].exists, "A My New Issue cell should now exist.")
    }

    /// UI 测试用例：测试设置问题优先级为高，是否生效
    func testEditingIssuePriorityShowsIcon() {
        app.buttons["New Issue"].tap()
        app.buttons["Priority, Medium"].tap()
        app.buttons["High"].tap()

        app.buttons["Issues"].tap()

        let identifier = "New issue High Priority"
        XCTAssert(app.images[identifier].exists, "A high-priority issue needs an icon next to it.")
    }

    /// UI 测试用例：测试徽章页面点击每个徽章是否会弹窗
    func testAllAwardsShowLockedAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            // 如果徽章没有完全在应用程序的窗口中，告诉滚动视图向下滚动，然后再继续
            if app.windows.firstMatch.frame.contains(award.frame) == false {
                app.swipeUp()
            }
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }

}

/// 添加扩展
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
