//
//  Tag-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/29.
//

import Foundation


// 通过对 Tag 类进行扩展，来解决可选值的问题（每个CoreData的Entity都会自动生成一个类）
extension Tag: Comparable {

    // 【普通类型属性】设置默认值，即可解包
    var tagID: UUID {
        id ?? UUID()
    }

    var tagName: String {
        name ?? ""
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
