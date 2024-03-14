//
//  Favorites.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/6.
//

import Foundation
import SwiftUI


/*
需要用户可以收藏具体的地点：
1.创建一个新的 Favorites 类，其中包含用户喜欢的度假村 ID 的集合
2.提供 add() 、 remove() 和 contains() 方法来操作数据，向 SwiftUI 发送更新通知，同时保存对 UserDefaults 的任何更改。
3.将 Favorites 类的实例注入环境中。
4.添加一些新的 UI 来调用适当的方法。

Swift 的 set 集合已经包含用于添加、删除和检查元素的方法，
但我们将围绕它添加自己的方法，以便我们可以使用 objectWillChange 通知 SwiftUI 发生了更改，并调用 save() 方法，以便储存用户的更改。
这意味着我们可以使用 private 访问控制，来标记收藏夹集，这样就不会意外绕过我们的方法，或者错过保存。
*/



//创建类：保存所有收藏的地点。该类遵循 ObservableObject 协议
class Favorites: ObservableObject{
    
    //用户收藏的度假村集合 set，集合里的数据类型是字符串，后面会储存度假村的 ID
    private var resorts: Set<String>

    //用于在 UserDefaults 里读写的 Key
    private var saveKey = "Favorites"

    
    //读取保存的数据
    init() {
        // load our saved data
        if let data = UserDefaults.standard.data(forKey: saveKey){
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data){
                resorts = decoded
                return
            }
        }
        resorts = []
    }
    

    //方法：判断集合中是否包含有传入的度假村对象，如果包含则返回 true
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    //方法：往集合里添加度假村对象，然后保存变更后的数据，更新所有视图
    func add(_ resort: Resort) {
        //该方法会在 resorts 集合发生更改时发送更新，以便视图可以相应地进行更新。
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    //方法：从集合里移除度假村对象，然后保存变更后的数据，更新所有视图
    func remove(_ resort: Resort) {
        //这句什么意思？
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    //方法：保存方法。在插入和删除对象时会被调用。
    func save() {
        if let data = try? JSONEncoder().encode(resorts){
            UserDefaults.standard.set(data, forKey: saveKey)
        }
        //UserDefaults.standard.synchronize()方法在iOS 7之后就不再需要手动调用了，因为系统会自动进行同步。
        //UserDefaults.standard.synchronize()
    }
    
}



