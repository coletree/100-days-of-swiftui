//
//  Mission.swift
//  Moonshot
//
//  Created by coletree on 2023/12/12.
//

import Foundation


//准备从 missions.json 文件中读取数据。该数据源的对象结构如下，可以看出有 2 个结构
//Mission是由：一个 ID 整数、一个 CrewRole 数组和一个描述字符串组成的结构。发布日期呢——可能有，也可能没有。那用 optional 表示
/*{
    "id": 1,
    "launchDate": "1968-10-11",
    "crew": [
        {
            "name": "",
            "role": ""
        }
    ],
    "description": ""
}
*/


//MARK: - Mission 数据模型
//使其符合 Codable 协议，因此可以直接从 JSON 创建该结构的实例
//使其符合 Identifiable 协议，因此可以在 ForEach 中使用数组（id 字段已经就绪）
//使其符合 Hashable 协议，这样才能用于 navigationPath 的传递值

struct Mission: Hashable, Codable, Identifiable {
    
    //MARK: - CrewRole 数据模型
    //此为嵌套结构写法：对理解上下文有帮助，对代码没什么影响（JSON中这部份是大括号的对象，要对应上）
    //已使其符合 Codable 的要求，因此可以直接从 JSON 创建该结构的实例
    struct CrewRole: Hashable, Codable {
        let name: String
        let role: String
    }

    //属性: 对应数据源中的 id
    let id: Int
    
    //属性: 对应数据源中的 launchDate。如果将某个属性标记为 optional ，如果输入的 JSON 中缺少该值， Codable 将自动跳过该属性
    //日期需要运用 dateDecodingStrategy 属性去解码，则必须是 Date 类型，不能是 String 了
    let launchDate: Date?
    
    //属性: 对应数据源中的 crew。crew 属性就是 CrewRole 数据结构的数组
    let crew: [CrewRole]
    
    //属性: 对应数据源中的 description
    let description: String

    //新增计算属性：根据id生成名字，方便使用
    var displayName: String {
        "Apollo \(id)"
    }

    //新增计算属性：根据id生成图片名，方便使用
    var image: String {
        "apollo\(id)"
    }

    //新增计算属性：格式化launchDate日期，方便使用
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    //所以数据模型的结构体属性，不受限于源数据，它可以多于源数据的。
    
}
