//
//  Order.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/22.
//

import Foundation

//在进入UI之前，需要首先定义数据模型。我们将有一个类来存储所有数据，这些数据将从一个屏幕传递到另一个屏幕。这意味着应用程序中的所有屏幕共享相同的数据。
//目前这个类不需要很多属性：
//1.蛋糕的类型，加上所有可能选项的静态数组。
//2.用户想要订购多少个蛋糕。
//3.用户是否想要提出特殊请求，这将在我们的 UI 中显示或隐藏额外的选项。
//4.用户是否想要在蛋糕上加额外的糖霜。
//5.用户是否想在蛋糕上添加糖粉。

//其中每一个都需要在更改时更新 UI，这意味着我们需要确保该类使用 @Observable 宏


@Observable
class Order : Codable {

    
    //MARK: - 订单基本属性：对observable的类，要嵌套一个 Enum 符合 CodingKey 协议，以便可以正确编码
    enum CodingKeys: String, CodingKey {
        case _typeIndex = "typeIndex"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _userAddress = "userAddress"
//        case _name = "name"
//        case _city = "city"
//        case _streetAddress = "streetAddress"
//        case _zip = "zip"
    }
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    var typeIndex = 0
    var quantity = 3
    var specialRequestEnabled = false {
        willSet {
            if newValue == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    
    //MARK: - 计算属性：用于计算一个订单的费用
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(typeIndex) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }

    
    //MARK: - 订单的地址数据。一旦发生赋值，就会触发保存到UserDefault
    var userAddress = Address() {
        didSet{
            guard let encoded = try? JSONEncoder().encode(oldValue) else {
                print("编码地址数据失败")
                return
            }
            UserDefaults.standard.set(encoded, forKey: "UserAddress")
        }
    }

    
}
