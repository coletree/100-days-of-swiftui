//
//  ListSelectionDemoView.swift
//  HotProspects
//
//  Created by coletree on 2024/4/7.
//

import SwiftUI




struct ListSelectionDemoView: View {
    
    @State private var selection: String?
    
    @State private var selection2 = Set<String>()
    
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    
    
    
    var body: some View {
        
        List(users, id: \.self, selection: $selection2) {
            user in
            Text(user)
        }
        
        VStack{
            
            //如果 selection 不是 nil
            if let selection {
                Text("You selected \(selection)")
            }
            
            if selection2.isEmpty == false {
                Text("You selected \(selection2.formatted())")
            }
            
        }
        
        EditButton()

        
    }
    
}





#Preview {
    ListSelectionDemoView()
}
