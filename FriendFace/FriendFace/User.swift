//
//  User.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import Foundation
import SwiftData


//User模型：之前用 struct 定义时，所有属性先要遵循这些协议，这个struct才能遵循这些协议
//当改用 SwiftData 后，Model 只能用于 class，所以 struct 要改成 class，并且要遵循 Codable 协议
//遵循 Codable 协议后，Identifiable, Hashable协议可以删掉了，因为Codable必然遵循这两个协议


@Model
class User:Codable,  Equatable{
    
    var id : String
    var isActive : Bool
    var name : String
    var age : Int
    var company : String
    var email : String
    var address : String
    var about : String
    var registered : Date        //日期Date
    var tags : [String]          //字符串数组
    var friends : [Friend]       //对象数组

    
    //MARK: - 创建自定义编码解码
    
    //定义CodingKey
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isActive
        case name = "name"
        case age = "age"
        case company = "company"
        case email = "email"
        case address = "address"
        case about = "about"
        case registered
        case tags
        case friends
    }
    
    //居然可以在class定义内，去生成一个静态的实例化属性
    //生成这个静态属性，可以方便给视图预览代码调用
    static let example = User(id: "", isActive: true, name: "", age: 0, company: "", email: "", address: "", about: "", registered: .now, tags: ["String"], friends: [])
    
    
    //初始化方法
    init(id: String, isActive: Bool, name: String, age: Int, company: String, email: String, address: String, about: String, registered: Date, tags: [String], friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
    
    //新的初始化方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //在 JSON 中查找与 CodingKeys.xxxx 匹配的属性，然后分配本地的 self.xxx 值
        self.id = try container.decode(String.self, forKey: .id)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.about = try container.decode(String.self, forKey: .about)
        
        //获取的日期类型是字符串，要转成Date类型
        //let stringRegistered = try container.decode(String.self, forKey: .registered)
        //self.registered = ISO8601DateFormatter().date(from: stringRegistered) ?? .now
        
        self.registered = try container.decode(Date.self, forKey: .registered)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    //新的encode方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //将当前 self.xxx 属性的值写入 CodingKeys.xxxx 这个键
        try container.encode(self.id, forKey: .id)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.company, forKey: .company)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.about, forKey: .about)
        try container.encode(self.registered, forKey: .registered)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.friends, forKey: .friends)
    }
    
}
