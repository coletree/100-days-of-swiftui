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
    
    //该方法只接受一个参数 file，是字符串类型
    func decode<T: Codable>(_ file: String) -> T {
        
        //首先，根据传入的 file 参数，查找 Bundle 中的该文件的 URL 地址
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        //然后，传入以上 URL ，将文件加载到 data 对象中
        //因为 Codable 使用 Data ，我们将使用 Data(contentsOf:)，它的工作方式与 String(contentsOf:) 相同
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        //声明一个解码器
        let decoder = JSONDecoder()
        
        //解码策略设置
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        //最后，通过解码器解码上面的 data 数据，将其转换成 T.self 类型
        //[String: Astronaut]这里的字典结构，是要和JSON文件中的保持一致的结构，不能改。
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
    
}


//有了该方法后，在想要调用的地方就可以直接：
//let 常量 = Bundle.main.decode("filename.json")
