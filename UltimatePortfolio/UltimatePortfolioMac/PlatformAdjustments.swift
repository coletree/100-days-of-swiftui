//
//  PlatformAdjustments.swift
//  UltimatePortfolioMac
//
//  Created by coletree on 2024/6/17.
//


// 添加 Foundation 导入
import Foundation
import SwiftUI


// 1.为其提供第一个解决方法
// 这意味着“不管在代码任何地方看到 InsetGroupedListStyle，都会用 SidebarListStyle 代替
typealias InsetGroupedListStyle = SidebarListStyle


// 2. 由于无法在 macOS 上访问 UIApplication ，因此需要一个更好、更跨平台的解决方案：我们将让每个平台决定应该关注哪个通知
// 将其添加到针对 macOS 平台的调整文件中：
//  extension Notification.Name {
//      static let willResignActive = NSApplication.willResignActiveNotification
//  }
