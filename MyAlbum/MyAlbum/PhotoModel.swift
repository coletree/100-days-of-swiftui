//
//  PhotoModel.swift
//  MyAlbum
//
//  Created by coletree on 2024/1/27.
//

import Foundation
import SwiftData
import SwiftUI



struct Photo: Identifiable, Codable, Comparable{
    
    //MARK: - 属性
    var id = UUID()
    var title : String
    var imageData : Data
    var image : UIImage {
        return UIImage(data: imageData) ?? UIImage(resource: .coletree)
    }
    
    
    //MARK: - 方法
    //方法：Comparable 运算符重载，用于排序
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        lhs.title < rhs.title
    }
    
    
    //MARK: - 示例
    //在构建自定义数据类型时，添加一个具体实例的静态属性，这会使得预览变得更加容易
    //另外可以用 #if DEBUG 和 #endif 括起来，以避免将其内置到您的 App Store 版本中
    #if DEBUG
    static let example = Photo(
        id: UUID(),
        title: "Buckingham Palace",
        imageData: Data()
    )
    #endif
    
    
}
