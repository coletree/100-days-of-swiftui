//
//  ShapeDemoThreeView.swift
//  Drawing
//
//  Created by coletree on 2024/4/16.
//

import SwiftUI





struct ShapeDemoThreeView: View {
    
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
    
}



//我们将创建一个颜色循环视图，以一系列颜色渲染同心圆。结果看起来像径向渐变，
//但我们将添加两个属性以使其更加可定制：一个控制应绘制多少个圆圈，一个控制颜色循环: 它将能够移动渐变周围的开始和结束颜色。
struct ColorCyclingCircle: View {
    
    var amount = 0.0
    var steps: Int = 100
    
    var body: some View {
        ZStack {
            ForEach(0 ..< steps) {
                value in
                Circle()
                    .inset(by: Double(value))
                    //.strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}


#Preview {
    ShapeDemoThreeView()
}
