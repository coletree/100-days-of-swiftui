//
//  SkiDetailsView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//

import SwiftUI


/*
向此屏幕添加更多详细信息 - 度假村有多大、大致成本是多少、高度以及雪有多深。
虽然可以将所有这些放入 ResortView 中的单个 HStack 中，但这限制了我们将来可以做的事情。
因此，将它们分为两个视图：一个用于度假村信息（价格和大小），另一个 SkiDetailsView 用于滑雪信息（海拔和雪深）。
*/



struct SkiDetailsView: View {
    
    //MARK: - 属性
    let resort: Resort

    
    
    
    //MARK: - 视图
    var body: some View {
        
        Group {
            
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                Text("\(resort.elevation)m")
                    .font(.title3)
            }

            VStack {
                Text("Snow")
                    .font(.caption.bold())
                Text("\(resort.snowDepth)cm")
                    .font(.title3)
            }
        }
        //为 Group 视图指定最大框架宽度 .infinity 实际上不会影响组本身，因为它对布局没有影响。
        //但是它确实会传递到其子视图，这意味着它们将自动水平展开
        .frame(maxWidth: .infinity)
        
    }
    
    
    
}





//MARK: - 预览
#Preview {
    SkiDetailsView(resort: Resort.example)
}
