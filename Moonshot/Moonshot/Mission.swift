//
//  Mission.swift
//  Moonshot
//
//  Created by coletree on 2023/12/12.
//

import Foundation


//数据源的对象结构如下，可以看出有2个对象
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



//MARK: 对象1建模 Mission
//已使其符合 Codable 的要求，因此可以直接从 JSON 创建该结构的实例
//已使其符合 Identifiable 的要求，因此可以在 ForEach 中使用数组（id 字段已经就绪）
struct Mission: Hashable, Codable, Identifiable {
    
    //MARK: 对象2建模 CrewRole（JSON中这部份是大括号的对象，要对应上）
    //此为嵌套结构写法：对理解上下文有帮助，对代码没什么影响
    //已使其符合 Codable 的要求，因此可以直接从 JSON 创建该结构的实例
    struct CrewRole: Hashable, Codable {
        let name: String
        let role: String
    }

    //属性1: 对应数据源id
    let id: Int
    //属性2: 对应数据源launchDate。如果将某个属性标记为 optional ，如果输入的 JSON 中缺少该值， Codable 将自动跳过该属性
    let launchDate: Date?
    //属性3: 对应数据源crew。crew 属性就是 CrewRole 结构的数组
    let crew: [CrewRole]
    //属性3: 对应数据源description。
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
    
}


//所以建模的结构体的属性，可以多于数据源的。
