//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/25.
//

import SwiftUI

struct CheckoutView: View {
    
    //MARK: - 设置属性，等待参数传入
    var order: Order
    
    //提示弹窗的参数
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    //提示失败的弹窗
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                //读取网络图片
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) {
                    image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 280)
                .accessibilityHidden(true)

                //展示订单价格
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                //MARK: - 提交订单，保存地址
                Button("提交订单、保存地址") {
                    //方法：执行保存地址
                    //placeAddress()
                    Task {
                        //方法：执行提交订单
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        //提交状态弹窗 - 成功
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
        //提交状态弹窗 - 失败
        .alert("Opps！", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        
    }
    
    
    
    
    //MARK: - 方法：提交订单到网络
    func placeOrder() async {
        
        // 1.将我们当前的 order 对象转换为一些可以发送的JSON数据
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("编码 order 数据失败")
            return
        }
        
        // 2.通过网络调用发送该数据
        // 第一行包含 URL(string:) 初始值设定项的强制展开，这意味着“这将返回一个可选 URL，但请强制它为非可选”。因为从字符串创建 URL 对象，是可能会失败的，比如插入了一些乱码导致。但在这里我手写了 URL，这样就可以看到它总是正确的。所以可以强制解包。
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // 后面设定一个 URLRequest 对象，并设置该对象的具体属性
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // 3.运行该请求并处理响应
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // 如果正确的情况下：因为我们使用的是 ReqRes.in，所以我们实际上会返回与发送的订单相同的订单，这意味着我们可以使用 JSONDecoder 将其从 JSON 转换回对象。这里使用从 ReqRes.in 返回的解码订单。这应该与我们发送的相同，所以如果不是，则意味着我们在编码中犯了错误。
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.typeIndex].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            // 如果出错的情况下：比如因为没有互联网连接，那么 catch 块将运行
            errorMessage = "Checkout failed. \n\nMessage \(error.localizedDescription)"
            showingError = true
        }
        
    }
    
    
    //MARK: - 方法：提交地址到UserDefault
//    func placeAddress() {
//        
//        guard let encoded = try? JSONEncoder().encode(order.userAddress) else {
//            print("编码地址数据失败")
//            return
//        }
//        
//        // MARK: 保存到UserDefaults
//        UserDefaults.standard.set(encoded, forKey: "UserAddress")
//        print("编码地址成功")
//        print(UserDefaults.standard.data(forKey: "UserAddress") ?? "地址没有内容")
//        
//    }
    
    
}


//MARK: - 预览
#Preview {
    CheckoutView(order: Order())
}
