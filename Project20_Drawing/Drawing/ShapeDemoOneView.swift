//
//  ShapeDemoOneView.swift
//  Drawing
//
//  Created by coletree on 2024/4/16.
//

import SwiftUI

//这里用几个旋转的椭圆花瓣创建一个花朵形状，每个椭圆围绕一个圆定位。这背后的数学原理相对简单，但有一个问题： CGAffineTransform 以弧度而不是度数来测量角度。如果您已经上学一段时间了，那么您至少需要知道的是：3.141 弧度等于 180 度，因此 3.141 弧度乘以 2 等于 360 度。 3.141 并不是巧合：实际值是数学常数 pi。


struct ShapeDemoOneView: View {
    
    
    //MARK: - 属性
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .stroke(.red, lineWidth: 1)
                //.fill(.red, style: FillStyle(eoFill: true))
            
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
        
    }
    
}



struct Flower: Shape {
    
    // How much to move this petal away from the center
    var petalOffset: Double = -20

    // How wide to make each petal
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()

        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)

            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))

            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))

            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)

            // add it to our main path
            path.addPath(rotatedPetal)
        }

        // now send the main path back
        return path
    }
    
}



#Preview {
    ShapeDemoOneView()
}
