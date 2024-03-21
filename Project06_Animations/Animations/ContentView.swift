//
//  ContentView.swift
//  Animations
//
//  Created by coletree on 2024/3/20.
//

import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    @State private var animationAmount = 1.0

    @State private var enabled = true
    
    
    //MARK: - 视图
    var body: some View {
        
        //因为添加了一些非视图代码，所以需要在 VStack 之前添加 return ，以便 Swift 知道哪一部分是被发送回的视图
        //这行代码主要让你看到，关联值后绑定动画，它还是从1.0变到2.0，并不会产生1.1，1.2... 所以给布尔值绑定动画也是可以的
        print(animationAmount)

        return VStack {
            
            Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)
            
            Spacer()
            
            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
            //.animation(.easeIn, value: animationAmount)
            
            Spacer()
            
            Button("Tap Me") {
                enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? .blue : .red)
            ////如果不加这一行，则所有的样式属性都会应用后面的弹簧动画。但我们想颜色变化没有动画。如果没有多个 animation() 修饰符，这种控制不可能实现
            .animation(.default, value: enabled)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: enabled ? 80 : 0))
            .animation(.spring(duration: 2, bounce: 0.6), value: enabled)
        }
        
    }
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
