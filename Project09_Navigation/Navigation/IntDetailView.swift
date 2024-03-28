//
//  DetailView.swift
//  Navigation
//
//  Created by coletree on 2024/3/26.
//

import SwiftUI




struct IntDetailView: View {
    
    
    //MARK: - 属性
    var value: Int

    @Binding var path: NavigationPath
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationLink("Go to Random Number \(value)", value: Int.random(in: 1...1000))
            .padding(100)
            .background(.red.opacity(0.5))
            .navigationTitle("Number: \(value)")
            .toolbar {
                Button("Home") {
                    //path.removeAll()
                    path = NavigationPath()
                }
            }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}



