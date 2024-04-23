//
//  MainView.swift
//  iDine
//
//  Created by coletree on 2024/4/20.
//

import SwiftUI

struct MainView: View {
    
    
    
    //MARK: - 属性
    
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //视图：创建 Tab 视图
        TabView {
            
            ContentView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            
            OrderView()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
            
            FavoriteView()
                .tabItem {
                    Label("Favorite", systemImage: "heart.fill")
                }
            
        }
        
    }
    
    
    
    //MARK: - 方法
    
    
}




//MARK: - 预览
#Preview {
    MainView()
        .environment(Order())
        .environment(Favor())
}
