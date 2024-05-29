//
//  Tag-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/29.
//

import Foundation


/// Tag 类的扩展：注意解决 CoreData 可选值的问题（每个 CoreData 的 Entity 都会自动生成同名类）
extension Tag: Comparable {

    // 普通类型属性：设置默认值，即可解包
    var tagID: UUID {
        id ?? UUID()
    }

    var tagName: String {
        name ?? ""
    }

    var tagColor: String {
        color ?? "Dark Blue"
    }

    // 计算属性：获取所有为完成的问题（NSSet 类型属性需要转型）
    // 将 NSSet 数组转型为 Issue 数组，并只过滤出 complete 属性是 false 的
    var tagActiveIssues: [Issue] {
        let result = issues?.allObjects as? [Issue] ?? []
        return result.filter { $0.completed == false }
    }

    // 方法：由于遵循了 Comparable 协议，自定义比较运算
    public static func <(lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase
        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }

}
