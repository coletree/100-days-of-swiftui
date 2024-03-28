//
//  URLDemoView.swift
//  CupcakeCorner
//
//  Created by coletree on 2024/3/26.
//

import SwiftUI




struct URLDemoView: View {
    
    
    //MARK: - 属性
    @State private var results = [Result]()
    
    
    
    //MARK: - 视图
    var body: some View {
        
        
        Button("Encode Taylor", action: encodeTaylor)
        
        
        List(results, id: \.trackId) { 
            item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
        
    }
    
    
    //MARK: - 方法
    
    //方法：读取网络 API 数据
    func loadData() async {
        
        //1.创建我们想要读取的 URL
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        //2.从该 URL 获取数据，这里可能发生函数休眠。说“可能”是因为也可能不会。iOS 会对数据进行一些缓存，因此如果连续两次提取 URL，那么数据将立即发送回来，而不是触发休眠。
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // more code to come
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
            
        } catch {
            print("Invalid data")
        }
        
        

    }

    
    
    func encodeTaylor() {
                //编码 @Observable 类
        let data = try! JSONEncoder().encode(User())
                //解码，打印出来，会发现属性值已经被篡改了
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
    
    
    
}



//MARK: - 预览
#Preview {
    URLDemoView()
}
