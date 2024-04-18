//
//  ItemDetailView.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI





struct ItemDetailView: View {
    
    //MARK: - 属性
    
    //变量：等待传入一个 MenuItem 对象
    var item : MenuItem
    
    
    //常量：定义一个储存每种 restrictions 类型对应颜色的字典
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]
    
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .bottomTrailing)  {
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()
                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(.black)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .offset(x: -5, y: -5)
            }
            
            Text(item.description)
                .padding()
            
            Spacer()
            
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    //加上这个可以预览 ItemDetailView 在导航堆栈中的情况
    NavigationStack {
        ItemDetailView(item: MenuItem.example)
    }
}
