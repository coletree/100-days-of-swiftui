//
//  Bundle-Decodable.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//

import Foundation


/*
将从存储在应用程序包中的 JSON 文件加载度假村数组
这意味着可以重复使用为项目 8 编写的相同代码（Bundle-Decodable.swift 扩展）
*/


extension Bundle {
    
    func decode<T: Decodable>(_ file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
        
    }
    
}
