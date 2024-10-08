//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by coletree on 2024/1/3.
//

import SwiftData
import SwiftUI




struct UsersView: View {
    
    
    //MARK: - 属性
    
    //环境属性：
    @Environment(\.modelContext) var modelContext
    
    //SwiftData数据
    @Query var users: [User]
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        List(users) { user in
            NavigationLink(value: user) {
                
                Text(user.name)
                
                Spacer()

                Text(String(user.jobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                
            }
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    //自定义初始化：通过初始化方法来控制需要显示的 SwiftData 数据
    init(
        minimumJoinDate: Date,
        sortOrder: [SortDescriptor<User>]
    ){
        _users = Query(
            filter: #Predicate<User> {
                user in
                user.joinDate >= minimumJoinDate
            }, 
            sort: sortOrder
        )
    }
    
    /*
     请注意 users 前面是有一个下划线，这是有意为之的。
     因为我们并不是更改 User 数组，而是试图更改生成该数组的 SwiftData 查询。

     初始化方法中的 _users 代表的是属性包装器。
     属性包装器是Swift的新技术，它允许在属性上应用额外的逻辑。
     @Query 是一个属性包装器，它用于将属性users与查询关联起来。
     下划线前缀的 _users 代表了被 @Query属性包装器包装的users属性。
     这种命名约定是Swift中用于表示属性包装器投影值的一种惯例。
     在初始化方法中，_users是属性包装器的投影值，它允许我们直接访问被包装的属性。
     这样可以确保在初始化方法中正确地设置 users 属性，而不会触发属性包装器的其他逻辑
    */
    
    //排序：使用了 Swift 的泛型： SortDescriptor 类型需要知道它正在排序什么，因此需要在尖括号内指定 User
    
}




//MARK: - 预览
#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
