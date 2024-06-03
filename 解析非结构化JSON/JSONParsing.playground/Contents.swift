import UIKit
import SwiftUI



/// json 常量：非结构化的 JSON 示例
let json = """
[
    {
        "name": "Taylor Swift",
        "company": "Taytay Inc",
        "age": 26,
        "address": {
            "street": "555 Taylor Swift Avenue",
            "city": "Nashville",
            "state": "Tennessee",
            "gps": {
                "title": "newTitle",
                "lat": 36.1868667,
                "lon": -87.0661223
            }
        }
    },
    {
        "title": "1989",
        "type": "studio",
        "year": "2014",
        "singles": 7
    },
    {
        "title": "Shake it Off",
        "awards": 10,
        "hasVideo": true
    }
]
"""


/// 定义 JSON 结构
// 添加动态成员查找 @dynamicMemberLookup
// 符合 RandomAccessCollection 协议
@dynamicMemberLookup
struct JSON: RandomAccessCollection {

    var value: Any?
    
    // MARK: - 处理基础类型。它会对值进行可选和非可选的转换，并转化为请求的任何类型
    // as? 是类型转换操作符，as? 是一种安全的类型转换。它尝试将前面类型转换为后面的类型
    // 如果转换成功，返回一个 Double 类型的值；如果转换失败，它返回 nil
    var optionalBool: Bool? {
        value as? Bool
    }

    var optionalDouble: Double? {
        value as? Double
    }

    var optionalInt: Int? {
        value as? Int
    }

    var optionalString: String? {
        value as? String
    }
    
    // 再添加对应的计算属性，充当非可选的等效项，用于设置默认值
    var bool: Bool {
        optionalBool ?? false
    }

    var double: Double {
        optionalDouble ?? 0
    }

    var int: Int {
        optionalInt ?? 0
    }

    var string: String {
        optionalString ?? ""
    }


    // MARK: - 处理数组和字典
    // 当要求将数据作为数组处理时，我们先将值转换为 Any 数组，随后使用 map 映射它，
    // 因此数组值实际上是使用该 Any 值的 JSON 类型的新实例。这使我们能够自由地查询数据
    var optionalArray: [JSON]? {
        let converted = value as? [Any]
        return converted?.map { JSON(value: $0) }
    }

    var optionalDictionary: [String: JSON]? {
        let converted = value as? [String: Any]
        return converted?.mapValues { JSON(value: $0) }
    }

    // 再添加对应的计算属性，充当非可选的等效项，用于设置默认值
    var array: [JSON] {
        optionalArray ?? []
    }
    
    var dictionary: [String: JSON] {
        optionalDictionary ?? [:]
    }


    // MARK: - 设置查询下标
    // 编写自定义下标（subscripts），以便可以直接将对象视为数组或字典，而不是总是使用 array 和 dictionary 访问器（accessors）
    // 在 Swift 中这些只是简单的下标，可以让它直接调用刚刚创建的属性。如果任一访问器都没有请求的值，将发回一个空值

    // 根据 index 值查询
    subscript(index: Int) -> JSON {
        optionalArray?[index] ?? JSON(value: nil)
    }

    // 根据 key 值查询
    subscript(key: String) -> JSON {
        optionalDictionary?[key] ?? JSON(value: nil)
    }
    
    // 支持动态成员查找的下标：作用与常规字典下标完全相同
    subscript(dynamicMember key: String) -> JSON {
        optionalDictionary?[key] ?? JSON(value: nil)
    }

    // 为了遵循 RandomAccessCollection 协议，必须提供 startIndex 和 endIndex 属性
    var startIndex: Int { array.startIndex }
    var endIndex: Int { array.endIndex }


    // MARK: - 设置初始化方法
    
    // 初始化方法1: 接受 字符串 参数，用 jsonObject 方法创建实例
    init(string: String) throws {
        let data = Data(string.utf8)
        value = try JSONSerialization.jsonObject(with: data)
    }
    
    // 初始化方法2: 接受 Any? 参数，直接创建实例
    init(value: Any?) {
        self.value = value
    }
    
}



/// 具体使用示例：
/// 使用 try 关键字：因为 JSONSerialization.jsonObject(with: data) 方法可能会抛出错误，这个初始化方法是个 throws 方法，在调用时也需要使用 try
let object = try JSON(string: json)

for item in object {
    
    // 打印本次迭代 item 元素的 title 键，如果没有就打印默认值
    print(item["title"].string)
    
    // 打印本次迭代 item 元素的 address 键中的 city 键的内容
    print(item["address"]["city"].string)
    
    // 用 optionalDouble：如果其中任何一个失败，整条线路都会自动失败。但它不会使代码崩溃，它只会像常规的可选代码一样返回 nil
    if let latitude = item["address"]["gps"]["lat"].optionalDouble {
        print("Latitude is \(latitude)")
    }
    
    // 用 double：肯定会有值
    print("Latitude is \(item["address"]["gps"]["lat"].double)")
    
    // 使用动态成员查找
    if let latitude = item.address.gps.lat.optionalDouble {
        print("Latitude is \(latitude)")
    }
    
    // 换行
    print("\n")
    
}


