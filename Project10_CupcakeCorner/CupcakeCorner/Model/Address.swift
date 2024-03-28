//
//  Address.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/25.
//

import Foundation


@Observable
class Address : Codable {
    
    
    //MARK: - 地址属性：基本的地址属性
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    
    //MARK: - 计算属性：用于验证一个订单数据是否符合最低要求
    var hasValidAddress: Bool {

        let nameTrim = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let streetAddressTrim = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityTrim = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipTrim = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if nameTrim.isEmpty || streetAddressTrim.isEmpty || cityTrim.isEmpty || zipTrim.isEmpty {
            return false
        }
        
        return true
    }
    
    
    //MARK: - 初始化函数: 从UserDefaults中获取值，填入具体属性
    init() {
        guard let getAddress = UserDefaults.standard.data(forKey: "UserAddress") else {
            print("什么地址都没获取到")
            return
        }

        do {
            let userAddress = try JSONDecoder().decode(Address.self, from: getAddress)
            name = userAddress.name
            streetAddress = userAddress.streetAddress
            city = userAddress.city
            zip = userAddress.zip
        } catch {
            print("地址获取错误")
        }
    }
    
    
}
