//
//  Result.swift
//  BucketList
//
//  Created by coletree on 2024/1/17.
//

import Foundation



//MARK: - 维基百科返回数据的 根对象，它里面下级只有一个 query 属性
struct Result: Codable {
    let query: Query
}


//MARK: - 维基百科返回数据中的 query 对象，它下级有一个[ Int : Page ] 的字典
struct Query: Codable {
    let pages: [Int: Page]
}


//MARK: - 维基百科返回数据中的 page 对象，这个 page 是自己起的名，JSON中的对象只有大括号，没有名字
struct Page: Codable, Comparable {
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    //创建一个计算属性，如果 terms 存在值则返回描述，否则返回固定字符串。这样可以避免每次使用时都要对 terms 解包
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    //符合 Comparable 可比较协议，需要重写 < 函数
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
}
