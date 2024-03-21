//
//  GestureAnimation.swift
//  Animations
//
//  Created by coletree on 2024/3/20.
//

import SwiftUI


struct GestureAnimation: View {
    
    
    //MARK: - 属性
    
    //状态属性：存储拖拽的距离
    @State private var dragAmount = CGSize.zero
    
    
    //MARK: - 视图
    var body: some View {
        
        
        LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(.rect(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in dragAmount = .zero }
            )
            .animation(.bouncy, value: dragAmount)
        
    }
    
    
}



//MARK: - 预览
#Preview {
    GestureAnimation()
}

