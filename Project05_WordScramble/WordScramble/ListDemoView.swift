//
//  ListDemoView.swift
//  WordScramble
//
//  Created by coletree on 2024/3/19.
//

import SwiftUI

struct ListDemoView: View {
    
    
    //MARK: - 属性
    var greeting = "Hello, playground"

    struct Restaurant: Identifiable {
        var id = UUID()
        var name: String
        var image: String
    }

    //构建数组
    var restaurants = [
            Restaurant(name:"xxxx1", image:"1xxxxxx"),
            Restaurant(name:"xxxx2", image:"2xxxxxx"),
            Restaurant(name:"xxxx3", image:"3xxxxxx")
    ]
    
    
    //MARK: - 视图
    var body: some View {
        //读取
        //这时传入List的不是一个范围了，而是一个数组，并且是用它内部的id属性作为唯一标识
        List(restaurants, id: \.id){
            //传入的是数组，所以循环的是单个数组内的元素
            restaurant in
            //所以取值是也是单个元素的某属性，不需要索引值
            HStack(spacing: 20) {
                Image(restaurant.image)
                Spacer()
                Text(restaurant.name)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 40)
            .background(.white)
            .clipShape(.rect(cornerRadius: 10), style: FillStyle())
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0.0, y: 10.0)
            .padding(.bottom, 10)
                
        }
        .listStyle(.plain)
    }
    
    
}








#Preview {
    ListDemoView()
}
