//
//  CoverFlowView.swift
//  LayoutAndGeometry
//
//  Created by coletree on 2024/4/11.
//

import SwiftUI


struct CoverFlowView: View {
    var body: some View {
        
        VStack {
            
            //第1种：使用 GeometryReader 的方式
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(1..<20) {
                        num in
                        GeometryReader {
                            proxy in
                            Text("Number \(num)")
                                .font(.largeTitle)
                                .padding()
                                .background(.red)
                                .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: 200, height: 200)
                    }
                }
            }
            
            //第2种：使用 visualEffect 的方式
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(1..<20) { 
                        num in
                        Text("Number \(num)")
                            .font(.largeTitle)
                            .padding()
                            .background(.blue)
                            .frame(width: 200, height: 200)
                            .visualEffect {
                                content, proxy in
                                content
                                    .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            
            
        }
    }
}




#Preview {
    CoverFlowView()
}
