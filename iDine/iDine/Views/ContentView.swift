//
//  ContentView.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI






struct ContentView: View {
    
    
    //MARK: - 属性
    
    //常量：加载 JSON 数据
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //视图：导航视图
        NavigationStack {
            List {
                ForEach(menu, id: \.id){
                    section in
                    Section(section.name) {
                        ForEach(section.items) {
                            item in
                            NavigationLink(value: item) {
                                ItemRow2(item: item)
                            }
                        }
                        
                    }
                }
            }
            //目标视图：加到 List 外面的。使用了链接和目标视图分离，附加值为 MenuItem
            .navigationDestination(for: MenuItem.self) {
                item in
                ItemDetailView(item: item)
            }
            .navigationTitle("Menu")
            .listStyle(.grouped)
            //.listStyle(.insetGrouped)
            //.listStyle(.sidebar)

        }
        
        
    }
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
