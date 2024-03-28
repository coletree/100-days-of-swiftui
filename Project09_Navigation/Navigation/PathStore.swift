//
//  PathStore.swift
//  Navigation
//
//  Created by coletree on 2024/3/26.
//

import Foundation
import SwiftUI




//MARK: - 路径数据为普通数组
@Observable
class PathStore2 {
    var path: [Int] {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Int].self, from: data) {
                path = decoded
                return
            }
        }

        // Still here? Start with an empty path.
        path = []
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(path)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}





//MARK: - 路径数据为NavigationPath
@Observable
class PathStore {
    
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        //其次，在初始化器中解码 JSON 时，需要解码为特定类型，然后使用解码后的数据创建一个新的 NavigationPath
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        // Still here? Start with an empty path.
        path = NavigationPath()
    }

    func save() {
        
        //第三，如果解码失败，我们应该将一个新的空 NavigationPath 实例分配给初始化程序末尾的 path 属性：
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
