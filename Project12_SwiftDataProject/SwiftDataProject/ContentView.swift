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
    
    
    //MARK: - 视图
    var body: some View {
        
        //绑定了储存的导航路径
        NavigationStack(path: $path) {
            List(users) { user in
                NavigationLink(value: user) {
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
            //当导航到 User 对象时，去到以下目标页面（并且把 user 传递过去）
            .navigationDestination(for: User.self) {
                user in
                EditUserView(user: user)
            }
            .toolbar {
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
                    
                    //跳转到相应页面
                    //path = [user]
                }
            }
        }
        
    }
    
    //MARK: - 方法
    
    
}


//MARK: - 预览
#Preview {
    ContentView()
}
