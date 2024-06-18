//
//  IssueViewToolbar.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import CoreHaptics
import SwiftUI


struct IssueViewToolbar: View {


    // MARK: - 属性

    // 抽出视图后会收到错误，因为代码引用了 dataController 和 showingAwards ，所以添加以下两个新属性

    // 环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    // ObservedObject属性：该属性是在父视图列表中传入的。如果不用 ObservedObject ，后面无法绑定
    @ObservedObject var issue: Issue

    // 自定义触觉引擎：在视图中添加属性创建引擎实例，它负责启动 Taptic Engine
    @State private var engine = try? CHHapticEngine()




    // MARK: - 视图
    var body: some View {

        Menu {

            // 按钮：复制标题
            #if os(iOS)
            Button {
                UIPasteboard.general.string = issue.title
            } label: {
                Label("Copy Issue Title", systemImage: "doc.on.doc")
            }
            #endif

            // 按钮：将问题标记为已完成，修改完进行保存
            Button(action: toggleCompleted) {
                Label(
                    issue.completed ? "Re-open Issue" : "Close Issue",
                    systemImage: "bubble.left.and.exclamationmark.bubble.right"
                )
            }
            // 添加触觉反馈
//            .sensoryFeedback(trigger: issue.completed) { oldValue, newValue in
//                if newValue {
//                    .success
//                } else {
//                    nil
//                }
//            }

            Divider()

            // 复用 TagsMenuView
            Section("Tags") {
                TagsMenuView(issue: issue)
            }

        }
        label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }

    }




    // MARK: - 方法

    // 方法：自定义触觉反馈
    func toggleCompleted() {
        issue.completed.toggle()
        dataController.save()
        if issue.completed {
            // iOS16 以前的 UIKit 的触觉反馈
            // UINotificationFeedbackGenerator().notificationOccurred(.success)
            // 创建两个参数给后面的事件使用
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            // 添加两个控制点：它们本身不做任何事情，因为它们只是孤立的点，
            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
            // 这一行会将两个点组合成一条曲线，该曲线从 start 开始，到 end 结束，用于控制 haptic 的强度
            let parameter = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [start, end],
                relativeTime: 0
            )
            // 事件1: 瞬态的快速点击，强烈而沉闷，并立即开始
            let event1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )
            // 事件2: 连续的嗡嗡声，强烈而沉闷，持续1秒钟，在 1/8 秒后开始，感觉与刚刚进行的快速点击是分开的
            let event2 = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [sharpness, intensity],
                relativeTime: 0.125,
                duration: 1
            )
            do {
                try engine?.start()
                // 结合这两个事件作为一个序列发生，同时附加制作的参数曲线，以便连续触觉的强度逐渐消失
                // 这是通过将我们的事件包装在一个模式 pattern 中，并将它们作为一个数组来完成的
                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
                // 使用该 pattern 模式，声明一个 player 属性
                let player = try engine?.makePlayer(with: pattern)
                // player 开始播放触觉反馈
                try player?.start(atTime: 0)
            } catch {
                // playing haptics didn't work, but that's okay
                // 如果由于某种原因触觉效果失败，它实际上对程序功能没有影响，所以可以不处理
            }
        }
    }




}




// MARK: - 预览
#Preview {
    IssueViewToolbar(issue: .example)
        // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
