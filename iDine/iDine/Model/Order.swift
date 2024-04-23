//
//  Order.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//


import Observation
import SwiftUI




//MARK: - 可观察类 Order
@Observable
class Order{
    
    //变量属性：定义一个 MenuItem 数组
    var items = [MenuItem]()

    //计算属性：计算总金额
    var total: Int {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0
        }
    }

    //方法：添加 MenuItem，就是往数组中增加一个元素
    func add(item: MenuItem) {
        items.append(item)
    }

    //方法：删除 MenuItem，找到元素在数组中的索引，然后删掉
    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
}
