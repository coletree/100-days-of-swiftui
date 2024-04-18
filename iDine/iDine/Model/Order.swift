//
//  Order.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

class Order {
    
    //MenuItem 数组
    var items = [MenuItem]()

    //计算属性：计算总金额
    var total: Int {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0
        }
    }

    //添加一个 MenuItem
    func add(item: MenuItem) {
        items.append(item)
    }

    //删除一个 MenuItem
    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
}
