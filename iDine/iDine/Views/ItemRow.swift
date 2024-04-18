//
//  ItemRow.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI

struct ItemRow: View {

    
    //MARK: - 属性
    
    //常量：定义一个储存每种 restrictions 类型对应颜色的字典
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]
    
    //变量：等待传入一个 MenuItem 对象
    var item : MenuItem
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        
        HStack(alignment: .center, spacing: 20) {
            
            Image(item.thumbnailImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.top, 4)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title3)
                    .bold()
                Text(item.description)
                    .font(.caption)
                    .lineLimit(4)
            }
            
        }
        
        
    }
    
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    ItemRow(item: MenuItem.example)
}
