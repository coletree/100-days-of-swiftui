//
//  Friend.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import Foundation
import SwiftData


//Friend模型：Friend遵循Codable，才能让关联Friend的User也遵循Codable
//遵循了Codable后，就不需要再遵循 Identifiable, Hashable ，因为 Codable 已经遵循了


@Model
class Friend: Codable, Equatable{
    
    var id : String
    var name : String
    
    //MARK: - 创建自定义编码解码
    
    //定义CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    //新的初始化方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //在 JSON 中查找与 CodingKeys.xxxx 匹配的属性，然后分配本地的 self.xxx 值
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    //新的encode方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //将当前 self.xxx 属性的值写入 CodingKeys.xxxx 这个键
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
    
}
