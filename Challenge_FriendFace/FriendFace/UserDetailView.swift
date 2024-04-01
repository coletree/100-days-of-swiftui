//
//  UserDetailView.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import SwiftData
import SwiftUI


struct UserDetailView: View {
    
    
    //MARK: - 属性
    
    //声明User数组，等待被传入
    var user: User
    
    
    //MARK: - 视图
    var body: some View {
        
        Form{
            
            Section{
                Text(user.name)
                    .font(.title)
                    .foregroundStyle(user.isActive ? .green : .gray)
                Text(user.company)
                Text(user.email)
                Text(user.address)
                Text("\(user.age) years old")
                Text("Registered: \(user.registered)")
            }
            
            Section{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 8){
                        ForEach(user.tags, id: \.self){
                            item in
                            Button(action: {
                                
                            }, label: {
                                Text("\(item)")
                            })
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                }
            }
            
            Section{
                Text(user.about)
            }
            
            Section{
                ForEach(user.friends){
                    item in
                    HStack{
                        Text(item.name)
                    }
                }
            }
            
        }
        .navigationTitle("用户详情")
        
    }
}




//MARK: - 预览
#Preview {
    
    do {
        //1.由于并不希望创建的模型容器实际存储任何内容；则需要创建【自定义配置】，告诉 SwiftData 仅将信息存储在内存中；
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        //2.使用刚刚的【自定义配置】，来创建一个模型容器；
        let container = try ModelContainer(for: User.self, configurations: config)
        
        //3. 这是在 User 类中，定义的 static 静态属性。方便随时调用，只需要用（大写类名）代表类本身
        let temp = User.example
        
        //4.返回以下内容给Preview，输入temp作为实例化参数；
        return UserDetailView(user: temp).modelContainer(container)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
    
}
