//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by coletree on 2023/12/29.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    
    //1. 添加属性以访问模型上下文
    @Environment(\.modelContext) var modelContext
    
    //2. 加载所有 User 对象
    //@Query(sort: \User.name) var users: [User]
    @Query(
        filter: #Predicate<User> {
            user in
            if user.name.localizedStandardContains("R") {
                if user.city == "London" {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }, sort: \User.name) var users: [User]
    
    //3. 存储导航路径
    @State private var path = [User]()
    
    
    //4. 用于传递到 usersView 视图的参数
    @State private var showingNewOnly = false
    
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //NavigationStack：绑定了储存的导航路径
        NavigationStack(path: $path) {
            
            //子视图：通过状态属性 showingNewOnly 以及 sortOrder，控制显示什么内容
            UsersView(minimumJoinDate: showingNewOnly ? .now : .distantPast, sortOrder: sortOrder)
            
            .navigationTitle("Users")
            //当导航到 User 对象时，去到以下目标页面（并且把 user 传递过去）
            .navigationDestination(for: User.self) {
                user in
                EditUserView(user: user)
            }
            
            //顶部工具栏：
            .toolbar {
                
                //按钮：添加一些数据
                Button("Add User", systemImage: "plus") {
                    
                    //删除 User 类型的所有现有模型对象
                    try? modelContext.delete(model: User.self)
                    
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                    
                    addSample()
                    
                    //跳转到相应页面
                    //path = [user]
                }
                
                //按钮：控制是否仅显示最新数据
                Button(showingNewOnly ? "Show Everyone" : "Show Upcoming") {
                    showingNewOnly.toggle()
                }
                
                //按钮：控制排序逻辑
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    //用 tag 修饰符，包裹具体选项的值（可以是任何值）。该值与状态属性绑定
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate),
                            ])

                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\User.joinDate),
                                SortDescriptor(\User.name)
                            ])
                    }
                }
                
            }
        }
        
    }
    
    //MARK: - 方法
    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)

        modelContext.insert(user1)

        user1.jobs.append(job1)
        user1.jobs.append(job2)
    }
    
}


//MARK: - 预览
#Preview {
    ContentView()
}
