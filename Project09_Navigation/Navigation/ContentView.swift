//
//  ContentView.swift
//  Navigation
//
//  Created by coletree on 2024/3/26.
//

import SwiftUI




struct ContentView: View {


    //MARK: - 属性
    
    //@State private var pathStore = PathStore()
    
    @State private var pathStore = PathStore()
    
    
    
    
    //MARK: - 视图
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            
            ScrollView{
                IntDetailView(value: 0, path: $pathStore.path)
                    //识别整数传入值
                    .navigationDestination(for: Int.self) {
                        i in
                        IntDetailView(value: i, path: $pathStore.path)
                    }
                StringDetailView(value: "1", path: $pathStore.path)
                    //识别字符串的传入值
                    .navigationDestination(for: String.self) {
                        i in
                        StringDetailView(value: i, path: $pathStore.path)
                    }
            }
            
            .navigationTitle("Title goes here")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThickMaterial)
            .toolbarColorScheme(.dark)
            //.toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("100") {
                        pathStore.path.append(100)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("String") {
                        pathStore.path.append("1_000_000")
                    }
                }
            }
            
        }
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}



//MARK: - 预览
#Preview {
    ContentView()
}
