//
//  StateDemoView.swift
//  BucketList
//
//  Created by coletree on 2024/4/4.
//

import SwiftUI

struct StateDemoView: View {
    
    @State var number: Int
    
    var body: some View {
        VStack {
            Text("0 : \(number)")
            Button("+") { number += 1 }
        }
        .font(.title)
    }
    
    init(number: Int) {
        self.number = number + 1
    }
    
}



#Preview {
    StateDemoView(number: 8)
}
