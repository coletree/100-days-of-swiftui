//
//  ContentView.swift
//  AccessibilitySandbox
//
//  Created by coletree on 2024/1/23.
//

import SwiftUI



struct ContentView: View {
    
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]
    
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]

    @State private var selectedPicture = Int.random(in: 0...3)
    
    @State private var value = 10

    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
            .accessibilityLabel(labels[selectedPicture])
        VStack(spacing: 20) {
            Text("Value: \(value)")
            Button("Increment") {
                value += 1
            }
            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Hello")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction {
                direction in
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled.")
            }
        }
    }
}



#Preview {
    ContentView()
}
