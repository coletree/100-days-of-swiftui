//
//  ItemRow.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI


struct ItemRow2: View {

    
    //MARK: - 属性
    
    //常量属性：定义一个储存每种 restrictions 类型对应颜色的字典
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]
    
    //变量属性：等待传入一个 MenuItem 对象
    var item : MenuItem
    

    
    
    //MARK: - 视图
    var body: some View {
        
        HStack {
            Image(item.thumbnailImage)
                .clipShape(Circle())
                .overlay(Circle().stroke(.yellow, lineWidth: 2))
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text("$\(item.price)")
                
            }
            
            Spacer()
            
            ForEach(item.restrictions, id: \.self) {
                restriction in
                Text(restriction)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(colors[restriction, default: .black])
                    .clipShape(Circle())
                    .foregroundStyle(.white)
            }
            
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    ItemRow2(item: MenuItem.example)
}
