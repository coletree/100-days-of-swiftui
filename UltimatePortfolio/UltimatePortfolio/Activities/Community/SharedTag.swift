//
//  SharedTag.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/12.
//

import Foundation




// MARK: - 定义准备从 iCloud 读取的 Tag 对象的数据结构
struct SharedTag: Identifiable {

    let id: String
    let name: String
    let owner: String

    static let example = SharedTag(id: "1", name: "Example", owner: "tree")

}
