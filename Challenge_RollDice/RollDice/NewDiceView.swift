//
//  NewDiceView.swift
//  RollDice
//
//  Created by coletree on 2024/7/19.
//

import SwiftUI




struct NewDiceView: View {

    @State private var numberOfPips: Int = 1

    var body: some View {
        VStack {
            Image(systemName: "die.face.\(numberOfPips)")
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(.black, .white)

            Button("Roll") {
                withAnimation {
                    numberOfPips = Int.random(in: 1...6)
                }
            }
            .buttonStyle(.bordered)
        }
    }
}





#Preview {
    NewDiceView()
}
