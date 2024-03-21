//
//  TransitionView.swift
//  Animations
//
//  Created by coletree on 2024/3/20.
//

import SwiftUI

struct TransitionView: View {
    
    //MARK: - 属性
    
    //状态属性：存储拖拽的距离
    @State private var isShowingRed = false
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(
                        AnyTransition.offset(x: -600, y: 0)
                            .combined(with: .scale)
                            .combined(with: .opacity)
                    )
            }
        }
    }
    
    
}



//MARK: - 预览
#Preview {
    TransitionView()
}

