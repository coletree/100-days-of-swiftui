//
//  SimpleWidget.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/29.
//

import Foundation
import SwiftUI
import WidgetKit


/// 小组件1：简单的
/// 视图：符合 SwiftUI View 的协议
struct PortfolioWidgetEntryView: View {
    // 它与 SimpleEntry 是相关连的
    var entry: Provider.Entry
    // 界面
    var body: some View {
        VStack {
            Text("Up next…")
                .font(.title)
            if let issue = entry.issues.first {
                Text(issue.issueTitle)
            } else {
                Text("Nothing!")
            }
        }
    }

}


/// 配置：用自己名称的结构体，符合 Widget 协议
struct SimplePortfolioWidget: Widget {

    // 该字符串是该小组件的名字
    let kind: String = "SimplePortfolioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PortfolioWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PortfolioWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        // 配置：展示的名称 & 展示的描述
        .configurationDisplayName("Up next…")
        .description("Your #1 top-priority item.")
        // 配置：支持展示的尺寸
        .supportedFamilies([.systemSmall])
    }
}


/// Preview 宏：它决定了如何在 Xcode 中预览我们的小部件
#Preview(as: .systemSmall) {
    SimplePortfolioWidget()
} timeline: {
    SimpleEntry(date: .now, issues: [.example])
    SimpleEntry(date: .now, issues: [.example])
}
