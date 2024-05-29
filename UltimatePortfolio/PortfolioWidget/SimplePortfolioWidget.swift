//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by coletree on 2024/5/27.
//

import WidgetKit
import SwiftUI




/// Provider 结构：符合 TimelineProvider 协议，这决定了如何获取小部件的数据
struct Provider: TimelineProvider {

    // Swift 知道该 placeholder() 方法将返回任何 Entry，我们明确告诉它我们返回的是 SimpleEntry
    // 因此 Swift 可以将这两条信息放在一起，以了解我们的提供者的 Entry 类型实际上是 . SimpleEntry
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), issues: [.example])
    }

    // 方法：现在应该显示什么
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date.now, issues: loadIssues())
        completion(entry)
    }

    // 方法：将来应该显示什么
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date.now, issues: loadIssues())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    // 方法：读取 issue
    func loadIssues() -> [Issue] {
        // 创建一个 DataController 实例
        let dataController = DataController()
        // 为高优先级 issue 创建一个获取请求
        let request = dataController.fetchRequestForTopIssues(count: 5)
        // 然后执行它并返回结果数据
        return dataController.results(for: request)
    }

}


/// SimpleEntry 结构体：符合 TimelineEntry 协议，决定小部件的数据结构
struct SimpleEntry: TimelineEntry {

    let date: Date
    let issues: [Issue]

}


/// PortfolioWidgetEntryView 结构体：符合 SwiftUI View 的协议，决定小部件的数据的呈现方式
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


/// 用小组件自己名称的结构体：符合 Widget 协议，这决定了小部件配置
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
