//
//  NewDiceGroupView.swift
//  RollDice
//
//  Created by coletree on 2024/7/19.
//

import SwiftUI

struct NewDiceGroupView: View {

    @State private var numberOfDice: Int = 2

    var body: some View {
        VStack {
            Text("Dice Roller")
                .font(.largeTitle.lowercaseSmallCaps())

            HStack {
                ForEach(1...numberOfDice, id: \.description) { _ in
                    NewDiceView()
                }
            }

            HStack {
                Button("Remove Dice", systemImage: "minus.circle.fill") {
                    numberOfDice -= 1
                }
                .disabled(numberOfDice == 1)

                Button("Add Dice", systemImage: "plus.circle.fill") {
                    numberOfDice += 1
                }
                .disabled(numberOfDice == 5)
            }
            .padding()
            .labelStyle(.iconOnly)
            .font(.title)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appBackground)
        .tint(.white)
    }
}

#Preview {
    NewDiceGroupView()
}
