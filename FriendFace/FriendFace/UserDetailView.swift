//
//  UserDetailView.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import SwiftUI

struct UserDetailView: View {
    
    var user: User
    
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
                ForEach(user.tags, id: \.self){
                    item in
                    HStack{
                        Text("\(item)")
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

#Preview {
    UserDetailView(user: User(id: UUID(), isActive: false, name: "aaa", age: 16, company: "fdsafd", email: "fdsfa", address: " fdsa ffdsaf", about: "fdsafdas fdsa ", registered: .now, tags: ["111"], friends: [Friend(id: UUID(), name: "bb")]))
}
