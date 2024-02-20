//
//  ContentView.swift
//  HotProspects
//
//  Created by coletree on 2024/1/30.
//

import SwiftUI


struct ContentView: View {
    
    //MARK: - 属性
    
    //@State private var selection: String? = "Yuki"
    
    @State private var selection = Set<String>()
    
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    
    @State private var selectedTab = "One"
    
    @State private var output = ""
    
    @State private var backgroundColor = Color.red

    
    
    //MARK: - 视图
    
    var body: some View {
        

        TabView(selection: $selectedTab) {
            
            //Tab1
            Button("Show Tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")
            
            //Tab2
            VStack {
                Text(output)
                    .task {
                        await fetchReadings()
                    }
            }
            .tabItem {
                Label("Two", systemImage: "circle")
            }
            .tag("Two")
            
            
            //Tab3
            VStack {
                Image(.fishGreen)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .background(.black)
            }
            .tabItem {
                Label("Three", systemImage: "circle")
            }
            .tag("Three")
            
            
            //Tab4
            VStack {
                Text("Hello, World!")
                    .padding()
                    .background(backgroundColor)
                
                Text("Change Color")
                    .padding()
                    .contextMenu {
                        Button("Red", systemImage: "checkmark.circle.fill", role: .destructive) {
                            backgroundColor = .red
                        }
                        
                        Button("Green") {
                            backgroundColor = .green
                        }
                        
                        Button("Blue") {
                            backgroundColor = .blue
                        }
                    }
            }
            .tabItem {
                Label("Four", systemImage: "circle")
            }
            .tag("Four")
            
            
            
        }
        
//        NavigationStack {
//            List(users, id: \.self, selection: $selection) { user in
//                Text(user)
//            }
//            .toolbar {
//                //让按钮先从左侧开始放置
//                ToolbarItem(placement: .topBarTrailing) {
//                    EditButton()
//                }
//            }
//            if selection.isEmpty == false {
//                Text("You selected \(selection.formatted())")
//            }
//            
//        }
        
    }
    
    
    //MARK: - 方法
    func fetchReadings() async {
        do {
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            output = "Found \(readings.count) readings"
        } catch {
            print("Download error")
        }
    }
    
    
}



//MARK: - 预览
#Preview {
    ContentView()
}
