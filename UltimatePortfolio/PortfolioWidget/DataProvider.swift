//
//  DataProvider.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/29.
//

import Foundation
import WidgetKit


/// Provider 结构：符合 TimelineProvider 协议，定义如何获取小部件的数据
struct Provider: TimelineProvider {

    // 设置别名，让 getTimeline 方法可以识别类型
    typealias Entry = SimpleEntry

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


/// SimpleEntry 结构体：符合 TimelineEntry 协议，定义小部件的数据结构
struct SimpleEntry: TimelineEntry {
    let date: Date
    let issues: [Issue]
}
