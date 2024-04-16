//
//  ArrowDemoView.swift
//  Drawing
//
//  Created by coletree on 2024/4/16.
//

import SwiftUI



struct ArrowDemoView: View {
    
    
    @State var amountOne: Double = 40.0
    @State var amountTwo: Double = 30.0
    @State var lineWidth: Double = 4.0
    
    
    var body: some View {
        
        VStack {
            
            Arrow(insetAmount: amountOne, insetAmount2: amountTwo)
                .fill(.blue)
                .stroke(.red, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .frame(width: 200, height: 200)
                .onTapGesture {
                    withAnimation(.linear(duration: 1)) {
                        amountOne = Double.random(in: 10...90)
                        amountTwo = Double.random(in: 10...90)
                        lineWidth = Double.random(in: 1...30)
                    }
                }
            
        }
            
        
    }
    
}




struct Arrow: Shape {
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(Double(insetAmount), Double(insetAmount2))
        }
        set {
            insetAmount = newValue.first
            insetAmount2 = newValue.second
        }
    }
    
    var insetAmount: Double
    var insetAmount2: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: insetAmount))
        path.addLine(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount2, y: insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount2, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount2, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount2, y: insetAmount))
        path.addLine(to: CGPoint(x: 0, y: insetAmount))
        return path
    }
    
}




#Preview {
    ArrowDemoView()
}
