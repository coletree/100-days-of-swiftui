//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by coletree on 2023/12/12.
//

import Foundation


//接下来要将 astronauts.json 转换为 Astronaut 实例的字典，
//这意味着我们需要使用 Bundle 查找文件的路径，将其加载到 Data ，并将其传递给 JSONDecoder 。
//以往我们是将其放入 ContentView 的方法中，在这里展示一种更好的方法：在 Bundle 上编写一个扩展来完成这一切。


extension Bundle {
    
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        //因为 Codable 使用 Data ，我们将使用 Data(contentsOf:)，它的工作方式与 String(contentsOf:) 相同
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        //[String: Astronaut]这里的字典结构，是要和JSON文件中的保持一致的结构，不能改。
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
    
}
