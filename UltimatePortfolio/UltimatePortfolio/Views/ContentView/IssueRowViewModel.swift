//
//  IssueRowViewModel.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/21.
//

import Foundation




extension IssueRow {

    // 使用动态成员查找
    @dynamicMemberLookup
    class ViewModel: ObservableObject {


        // MARK: - 属性

        // @ObservedObject var issue: Issue
        // 不需要将 issue 标记为 @ObservedObject
        let issue: Issue

        // 计算属性：把透明度判断的代码从视图中抽出来
        var iconOpacity: Double {
            issue.priority == 2 ? 1 : 0
        }

        // 计算属性：把图标标识符判断的代码从视图中抽出来（用于测试的）
        var iconIdentifier: String {
            issue.priority == 2 ? "\(issue.issueTitle) High Priority" : ""
        }

        // 计算属性：把旁白提示判断的代码从视图中抽出来
        var accessibilityHint: String {
            issue.priority == 2 ? "High priority" : ""
        }

        // 计算属性：格式化问题的创建时间
        // 从 Issue-CoreDataHelpers 文件里挪过来的，因为只有一个页面用到该属性，放到该页面对应的视图模型里比较好
        var creationDate: String {
            issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted)
        }

        // 计算属性：辅助功能标签
        var accessibilityCreationDate: String {
            issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted)
        }

        // 呼应 @dynamicMemberLookup 支持动态地查找成员名称，即属性。这是通过一个特殊的下标实现的
        subscript<Value>(dynamicMember keyPath: KeyPath<Issue, Value>) -> Value {
            issue[keyPath: keyPath]
        }



        // MARK: - 方法

        // 自定义初始化：初始化时人为注入全局数据模型 DataController
        init(issue: Issue) {
            self.issue = issue
        }


    }




}
