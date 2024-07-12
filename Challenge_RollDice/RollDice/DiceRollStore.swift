//
//  DiceRollStore.swift
//  RollDice
//
//  Created by coletree on 2024/7/10.
//

import Foundation




@Observable
class DiceRollStore {

    // 储存历史结果的数组
    var rolls: [DiceRoll] = []

    // UserDefaults 中保存历史结果的键
    private let saveKey = "DiceRolls"

    // 初始化方法中读取历史结果
    init() {
        load()
        print("数据读取成功")
    }

    // 新增一次结果
    func add(_ roll: DiceRoll) {
        rolls.append(roll)
        print("新增记录\(roll.result)")
        save()
    }

    // 将结果保存到 UserDefaults
    private func save() {
        if let encoded = try? JSONEncoder().encode(rolls) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
        load()
    }

    // 从 UserDefaults 读取历史结果
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey), let decoded = try? JSONDecoder().decode([DiceRoll].self, from: data) {
            rolls = decoded
        }
    }

    // 删除结果
    func deleteAll(){
        rolls = []
        save()
        load()
    }

}
