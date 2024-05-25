//
//  DataController-Notifications.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/23.
//


/// 用于处理本地通知
import Foundation
import UserNotifications




/// DataController 的扩展：专门处理本地通知的部分
extension DataController {

    // 方法：添加提醒。该方法是组合了后面三个方法的集合
    func addReminder(for issue: Issue) async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            // 1.首先检查本地通知的授权状态
            switch settings.authorizationStatus {
            // 2.如果状态未确定（即用户未做出选择），我们请求通知授权，并做出相应的响应
            case .notDetermined:
                // 请求通知授权
                let success = try await requestNotifications()
                // 如果授权成功
                if success {
                    // 则调用 placeReminders() 设置通知
                    try await placeReminders(for: issue)
                } else {
                    // 否则返回 false 退出方法
                    return false
                }
            // 3.如果已经获得授权，则调用 placeReminders() 设置通知
            case .authorized:
                try await placeReminders(for: issue)
            // 4.如果授权处于任何其他状态，则认为属于失败，返回 false 退出方法
            default:
                return false
            }
            // 调用 placeReminders() 设置通知的两个分支都会走到这
            return true
        } catch {
            return false
        }
    }

    // 方法：为特定 Issue 删除设置的任何通知。为此需要一种方法来唯一地识别 Issue
    // Core Data 确实提供了相关功能：每个托管对象都有一个 objectID 属性，可以转换为专为存档而设计的 URL
    // 一旦对象被保存（至少1次），则此 URL 对 Issue 来说将始终是唯一且稳定的
    // 对于该 removeReminders() 方法，我们将获取 Issue 的唯一 ID，然后要求通知中心删除所有待处理的请求（已发出但尚未送达的请求）
    func removeReminders(for issue: Issue) {
        let center = UNUserNotificationCenter.current()
        let id = issue.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    // 方法：请求 iOS 通知权限，它是 asynchronous 异步任务，因此需要使用并发 concurrency
    // 标记为私有方法，确保不会在其他地方意外调用它（它是使通知生效的实现细节，而不是项目其他部分应该注意的方法）
    private func requestNotifications() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound])
    }

    // 方法：设置本地通知。它可分解成四个部分
    private func placeReminders(for issue: Issue) async throws {

        // 第1部分：决定想要显示的内容（通过 UNMutableNotificationContent 类来处理）
        // 这里至少附加两条信息：Issue 标题，以及通知的默认系统声音。如果 Issue 设置了内容，可以将其添加为通知的副标题，否则将其留空
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = issue.issueTitle
        if let issueContent = issue.content {
            content.subtitle = issueContent
        }

        // 第2部分：定义本地通知的触发器。该例子只指定小时和分钟，然后要求 iOS 重复它。即通知将会每天触发一次，直到用户禁用它为止
        // 这里使用 DateComponents 结构体，将日期的每个部分存储为单个属性。即将问题的 reminderTime 属性转换为 DateComponents
        // 然后，这可以成为我们通知的日历触发器，如果我们重复它，那么iOS将每天自动触发通知。
        // let components = Calendar.current.dateComponents([.hour, .minute], from: issue.issueReminderTime)
        // let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        // 出于调试目的，最好使用以下触发器，它告诉 iOS 在五秒钟内显示提醒（我们按 Cmd+L 锁定屏幕，即可快速测试通知，而不是等待某个日期）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // 第3部分：创建请求，将内容和触发器包装在单个通知中，并为其提供唯一的 ID。
        // 此 ID 需要稳定，随着时间的推移需要保持一致。因为它与后续用户要删除时的通知 ID 要一致。因此我们使用 Issue 的对象 ID，以便以后轻松找到它。
        let id = issue.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        // 第4部分：
        try await UNUserNotificationCenter.current().add(request)

    }

}
