//
//  TabViewDomeView.swift
//  HotProspects
//
//  Created by coletree on 2024/4/8.
//

import SwiftUI

struct TabViewDomeView: View {
    
    
    
    var body: some View {
        
        TabView {
                    Text("First Tab")
                        .tabItem {
                            Image(systemName: "1.square.fill")
                            Text("First")
                        }
                        .tag(1)
                        .toolbarBackground(.hidden, for: .tabBar)
                    Text("Second Tab")
                        .tabItem {
                            Image(systemName: "2.square.fill")
                            Text("Second")
                        }
                        .padding(.top, -20)
                        .tag(2)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(Color.orange.opacity(0.8), for: .tabBar)
                    Text("Third Tab")
                        .tabItem {
                            Image(systemName: "3.square.fill")
                            Text("Third")
                        }
                        .padding(.top, -20)
                        .tag(3)
                }
        
    }
}



#Preview {
    TabViewDomeView()
}
