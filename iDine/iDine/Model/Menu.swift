//
//  Menu.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI




//MARK: - MenuSection 模型
struct MenuSection: Codable, Identifiable {
    
    //变量属性：符合 Identifiable 协议要实作 id
    var id: UUID
    
    //变量属性：名称
    var name: String
    
    //变量属性：定义一个包含 MenuItem 元素的数组
    var items: [MenuItem]
    
}




//MARK: - 单个 MenuItem 模型
struct MenuItem: Codable, Hashable, Identifiable {
    
    //变量属性：符合 Identifiable 协议要实作 id
    var id: UUID
    
    //变量属性：名称
    var name: String
    
    //变量属性：照片版权
    var photoCredit: String
    
    //变量属性：价格指数
    var price: Int
    
    //变量属性：标签
    var restrictions: [String]
    
    //变量属性：详情介绍
    var description: String

    //计算属性：通过 name 属性生成图片资源名
    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    //计算属性：通过 mainImage 属性生成缩图图资源名
    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }

    //静态属性：创建测试数据，不会被打包进最终App
    #if DEBUG
    static let example = MenuItem(
        id: UUID(),
        name: "Maple French Toast",
        photoCredit: "Joseph Gonzalez",
        price: 6,
        restrictions: ["G", "V"],
        description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…"
    )
    #endif
    
}
