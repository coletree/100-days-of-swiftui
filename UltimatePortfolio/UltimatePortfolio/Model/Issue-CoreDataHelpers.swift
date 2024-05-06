//
//  Issue-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/29.
//

import Foundation


//通过对 Issue 类进行扩展，来解决可选值的问题（每个CoreData的Entity都会自动生成一个类）
extension Issue: Comparable {
    
    //【普通类型属性】设置默认值，即可解包
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
    
    //计算属性：问题的当前完成状态。我们已经有布尔值 completed 来跟踪问题是否已完成，但界面希望展示字符串，所以添加一个属性以正确地字符串化布尔值：
    var issueStatus: String {
        if completed {
            return "Closed"
        } else {
            return "Open"
        }
    }
    
    
    //【NSSet类型属性】需要转型
    //将 NSSet 数组转型为 Tag 数组，并对该数组进行统一排序
    var issueTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    //静态属性：添加静态 example 属性，用于创建用于预览的示例项
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
    
    //方法：由于遵循了 Comparable 协议，自定义比较运算
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
