//
//  ShapeDemoFourView.swift
//  Drawing
//
//  Created by coletree on 2024/4/16.
//

import SwiftUI



struct ShapeDemoFourView: View {
    
    
    @State private var amount = 0.0
    
    
    var body: some View {
        
        Image("example")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .saturation(amount)
            //.blur(radius: (1 - amount) * 20)
        
        Slider(value: $amount)
            .padding()
        
//        ZStack {
//            Image("example")
//            Rectangle()
//                .fill(.red)
//                .blendMode(.darken)
//        }
//        .frame(width: 100, height: 100)
//        .clipped()
        
//        VStack {
//            ZStack {
//                Circle()
//                    .fill(Color(red: 1, green: 0, blue: 0))
//                    .frame(width: 200 * amount)
//                    .offset(x: -50, y: -80)
//                    .blendMode(.screen)
//                
//                Circle()
//                    .fill(Color(red: 0, green: 1, blue: 0))
//                    .frame(width: 200 * amount)
//                    .offset(x: 50, y: -80)
//                    .blendMode(.screen)
//                
//                Circle()
//                    .fill(Color(red: 0, green: 0, blue: 1))
//                    .frame(width: 200 * amount)
//                    .blendMode(.screen)
//            }
//            .frame(width: 300, height: 300)
//            
//            Slider(value: $amount)
//                .padding()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        //.background(.black)
//        .ignoresSafeArea()
        
    }
    
}



#Preview {
    ShapeDemoFourView()
}
