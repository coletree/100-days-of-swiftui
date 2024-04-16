//
//  ShapeDemoTwoView.swift
//  Drawing
//
//  Created by coletree on 2024/4/16.
//

import SwiftUI

struct ShapeDemoTwoView: View {
    var body: some View {
        
        
        VStack {
            
            Text("Hello, World!")
            
            Text("Hello World")
                .frame(width: 300, height: 100)
                .background(.red)
            
            Text("Hello World")
                .frame(width: 300, height: 100)
                .border(.red, width: 10)
            
            Text("Hello World")
                .frame(width: 300, height: 100)
                .background(Image("example"))
                .clipped()
            
            Text("Hello World")
                .frame(width: 300, height: 100)
                //.border(ImagePaint(image: Image("example"), scale: 0.4), width: 20)
                .border(ImagePaint(
                            image: Image("example"),
                            sourceRect: CGRect(x: 0, y: 0.2, width: 0.2, height: 0.5),
                            scale: 1
                          ),width: 30)
            
            Capsule()
                .strokeBorder(ImagePaint(image: Image("example"), scale: 0.1), lineWidth: 20)
                .frame(width: 300, height: 200)
            
        }
        
        
        
        
    }
}

#Preview {
    ShapeDemoTwoView()
}
