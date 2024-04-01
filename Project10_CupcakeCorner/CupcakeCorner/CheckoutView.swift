//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/25.
//

import SwiftUI




struct CheckoutView: View {
    
    
    //MARK: - 属性
    
    //属性：等待参数传入
    var order: Order
    
    //状态属性：提示弹窗的参数
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    //状态属性：提示失败的弹窗参数
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    
    
    //MARK: - 视图
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
    
    
    
    
    //MARK: - 方法
    
    //方法：提交订单到网络。标记异步函数
    func placeOrder() async {
        
        // 1.将当前的 order 对象编码为一些可以发送的JSON数据（用 guard 确保可以编码）
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("编码 order 数据失败")
            return
        }
        
        
        // 2.告诉 Swift 如何通过网络调用发送该数据
        
        // 使用 URL(string:) 从网址字符串生成 URL 对象，该方法返回一个可选值的 URL。
        // 原本它是有可能失败的。但这里使用感叹号强制解包，是因为这个URL是我们自己输入的，肯定是正确的。所以可以强制解包。
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        // 通过 URL 地址生成一个 URLRequest 对象，并设置该对象的具体属性
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // 3.运行该请求并处理响应。两个参数：for、from
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            //正确情况下：发送的订单编码数据，与返回的订单解码数据应该是一样的，如果不是，则意味着我们在编码中犯了错误。所以我们可以使用 JSONDecoder 将其从 JSON 数据转换回对象。这里使用从 ReqRes.in 返回的解码订单。
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            //如果可以解码，则显示反馈信息
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.typeIndex].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch {
            //如果出错：比如因为没有互联网连接，那么 catch 块将运行
            errorMessage = "Checkout failed. \n\nMessage \(error.localizedDescription)"
            showingError = true
        }
        
        
    }
    
    
    
    //方法：提交地址到UserDefault
    func placeAddress() {
        
        guard let encoded = try? JSONEncoder().encode(order.userAddress) else {
            print("编码地址数据失败")
            return
        }
        
        //保存到UserDefaults
        UserDefaults.standard.set(encoded, forKey: "UserAddress")
        print("编码地址成功")
        print(UserDefaults.standard.data(forKey: "UserAddress") ?? "地址没有内容")
        
    }
    
    
    
    
}




//MARK: - 预览
#Preview {
    CheckoutView(order: Order())
}
