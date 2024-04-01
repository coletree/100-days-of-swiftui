//
//  ExpenseItem.swift
//  iExpense
//
//  Created by coletree on 2024/1/4.
//
import Foundation
import SwiftData


// 单笔消费模型
@Model
class ExpenseItem: Identifiable{

    var name: String
    var type: String
    var amount: Int
    
    init(name: String, type: String, amount: Int) {
        self.name = name
        self.type = type
        self.amount = amount
    }
    
}
