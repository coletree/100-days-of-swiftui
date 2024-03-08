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

    //属性：字典，储存每个名称对应的图片名
    private let icons = [
        "Accommodation": "house",
        "Beginners": "1.circle",
        "Cross-country": "map",
        "Eco-friendly": "leaf.arrow.circlepath",
        "Family": "person.3"
    ]
    
    //属性：字典，储存每个名称对应的说明文案
    private let descriptions = [
        "Accommodation": "This resort has popular on-site accommodation.",
        "Beginners": "This resort has lots of ski schools.",
        "Cross-country": "This resort has many cross-country ski routes.",
        "Eco-friendly": "This resort has won an award for environmental friendliness.",
        "Family": "This resort is popular with families."
    ]

    //计算属性：根据名称，从图标字典中读取图片，并返回视图
    var icon: some View {
        if let iconName = icons[name] {
            return Image(systemName: iconName)
                //对图像使用了 accessibilityLabel() 修饰符，以确保它在 VoiceOver 中正常工作
                .accessibilityLabel(name)
                .foregroundColor(.secondary)
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
    
    //计算属性：根据名称，从说明字典中读取文案，并返回视图
    var description: String {
        if let message = descriptions[name] {
            return message
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
    
    
}
