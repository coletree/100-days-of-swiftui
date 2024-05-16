//
//  UserFilterRow.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import SwiftUI


struct UserFilterRow: View {


    // MARK: - 属性

    var filter: Filter

    // 因为代码中有两个按钮是涉及重命名和删除过滤器的。一种选择是可以将重命名和筛选代码移动到该文件中，但这会变得很混乱。因为同时需要移动 completeRename 和 tagToRename ，以及renamingTag 和 tagName 属性
    // 另一种选择是将父视图的函数传入子视图。这里先添加两个新属性，它们都要求接受过滤器并且不返回任何内容。然后在父视图 SidebarView 中，我们传入它有的 rename() 和 delete() 方法
    var rename: (Filter) -> Void
    var delete: (Filter) -> Void




    // MARK: - 视图
    var body: some View {

        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
                // 在侧边栏中每个标签旁边显示其活动问题的数量
                .badge(filter.activeIssuesCount)
                // 设置长按上下文菜单
                .contextMenu {
                    // 重命名按钮
                    Button {
                        rename(filter)
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    // 删除按钮
                    Button(role: .destructive) {
                        delete(filter)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                // 增加旁白功能
                // 1.让子视图归组一起被读出，因为分别读出没什么意义
                .accessibilityElement()
                // 2.先读出标题
                .accessibilityLabel(filter.name)
                // 3.英语要解决复数问题
                .accessibilityHint("\(filter.activeIssuesCount) issue")

        }

    }




}
