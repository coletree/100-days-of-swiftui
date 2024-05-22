//
//  IssueView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/30.
//

import SwiftUI


struct IssueView: View {


    // MARK: - 属性

    // 环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    // ObservedObject属性：该属性是在父视图列表中传入的。如果不用 ObservedObject ，后面无法绑定
    // selectedIssue 属性是可选的，应用开始时不会选定任何内容。但当它达到 IssueView 该属性时，它肯定应该有值。
    // 因此与其让 IssueView 读取可选值，不如为其提供一个非可选 Issue 属性
    @ObservedObject var issue: Issue




    // MARK: - 视图
    var body: some View {

        Form {

            // 第1部份：标题、修改日期、优先级...
            Section {

                VStack(alignment: .leading) {
                    // 标题: 与 issue 的 issueTitle 绑定
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                    // 修改时间：仅展示
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    // 状态: 与 issue 的 issueStatus 绑定
                    Text("**Status:** \(Text(issue.issueStatus))")
                        .foregroundStyle(.secondary)
                }

                // 优先级: 与 issue 的 priority 绑定
                // 由于CoreData那边使用 Integer 16 作为优先级属性，而 SwiftUI 认为 Int 值的 0 与 Int16 值的 0 不同。
                // 因此，为了让这个选择器真正工作，我们不能直接用 tag(0)，而是需要一个类型转换。这是Core Data的缺点之一。
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }

                // 菜单：标签管理菜单，已经移入子视图
                TagsMenuView(issue: issue)

            }

            // 第2部份：编辑 Issue 内容
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    // 内容: 与 issue 的 issueContent 绑定
                    // 这里用一个可自动扩展的单行输入框 TextField，而不是 TextEditor
                    TextField(
                        "Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical
                    )
                }
            }

        }
        // 对象被删除时禁用编辑：isDeleted 属性是 coredata 自动生成的，表示该对象已删除
        .disabled(issue.isDeleted)
        // 设置工具栏：已抽出子视图
        .toolbar { IssueViewToolbar(issue: issue) }

        // MARK: 设置保存点
        // onReceive 修改器会调用排队保存，onSubmit 修改器立即保存，因此这里会产生一点点重复工作
        // 监视 issue.objectWillChange 的更改，触发保存。在 删除实体对象 和 远程数据发生更改时 会发送 objectWillChange
        .onReceive(issue.objectWillChange) { _ in
            dataController.queueSave()
        }
        // 在点击完成按钮的时候，增加一个保存点
        .onSubmit(dataController.save)

    }




    // MARK: - 方法




}




// MARK: - 预览
#Preview {
    IssueView(issue: .example)
        .environmentObject(DataController.preview)
}