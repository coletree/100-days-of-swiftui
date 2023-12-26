//
//  OtherView.swift
//  GuessTheFlag
//
//  Created by coletree on 2023/11/20.
//

import SwiftUI

struct OtherView: View {
    
    @State private var showingAlert = false
    
    var body: some View {
        
        ZStack {
            
            Color.indigo
                .background(.ultraThinMaterial)
            
            VStack(spacing: 10) {

                HStack(alignment: .top, spacing: 10){
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.orange)
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.green)
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.blue)
                }
                
                HStack(alignment: .top, spacing: 10){
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.orange)
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.green)
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.blue)
                }
                
                HStack(alignment: .top, spacing: 10){
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.orange)
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.green)
                    Rectangle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.blue)
                }
                
            }
            
            Color.clear
                //.background(.regularMaterial)
                //.background(.thickMaterial)
                //.background(.thinMaterial)
                //.background(.ultraThickMaterial)
                .background(.ultraThinMaterial)
            
            Button("Show Alert") {
                showingAlert = true
            }
            .alert("Important message", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please read this.")
            }
            
        }
        .ignoresSafeArea(.all)
        
        ZStack {
            VStack(spacing: 0) {
                Color.red
                Color.blue
            }

            Text("Your content")
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
            
//            Text("Your content")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .foregroundStyle(.white)
//                .background(.red.gradient)
        }
        
    }
}

#Preview {
    OtherView()
}
