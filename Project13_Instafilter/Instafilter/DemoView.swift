//
//  DemoView.swift
//  Instafilter
//
//  Created by coletree on 2024/4/1.
//

import SwiftUI

struct DemoView: View {
    
    @State private var blurAmount = 0.0 {
        didSet {
            print("New value is \(blurAmount)")
        }
    }

    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
        .padding()
    }

}


#Preview {
    DemoView()
}
