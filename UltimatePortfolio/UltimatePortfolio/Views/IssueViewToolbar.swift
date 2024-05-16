//
//  IssueViewToolbar.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import SwiftUI


struct IssueViewToolbar: View {


    // MARK: - 属性

    // 抽出视图后会收到错误，因为代码引用了 dataController 和 showingAwards ，所以添加以下两个新属性

    // 环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    // ObservedObject属性：该属性是在父视图列表中传入的。如果不用 ObservedObject ，后面无法绑定
    @ObservedObject var issue: Issue




    // MARK: - 视图
    var body: some View {

        Menu {

            // 按钮：复制标题
            Button {
                UIPasteboard.general.string = issue.title
            } label: {
                Label("Copy Issue Title", systemImage: "doc.on.doc")
            }

            // 按钮：将问题标记为已完成，修改完进行保存
            Button {
                issue.completed.toggle()
                dataController.save()
            } label: {
                Label(
                    issue.completed ? "Re-open Issue" :
                    "Close Issue",
                    systemImage: "bubble.left.and.exclamationmark.bubble.right"
                )
            }

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




}




// MARK: - 预览
#Preview {
    IssueViewToolbar(issue: .example)
        // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
