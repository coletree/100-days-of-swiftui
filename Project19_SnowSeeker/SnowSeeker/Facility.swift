//
//  Facility.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//

import Foundation
import SwiftUI


/*
 首先，需要一种方法将“住宿”等设施名称转换为可以显示的图标。
 尽管目前这种情况只会发生在 ResortView 中，但此功能正是我们项目中其他地方应该提供的功能。
 因此，我们将创建一个新的结构来为我们保存所有这些信息。
*/


struct Facility: Identifiable {
    
    let id = UUID()
    var name: String

    private let icons = [
        "Accommodation": "house",
        "Beginners": "1.circle",
        "Cross-country": "map",
        "Eco-friendly": "leaf.arrow.circlepath",
        "Family": "person.3"
    ]

    //计算属性：
    var icon: some View {
        if let iconName = icons[name] {
            return Image(systemName: iconName)
                .accessibilityLabel(name)
                .foregroundColor(.secondary)
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
    
}
