//
//  ActivitiesData.swift
//  HabitTracking
//
//  Created by coletree on 2023/12/20.
//

import Foundation




//MARK: - 定义 Activity 结构体
//该结构体是单个习惯的模型，使其符合 Codable 、Identifiable
struct Activity: Codable, Identifiable, Hashable, Equatable{
    //属性包括: 数据源id、活动名称、活动说明、完成次数
    var id = UUID()
    var name: String
    var intro: String
    var count: Int
}




//MARK: - 定义 ActivitiesData 类
//该类是所有习惯的模型，主要是用一个数组来存储所有习惯对象

@Observable
class ActivitiesData{

    //属性：储存所有习惯的数组。当其值发生被设置时，会调用属性观察的 save 方法
    var activities: [Activity] {
        didSet {
            save()
        }
    }

    //初始化: 从 userDefaults 的 ActivitiesData 键中，解码数据到属性 activities
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Activities") {
            if let decodedItems = try? JSONDecoder().decode([Activity].self, from: savedItems) {
                activities = decodedItems
                return
            }
        }
        activities = [Activity]()
    }


    //其他方法：调用时会编码 activities 属性的数据，保存到 userDefaults 的 ActivitiesData 键中
    func save() {
        print("调用保存到 UserDefault")
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: "Activities")
            print("保存成功")
            print(UserDefaults.standard.data(forKey: "Activities") ?? "没有东西")
        }
    }

}
