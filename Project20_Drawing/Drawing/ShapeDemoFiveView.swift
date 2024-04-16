//
//  ShapeDemoFiveView.swift
//  Drawing
//
//  Created by coletree on 2024/4/16.
//

import SwiftUI




struct ShapeDemoFiveView: View {
    @State private var insetAmount = 50.0
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                        insetAmount = Double.random(in: 10...90)
                }
            }
    }
}



struct Trapezoid: Shape {
    
    //加上这个就有动画了
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }
    
    var insetAmount: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
   }
}


#Preview {
    ShapeDemoFiveView()
}
