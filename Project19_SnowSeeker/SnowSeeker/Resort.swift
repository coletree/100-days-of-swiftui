//
//  Resort.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//

import Foundation


/*
定义一个可以从 JSON 加载的简单 Resort 结构
这意味着它需要符合 Codable 协议，并且为了更容易使用，还将使其符合 Identifiable 协议
里面的数据大多只是字符串和整数，但还有一个名为 facilities 的字符串数组，它描述了度假村上还有什么
 
与往常一样，最好向模型添加示例值，以便更轻松地在设计中显示工作数据。
*/


struct Resort: Codable, Identifiable {
    
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    
    //计算属性：根据名字创建 Facility 实例，把 facilities 数组用 map 遍历处理，最后返回 Facility 结构的数组
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    
    //静态属性：直接 Resort. 可以访问示例。
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
    
}
