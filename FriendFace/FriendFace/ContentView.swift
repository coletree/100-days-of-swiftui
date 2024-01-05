//
//  ContentView.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性

    @State var users : [User] = [User]()
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack{
            
            UserListView(users: $users)
            .navigationTitle("用户列表")
            .toolbar{
                Button("Load") {
                    print("下载...")
                    Task {
                        await loadData()
                    }
                }
            }
            .navigationDestination(for: User.self) {
                selection in
                UserDetailView(user: selection)
            }

            
        }
        
        
    }
    
    
    
    
    //MARK: - 方法
    func loadData() async {
        
        guard users.isEmpty else{
            print(users)
            return
        }
        
        let targetURL = "https://www.hackingwithswift.com/samples/friendface.json"
        guard let url = URL(string: targetURL) else {
            print("URL地址无效")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedData = try? decoder.decode([User].self, from: data) {
                self.users = decodedData
                print("解析成功")
            }else{
                print("解析无效")
            }
        } catch {
            print("Invalid data 无效数据")
        }
        
    }
    
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
