//
//  UserListView.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import SwiftUI



struct UserListView: View {
    
    @Binding var users: [User]
    
    var body: some View {
        List{
            ForEach(users){
                item in
                NavigationLink(value: item){
                    VStack(alignment: .leading, spacing: 4){
                        Text(item.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text(item.company)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                
            }
        }

    }
    
    
    
}





//MARK: - 预览
#Preview {
    UserListView(users: .constant([User]()))
}
