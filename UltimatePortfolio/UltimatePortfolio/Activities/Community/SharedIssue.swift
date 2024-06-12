//
//  SharedIssue.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/12.
//

import Foundation




// MARK: - 定义准备从 iCloud 读取的 Issue 对象的数据结构
struct SharedIssue: Identifiable {

    let id: String
    let title: String
    let content: String
    let status: Bool

}
