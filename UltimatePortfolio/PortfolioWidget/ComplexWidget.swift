//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by coletree on 2024/5/27.
//

import Foundation
import SwiftUI
import WidgetKit


/// 小组件2：复杂的
/// 视图：符合 SwiftUI View 的协议
struct PortfolioWidgetMultipleEntryView: View {

    // 它与 SimpleEntry 是相关连的
    let entry: Provider.Entry

    // 环境属性：获取当前小组件尺寸
    @Environment(\.widgetFamily) var widgetFamily

    // 环境属性：获取当前屏幕的字体动态大小
    @Environment(\.sizeCategory) var sizeCategory

    // 计算属性：获取数据切片
    var issues: [Issue] {
        let itemCount: Int
        switch widgetFamily {
        case .systemSmall:
            itemCount = 1
        case .systemLarge:
            if sizeCategory < .extraExtraLarge {
                itemCount = 5
            } else {
                itemCount = 4
            }
        default:
            if sizeCategory < .extraLarge {
                itemCount = 3
            } else {
                itemCount = 2
            }
        }
        return Array(entry.issues.prefix(itemCount))
    }

    // 界面
    var body: some View {
        VStack(spacing: 5) {
            ForEach(issues) { issue in
                HStack {
                    Color(issue.issueTags.first?.color ?? "Gold")
                        .frame(width: 5)
                        .clipShape(Capsule())
                    VStack(alignment: .leading) {
                        Text(issue.issueTitle)
                            .font(.headline)
                            .layoutPriority(1)
                        if let tagTitle = issue.issueTags.first?.tagName {
                            Text(tagTitle)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(20)
    }
}


/// 配置：用自己名称的结构体，符合 Widget 协议
struct ComplexPortfolioWidget: Widget {

    // 该字符串是该小组件的名字
    let kind: String = "ComplexPortfolioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PortfolioWidgetMultipleEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PortfolioWidgetMultipleEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Up next…")
        .description("Your most important items.")
    }

}


/// Preview 宏：它决定了如何在 Xcode 中预览我们的小部件
#Preview(as: .systemMedium) {
    ComplexPortfolioWidget()
} timeline: {
    SimpleEntry(date: .now, issues: [.example])
    SimpleEntry(date: .now, issues: [.example])
}
