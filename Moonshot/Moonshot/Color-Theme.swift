//
//  Color-Theme.swift
//  Moonshot
//
//  Created by coletree on 2023/12/12.
//

import Foundation
import SwiftUI

//这添加了两种新颜色，称为 darkBackground 和 lightBackground ，每种颜色都有红色、绿色和蓝色的精确值。
//但更重要的是，他们将它们放置在一个非常具体的扩展中，允许我们在 SwiftUI 需要 ShapeStyle 的任何地方使用这些颜色。

extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }

    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
