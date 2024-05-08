//
//  Bundle-Decodable.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/8.
//

import Foundation


//MARK: - 创建 Bundle 扩展

//它可以适用于任何类型的 JSON 数据，把它放入任何项目中即可以使用
//1. 支持从 App 的特定捆绑包 Bundle 中查找特定文件名，加载 JSON
//2. 支持将该文件加载到 Data 实例中
//3. 支持将该 Data 实例转换为特定类型的 Swift 对象，如果解码失败，则显示有用的出错提示

extension Bundle {
    
    func decode<T: Decodable>(
        _ file: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        // more code to come
    }
    
    
}
