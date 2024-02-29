//
//  SwiftUIView.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/27.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            Text("Hello, World!")
            Image(.avatar)
                .resizable(resizingMode: .tile)
                .aspectRatio(contentMode: .fill)
                .frame(width: 800, height: 1000, alignment: .center)
                .ignoresSafeArea(.all)
            
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SwiftUIView()
}
