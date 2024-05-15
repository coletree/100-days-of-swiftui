//
//  Award.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/8.
//

import Foundation


// MARK: - 将 Awards.json 文件的内容解码为 Award 结构数组

// 先定义数据模型（这种数据是设计者固定的数据，所以不会用到coredata，直接建立 struct 对应 json 文件即可）
struct Award: Decodable, Identifiable {

    // 为了在 SwiftUI 中使用该结构体，需要符合 Identifiable 协议，那就需要有 id 属性。添加一个计算属性，该属性使用对象的名称作为其唯一标识符
    var id: String { name }
    var name: String
    var description: String
    var color: String
    var criterion: String
    var value: Int
    var image: String

    // 静态属性
    // 所有奖项：使用通用方法进行解码，解出来的所有 [Award] 对象生成一个静态属性，方便预览使用
    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    // 单个奖项：获取 allAwards 第一个元素作为示例
    static let example = allAwards[0]

}
