//
//  ContentView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/2.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText = ""
    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]

    var body: some View {
        NavigationView {
            List(filteredNames, id: \.self) { 
                name in
                Text(name)
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Searching")
        }
    }

    var filteredNames: [String] {
        if searchText.isEmpty {
            return allNames
        } else {
            return allNames.filter { $0.contains(searchText) }
        }
    }
}



struct User: Identifiable {
    var id = "Taylor Swift"
}



#Preview {
    ContentView()
}
