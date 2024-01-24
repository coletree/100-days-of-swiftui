//
//  ContentView.swift
//  Moonshot
//
//  Created by coletree on 2023/12/11.
//

import SwiftUI

struct ContentView: View {

    //MARK: - 属性
    
    //1. 加载两个JSON文件，传入两个数据属性
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    //2. 布局属性
    let columns = [ GridItem(.adaptive(minimum: 150)) ]
    @State var gridViewOn = true
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            Group{
                if gridViewOn {
                    ScrollView {
                        Spacer(minLength: 20)
                        LazyVGrid(columns: columns) {
                            ForEach(missions) {
                                mission in
                                NavigationLink(value: mission) {
                                    MissionGridCellView(mission: mission)
                                }
                            }
                        }
                        //注意摆放的位置是在 grid 的外面
                        .navigationDestination(for: Mission.self) {
                            item in
                            MissionView(mission: item, astronauts: astronauts)
                        }
                        .padding([.horizontal, .bottom])
                    }
                } else {
                    List (missions, id: \.id){
                        mission in
                        ZStack {
                            MissionListCellView(mission: mission)
                            NavigationLink(value: mission) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowBackground(Color.darkBackground)
                        
                    }
                    .navigationDestination(for: Mission.self) {
                        item in
                        MissionView(mission: item, astronauts: astronauts)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            //这个代码告诉程序，当前选择的显示模式是什么（深色还是浅色）
            .preferredColorScheme(.dark)
            .toolbar {
                if gridViewOn {
                    Button("List") {
                        withAnimation(.easeInOut(duration: 1)) {
                            gridViewOn = false
                        }
                    }
                } else {
                    Button("Grid") {
                        withAnimation(.easeInOut(duration: 1)) {
                            gridViewOn = true
                        }
                    }
                }
            }
        }
        
    }
    
}



#Preview {
    ContentView()
}



//MARK: 任务的网格视图单元
struct MissionGridCellView: View {
    
    let mission: Mission
    
    var body: some View {
        VStack {
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
                .accessibilityLabel("The mission badge for \(mission.displayName)")
            
            VStack {
                Text(mission.displayName)
                    .font(.headline)
                    .foregroundStyle(.white)
                //加了日期格式后，以下代码失效
                //Text(mission.launchDate ?? "N/A")
                //换成这个
                Text(mission.formattedLaunchDate)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(.lightBackground)
        }
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.lightBackground)
        )
        //.accessibilityElement(children: .combine)
    }
}


//MARK: 任务的列表视图单元
struct MissionListCellView: View {
    
    let mission: Mission
    
    var body: some View {
        HStack {
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .padding()
                .accessibilityLabel("The mission badge for \(mission.displayName)")
                .accessibilityAddTraits(.isButton)
                .accessibilityRemoveTraits(.isImage)
            
            VStack(alignment: .leading) {
                Text(mission.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                //加了日期格式后，以下代码失效
                //Text(mission.launchDate ?? "N/A")
                //换成这个
                Text(mission.formattedLaunchDate)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.vertical)
            
            Spacer()
        }
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.lightBackground)
        )
    }
}
