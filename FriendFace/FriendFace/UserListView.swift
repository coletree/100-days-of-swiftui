//
//  UserListView.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import SwiftData
import SwiftUI



struct UserListView: View {
    
    //MARK: - 属性
    
    //查询SwiftData的对象
    @Query(sort: \User.name) var users : [User]
    
    
    
    //MARK: - 视图
    var body: some View {
        List{
            ForEach(users){
                item in
                NavigationLink(value: item){
                    HStack(spacing: 8) {
                        Circle()
                            .frame(width: 16, height: 16, alignment: .top)
                        .foregroundStyle(item.isActive ? .green : .gray)
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
    
    
    //MARK: - 方法
    
    
    
}





//MARK: - 预览
#Preview {
    UserListView()
}
