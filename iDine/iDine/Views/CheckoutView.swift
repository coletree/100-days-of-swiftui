//
//  CheckoutView.swift
//  iDine
//
//  Created by coletree on 2024/4/22.
//

import SwiftUI


struct CheckoutView: View {
    
    
    //MARK: - 属性
    
    //常量属性：支付方式数组
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    
    //常量属性：小费数量
    let tipAmounts = [0, 10, 15, 20, 25]
    
    //计算属性：计算订单的总数（价格 + 小费）
    var totalPrice: String {
        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)
        return (total + tipValue).formatted(.currency(code: "USD"))
    }
    
    //状态属性：设置支付相关信息
    @State private var paymentType = "Cash"
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 15
    
    //状态属性：是否弹窗
    @State private var showingPaymentAlert = false
    
    //环境属性：读取在 App.swift 文件中定义的 order 属性
    @Environment(Order.self) var order
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        Form{
            
            //视图：设置支付方式
            Section {
            
                //Picker 选择器：与 paymentType 绑定
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical,8)
                
                //Toggle 开关：是否添加会员卡
                Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
                
                //TextField 文本框：如果上面的开关打开，才显示该文本框
                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
                
            }
            
            //视图：设置小费
            Section("Add a tip?") {
                Picker("Percentage:", selection: $tipAmount) {
                    ForEach(tipAmounts, id: \.self) {
                        Text("\($0)%")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            //视图：确认支付按钮
            Section("Total: \(totalPrice)") {
                Button("Confirm order") {
                    // place the order
                }
            }
            
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        //视图：弹窗
        .alert("Order confirmed", isPresented: $showingPaymentAlert) {
            // add buttons here
            Button("Confirm order") {
                showingPaymentAlert.toggle()
            }
        } message: {
            Text("Your total was \(totalPrice) – thank you!")
        }
        
    }
    
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    CheckoutView()
        .environment(Order())
}
