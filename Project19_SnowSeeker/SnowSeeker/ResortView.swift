//
//  ResortView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//


import SwiftUI


/*
ResortView 布局非常简单 – 只不过是一个滚动视图、一个 VStack 、一个 Image 和一些 Text 。
唯一有趣的部分是将使用 resort.facilities.joined(separator: ", ") 获取单个字符串，
将度假村的设施显示为单个文本视图。
*/


struct ResortView: View {
    
    
    //MARK: - 属性
    
    //常量属性：resort 数据，等待传入
    let resort: Resort
    
    //环境属性：
    @Environment(\.horizontalSizeClass) var sizeClass
    //@Environment(\.verticalSizeClass) var sizeClass

    
    
    //MARK: - 视图
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0){
                
                //顶部图片
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                
                //两个子视图，在不同的 size class 下的两种布局
                HStack {
                        //如果横向空间 horizontalSizeClass == 紧凑，则
                    if sizeClass == .compact {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    }
                        //如果横向空间不等于紧凑，则
                        else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))

                //详细介绍
                Group{
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)
                    
                    Text(resort.facilities, format: .list(type: .and))
                        .padding(.vertical)

                    Text(resort.facilities.joined(separator: ", "))
                        .padding(.vertical)
                    
                    Text(resort.facilities, format: .list(type: .and))
                        .padding(.vertical)
                    
                    Text(resort.facilities, format: .list(type: .or))
                        .padding(.vertical)
                    
                }
                .padding()
                
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}





//MARK: - 预览
#Preview {
    ResortView(resort: Resort.example)
}
