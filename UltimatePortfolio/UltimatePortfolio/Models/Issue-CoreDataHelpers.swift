//
//  Issue-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/29.
//

import Foundation
import SwiftUI




/// Issue 类的扩展：注意解决 CoreData 可选值的问题（每个 CoreData 的 Entity 都会自动生成同名类）
extension Issue: Comparable {

    // 普通类型属性：设置默认值，即可解包
    // 部分属性要用于绑定的，需要支持编辑，所以要支持 set，set 要修改原数据
    var issueID: UUID {
        id ?? UUID()
    }

    var issueTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }

    var issueContent: String {
        get { content ?? "" }
        set { content = newValue }
    }

    var issueCreationDate: Date {
        creationDate ?? .now
    }

    var issueModificationDate: Date {
        modificationDate ?? .now
    }

    // CoreData模型中的布尔值将自动设为 true/false，但 Date 属性就是可选属性，因此将以与处理其他属性相同的方式处理它
    var issueReminderTime: Date {
        get { reminderTime ?? .now }
        set { reminderTime = newValue }
    }

    // 计算属性：Issue当前完成状态。我们已经有布尔值 completed 来跟踪问题是否已完成，但界面希望展示字符串，所以添加计算属性将布尔值转成字符串：
    var issueStatus: String {
        if completed {
            return NSLocalizedString("Closed", comment: "This issue has been resolved by the user.")
        } else {
            return NSLocalizedString("Open", comment: "This issue is currently unresolved.")
        }
    }


    // 计算属性：格式化问题的创建时间。让视图那边的 Text 代码简单一点
    //    var issueFormattedCreationDate: String {
    //        issueCreationDate.formatted(date: .abbreviated, time: .omitted)
    //    }


    // 【NSSet类型属性】需要转型
    var issueTags: [Tag] {
        // 将 NSSet 数组转型为 Tag 数组，
        let result = tags?.allObjects as? [Tag] ?? []
        // 并对该数组进行统一排序
        return result.sorted()
    }

    // 将 issue 的标签数组转换为【仅包含其名称字符串】的数组
    var issueTagsList: String {
        let noTags = NSLocalizedString("No tags", comment: "The user has not created any tags yet")
        guard let tags else { return noTags }
        if tags.count == 0 {
            return noTags
        } else {
            // 这个 \.tagName 是 Swift 中的键路径语法,它表示访问 tag 对象的 tagName 属性
            // map 函数会遍历 issueTags 数组中的每个 tag 对象，并对每个对象执行 \.tagName 操作，也就是获取 tagName 属性的值
            // 最终 map 函数会返回一个新的数组，其中包含了 issueTags 数组中每个 tag 对象的 tagName 属性值
            // 用 formatted() 方法对这个字符串数组中的每个字符串进行格式化处理，方便显示
            // formatted() 方法是 Swift 5.0 引入的一个通用的格式化方法，它可以根据不同的格式化规则对字符串进行格式化
            // 默认情况下 formatted() 方法会使用系统的默认格式化规则,比如添加千位分隔符、小数点对齐等
            return issueTags.map(\.tagName).formatted()
        }
    }




    // 静态属性：添加静态 example 属性，用于创建用于预览的示例项
    static var example: Issue {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let issue = Issue(context: viewContext)
        issue.title = "Example Issue"
        issue.content = "This is an example issue."
        issue.priority = 2
        issue.creationDate = .now
        return issue
    }

    // 方法：由于遵循了 Comparable 协议，自定义比较运算
    public static func <(lhs: Issue, rhs: Issue) -> Bool {
        let left = lhs.issueTitle.localizedLowercase
        let right = rhs.issueTitle.localizedLowercase
        if left == right {
            return lhs.issueCreationDate < rhs.issueCreationDate
        } else {
            return left < right
        }
    }

}
