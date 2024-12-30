//
//  DataController-Awards.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/28.
//

import Foundation




extension DataController {

    // 从原始 DataController 类中剪切出整个 hasEarned(award:) 方法，以便不需要加入到 Widget 目标中

    // TODO: - 方法：评估奖励
    // 评估是否得到奖励，有两个重要的值：criterion 和 value，最终返回的是布尔值。因此后续可以用于数组的 filter 过滤
    func hasEarned(award: Award) -> Bool {
        // 首先判断标准 criterion 属于什么情况
        switch award.criterion {

            case "issues":
                // 标准为 issues 的情况下，如果查询到 issue 的数量大于标准值，返回 true
                let fetchRequest = Issue.fetchRequest()
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "closed":
                // 标准为 closed 的情况下，如果查询到（状态为已完成的 issue） 的数量大于标准值，返回 true
                let fetchRequest = Issue.fetchRequest()
                // 添加了一个简单的谓词来按已完成的问题进行过滤
                fetchRequest.predicate = NSPredicate(format: "completed = true")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "tags":
                // 标准为 tags 的情况下，如果查询到 tag 的数量大于标准值，返回 true
                let fetchRequest = Tag.fetchRequest()
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "unlock":
                return fullVersionUnlocked

            case "chat":
                return UserDefaults.standard.integer(forKey: "chatCount") >= award.value

            default:
                // an unknown award criterion; this should never be allowed
                // fatalError("Unknown award criterion: \(award.criterion)")
                return false

        }
    }


}
