//
//  Favor.swift
//  iDine
//
//  Created by coletree on 2024/4/22.
//


import Foundation
import SwiftUI




//MARK: - 可观察类 favor
@Observable
class Favor{
    
    //变量属性：定义一个 MenuItem 数组
    var favorItems = [MenuItem]()

    //方法：添加 MenuItem，就是往数组中增加一个元素
    func add(item: MenuItem) {
        favorItems.append(item)
    }

    //方法：删除 MenuItem，找到元素在数组中的索引，然后删掉
    func remove(item: MenuItem) {
        if let index = favorItems.firstIndex(of: item) {
            favorItems.remove(at: index)
        }
    }
    
}
