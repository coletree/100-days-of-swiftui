//
//  SmartFilterRow.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import SwiftUI


struct SmartFilterRow: View {
    
    
    //MARK: - 属性
    
    var filter: Filter
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //导航链接附加值为过滤器
        NavigationLink(value: filter) {
            Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    SmartFilterRow(filter: Filter.all)
}
