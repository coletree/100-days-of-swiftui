//
//  URLDemoModel.swift
//  CupcakeCorner
//
//  Created by coletree on 2024/3/26.
//

import Foundation

/*
 我们将要求 iTunes API 向我们发送 Taylor Swift 的所有歌曲列表，然后使用 JSONDecoder 将这些结果转换为 Result 个实例。
 */



//MARK: - 单曲模型。 一般先从最小对象定义开始
struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}



//MARK: - 歌曲数组。
struct Response: Codable {
    var results: [Result]
}





@Observable
class User: Codable {
    var name = "Taylor"
}
