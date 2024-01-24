//
//  MissionView.swift
//  Moonshot
//
//  Created by coletree on 2023/12/13.
//

import SwiftUI


//MARK: MissionView 中新建一个 CrewMember 结构体
struct CrewMember {
    let role: String
    let astronaut: Astronaut
}



struct MissionView: View {
    
    //MARK: MissionView 需要传入两个属性
    let mission: Mission
    let crew: [CrewMember]

    
    var body: some View {
        ScrollView {
            
            VStack {
                
                //MARK: 任务信息(主要用到 mission结构)
                //任务徽章：mission.image
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { 
                        width, axis in
                        width * 0.5
                    }
                    .padding(.vertical, 40)
                    .accessibilityLabel("badget for \(mission.displayName)")

                //任务内容：
                VStack(alignment: .leading) {
                    
                    //任务日期：mission.formattedLaunchDate
                    Text(mission.formattedLaunchDate)
                        .font(.headline)
                        .foregroundStyle(.yellow.opacity(0.8))
                        .padding(.bottom, 4)
                    
                    //任务标题
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    //分割线
                    GapLineView()

                    //任务描述：mission.description
                    Text(mission.description)
                    
                    //分割线
                    GapLineView()
                    
                }
                .padding(.horizontal)
                
                
                //MARK: 任务成员(主要用到 crew数组, crewMember结构, astronaut结构)
                VStack(alignment: .leading) {
                    
                    //任务成员标题
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    
                    //成员列表
                    CrewScrollView(crew: crew)
                }
                
                
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    //MARK: - 自定义初始化函数，需要赋值两个属性（mission, crew）
    //未赋值的属性都要赋值。传入了一个 mission 对象，和 astronauts 字典
    init(mission: Mission, astronauts: [String: Astronaut]) {
        //属性1: 赋值为传入的 mission 参数
        self.mission = mission
        //属性2: 利用传入的 astronauts 参数，赋值给 crew 属性
        self.crew = mission.crew.map { 
            member in
            //member 是 mission 的 crew 属性（crewRole数组）中的一个一个的对象
            if let astronaut = astronauts[member.name] {
                //如果在传入的字典中，能找到这个对象，则将这个对象返回
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
    
}


//MARK: 子视图 —— 成员滚动视图
struct CrewScrollView: View {
    
    let crew : [CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing:20) {
                
                //遍历任务成员，id用role
                ForEach(crew, id: \.role) {
                    //crewMember 参数是 crew 里的每个成员
                    crewMember in
                    
                    NavigationLink {
                        //链接到 AstronautView，参数为 crewMember 结构中的 astronaut 属性（即astronaut结构）
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack(spacing:4) {
                            //头像: crewMember.astronaut.id
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 100, height: 72)
                                .clipShape(.circle)
                                .overlay(
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 2)
                                )
                                .accessibilityLabel("avatar for \(crewMember.astronaut.name)")
                            //成员信息：
                            VStack(alignment: .leading) {
                                //成员名称：crewMember.astronaut.name
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                    .accessibilityLabel(crewMember.astronaut.name.replacingOccurrences(of: ".", with: ""))
                                //成员角色：crewMember.role
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal,10)
                    }
                }
            }
            
        }
        .padding(.vertical, 8)
    }
}

//MARK: 子视图 —— 分隔视图
struct GapLineView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}


//MARK: 预览视图
#Preview {
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    //因为有了上面两行代码，该闭包就不是一行代码了，所以return不能省略，要补回来
    return MissionView(mission: missions[1], astronauts: astronauts)
        .preferredColorScheme(.dark)
        //提示：此视图将自动具有深色配色方案，因为它应用于 ContentView 中的 NavigationStack
        //但 MissionView 预览不知道这一点，因此我们需要手动启用它
    
}
