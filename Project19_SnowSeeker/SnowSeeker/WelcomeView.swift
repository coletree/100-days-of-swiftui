//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//

import SwiftUI




struct WelcomeView: View {
    
    //MARK: - 属性
    
    
    
    
    //MARK: - 视图
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu; \n swipe from the left edge to show it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    
    
    //MARK: - 方法
    
    
    
    
    
}


//MARK: - 其他






//MARK: - 预览
#Preview {
    WelcomeView()
}
