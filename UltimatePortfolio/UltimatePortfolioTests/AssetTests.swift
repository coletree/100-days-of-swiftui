//
//  AssetTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/11.
//

import XCTest

// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio

/// Asset 资产相关的测试用例
class AssetTests: XCTestCase {

    /// 测试用例：测试资产目录中是否包含代码期望的所有颜色
    /// 这样可以防止人们意外地从资产目录中删除一个，或者尝试在代码中添加一个新资产，而不在目录中添加匹配的颜色。
    /// 具体做法是：将颜色字符串加载到 SwiftUI `Color` 结构中。这将始终成功，因为如果颜色不存在，将在 Xcode 的调试区域中获得一个静默日志
    /// 因此，为了使其可测试，我们将使用 UIKit 加载颜色 - 这将返回一个可选的 `UIColor` ，然后我们可以根据 nil 检查我们的测试是通过还是失败
    func testColorsExist() {
        let allColors = ["Dark Blue", "Dark Gray", "Gold", "Gray", "Green",
                         "Light Blue", "Midnight", "Orange", "Pink", "Purple", "Red", "Teal"]
        for color in allColors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    /// 测试用例：检查 Award.allAwards 该属性是否为空，因为这样做会尝试从捆绑包中加载和解码Awards.json
    /// 因此，任何将 JSON 更改为无效或更改我们的 Award 结构使其不再与 JSON 匹配的尝试都将失败。
    func testAwardsLoadCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }

}
