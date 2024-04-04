//
//  Location.swift
//  BucketList
//
//  Created by coletree on 2024/1/16.
//

import Foundation
import MapKit


//创建位置类型的基本定义，需要符合以下协议：
//1. Identifiable ，因此我们可以在地图中创建许多位置标记
//2. Codable ，这样我们就可以轻松加载和保存地图数据
//3. Equatable ，因此我们可以在一系列位置中找到一个特定位置


//就其包含的数据而言，我们将为每个位置提供名称和描述，以及纬度和经度。还需要添加一个唯一标识符，以便 SwiftUI 乐意从动态数据创建它们
struct Location: Codable, Equatable, Identifiable {
    
    // 这里把 id 从常量改成变量，方便后面创建新对象
    var id: UUID
    var name: String
    var description: String
    
    //单独存储纬度和经度，可以提供了开箱即用的 Codable 协议
    var latitude: Double
    var longitude: Double
    
    //把创建 CLLocationCoordinate2D 的工作放到数据结构中，减少SwiftUI的复杂度，也符合解藕原则。
    //但符合 codable 协议么？ CLLocationCoordinate2D 结构不符合 Codable ，因此您需要手动添加它。
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //鼓励每个人在构建与 SwiftUI 一起使用的自定义数据类型时，添加一个具体实例的静态属性！这使得预览变得更加容易
    //另外，可以将 static let example 行用 #if DEBUG 和 #endif 括起来，以避免将其内置到您的 App Store 版本中。
    #if DEBUG
    static let example = Location(
        id: UUID(),
        name: "Buckingham Palace",
        description: "Lit by over 40,000 lightbulbs.",
        latitude: 51.501,
        longitude: -0.141
    )
    #endif
    
}


