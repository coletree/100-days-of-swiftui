//
//  DetailView.swift
//  Navigation
//
//  Created by coletree on 2024/3/26.
//

import SwiftUI




struct StringDetailView: View {
    
    
    //MARK: - 属性
    var value: String

    @Binding var path: NavigationPath
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationLink("Go to Random String \(value)", value: String(Int.random(in: 1...1000)))
            .padding(100)
            .background(.red.opacity(0.5))
            .navigationTitle("String: \(value)")
            .toolbar {
                Button("Home") {
                    //path.removeAll()
                    path = NavigationPath()
                }
            }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}



