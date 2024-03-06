//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//

import SwiftUI

struct ResortDetailsView: View {
    
    
    //MARK: - 属性
    let resort: Resort
    
    //度假村的大小存储为 1 到 3 之间的值，但实际上我们想使用“Small”、“Average”和“Large”来代替。
    //因此将创建两个计算属性： size 和 price
    var size: String {
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    
    //至于 price 属性，可以利用与【项目17】中创建示例卡片相同的重复/计数初始值设定项： String(repeating:count:)
    //通过将子字符串重复一定次数来创建新字符串
    var price: String {
        String(repeating: "$", count: resort.price)
    }
    
    
    //MARK: - 视图
    var body: some View {
        Group {
            VStack {
                Text("Size")
                    .font(.caption.bold())
                Text(size)
                    .font(.title3)
            }
            VStack {
                Text("Price")
                    .font(.caption.bold())
                Text(price)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
        
    }
    
    
}





//MARK: - 预览
#Preview {
    ResortDetailsView(resort: Resort.example)
}
