//
//  Tag-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/29.
//


import CloudKit
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


    // 因为这都是数据而不是逻辑，所以选择把代码放入 Project-CoreDataHelpers.swift 文件中：
    // 添加名为 prepareCloudRecords() 的新方法，它会将所有的项目数据转换为 CloudKit 记录
    func prepareCloudRecords(owner: String) -> [CKRecord] {
        let parentName = objectID.uriRepresentation().absoluteString
        let parentID = CKRecord.ID(recordName: parentName)
        let parent = CKRecord(recordType: "Tag", recordID: parentID)
        parent["name"] = tagName
        parent["owner"] = owner
        print(tagName)

        // 确保 issues 是一个 NSSet 并且转换为 [Issue]
        guard let tagItemsArray = issues?.allObjects as? [Issue] else {
            return [parent]
        }

        var records = tagItemsArray.map { item -> CKRecord in
            let childName = item.objectID.uriRepresentation().absoluteString
            let childID = CKRecord.ID(recordName: childName)
            let child = CKRecord(recordType: "Issue", recordID: childID)
            child["title"] = item.issueTitle
            child["content"] = item.issueContent
            child["status"] = item.issueStatus
            child["owner"] = owner
            child["tag"] = CKRecord.Reference(recordID: parentID, action: .deleteSelf)
            return child
        }

        records.append(parent)
        print("\(records.count)条数据准备成功")
        return records
    }

}
