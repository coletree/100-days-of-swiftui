//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by coletree on 2023/12/29.
//

import SwiftData
import SwiftUI



struct EditUserView: View {
    
    
    //MARK: - 属性
    
    //1. 属性 user 是swiftData 对象，该类是从别的视图传过来的，需要加上 @Bindable 才能做绑定
    @Bindable var user: User
    
    //2. 模型上下文
    @Environment(\.modelContext) var modelContext

    
    //MARK: - 视图
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    //MARK: - 方法
    
    
}



//MARK: - 预览
#Preview {
    //创建自定义配置和容器
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "Taylor Swift", city: "Nashville", joinDate: .now)
        return EditUserView(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
