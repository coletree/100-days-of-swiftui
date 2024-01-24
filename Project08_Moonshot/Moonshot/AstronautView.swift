//
//  AstronautView.swift
//  Moonshot
//
//  Created by coletree on 2023/12/13.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut

    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("picture of \(astronaut.name)")

                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}




#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    return AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}


//#Preview {
//    AstronautView()
//}
