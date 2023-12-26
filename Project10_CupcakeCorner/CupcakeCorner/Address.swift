//
//  Address.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/25.
//

import Foundation


@Observable
class Address : Codable {
    
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
    
    //计算属性：用于验证一个订单数据是否符合最低要求
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
    
}
