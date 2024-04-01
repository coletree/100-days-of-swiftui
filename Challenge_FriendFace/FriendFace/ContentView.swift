//
//  ContentView.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    
    //声明环境变量：modelContext ，以便写入数据
    @Environment(\.modelContext) var modelContext

    //声明User数组
    @Query var users : [User]
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack{
            
            UserListView()
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
    
    //方法：从网络读取数据
    func loadData() async {
        
        //测试用：每次读取先清空一遍数据
        try? modelContext.delete(model: User.self)
        
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
            //可以直接解析出 [User] 数组
            if let decodedData = try? decoder.decode([User].self, from: data) {
                
                let insertContext = ModelContext(modelContext.container)
                //读取成功后，将数组中的对象一个个存入swiftData
                for item in decodedData {
                    //modelContext.insert(item)
                    insertContext.insert(item)
                }
                try insertContext.save()
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
