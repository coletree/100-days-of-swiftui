//
//  ExpenseItem.swift
//  iExpense
//
//  Created by coletree on 2023/12/8.
//

import Foundation


// 有一个结构体来表示单个费用项目
// 复杂数据归档，要遵循 Codable 协议
struct ExpenseItem: Identifiable, Codable {
    //id不会被解码，因为它是自动生成的。想要去掉警告，可以用 var
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}


// 还有一个类来存储所有这些项目的数组
@Observable
class Expenses {
    
    var items = [ExpenseItem]() {
        // 加上属性观察
        didSet {
            //提示：使用 JSONEncoder().encode() 意味着“创建一个编码器并使用它来编码某些内容”，这一切都一步完成，而不是先创建编码器然后再使用它
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
            itemsA = items.filter({
                (item: ExpenseItem) -> Bool in
                return item.type == "Personal"
            })
            itemsB = items.filter({
                (item: ExpenseItem) -> Bool in
                return item.type == "Business"
            })
        }
    }
    
    var itemsA = [ExpenseItem]()
    var itemsB = [ExpenseItem]()
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                itemsA = items.filter({
                    (item: ExpenseItem) -> Bool in
                    return item.type == "Personal"
                })
                itemsB = items.filter({
                    (item: ExpenseItem) -> Bool in
                    return item.type == "Business"
                })
                return
            }
        }

        items = []
        itemsA = []
        itemsB = []
    }
    
}
