//
//  Astronaut.swift
//  Moonshot
//
//  Created by coletree on 2023/12/12.
//

import Foundation


//数据源的对象结构如下，可以看出只有1个对象，因为{}只有一对
//但是对象前面有一个键名
/*
"grissom": {
    "id": " ",
    "name": " ",
    "description": " "
},
*/



//MARK: 对象1建模 Astronaut。将宇航员 JSON 数据转换为结构体
//已使其符合 Codable 的要求，因此可以直接从 JSON 创建该结构的实例
//已使其符合 Identifiable 的要求，因此可以在 ForEach 中使用数组（id 字段已经就绪）
struct Astronaut: Codable, Identifiable, Hashable {
    
    //属性1: 对应数据源id
    let id: String
    
    //属性1: 对应数据源name
    let name: String
    
    //属性1: 对应数据源description
    let description: String
    
}


