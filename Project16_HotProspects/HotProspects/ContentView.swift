//
//  ContentView.swift
//  HotProspects
//
//  Created by coletree on 2024/1/30.
//

import SamplePackage
import SwiftUI


struct ContentView: View {
    
    //MARK: - 属性
    
    //@State private var selection: String? = "Yuki"
    
    @State private var selection = Set<String>()
    
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    
    @State private var selectedTab = "One"
    
    @State private var output = ""
    
    @State private var backgroundColor = Color.red
    
    let possibleNumbers = 1...60
    
    var results: String {
        // more code to come
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.formatted()
    }
    
    
    //创建模型上下文
    @Environment(\.modelContext) var modelContext

    
    
    
    //MARK: - 视图
    
    var body: some View {
        
        
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }

        
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
