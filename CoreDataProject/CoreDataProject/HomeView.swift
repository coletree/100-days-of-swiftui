//
//  HomeView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

import SwiftUI




struct HomeView: View {
    
    
    //MARK: - 属性
    
    @Environment(\.managedObjectContext) var moc
    
    
    
    //MARK: - 视图
    var body: some View {
        
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "person.3")
                }
            CoreDataDemoOneView()
                .tabItem {
                    Label("One", systemImage: "checkmark.circle")
                }
            CoreDataDemoTwoView()
                .tabItem {
                    Label("Two", systemImage: "questionmark.diamond")
                }
            CoreDataDemoThreeView()
                .tabItem {
                    Label("Three", systemImage: "person.crop.square")
                }
        }
        
    }
    
    
    
    
}






#Preview {
    HomeView()
}
