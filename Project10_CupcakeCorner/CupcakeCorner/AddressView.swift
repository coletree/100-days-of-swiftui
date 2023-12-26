//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/22.
//

import SwiftUI

struct AddressView: View {
    
    //MARK: - 设置属性，等待参数传入。
    //由于需要对此类进行绑定，要加上 @Bindable
    @Bindable var order: Order
    
    @State var userAddress : Address = Address()
    
    

    var body: some View {
        
        Form{
            
            //MARK: - 填写地址
            Section {
                TextField("Name", text: $userAddress.name)
                TextField("Street Address", text: $userAddress.streetAddress)
                TextField("City", text: $userAddress.city)
                TextField("Zip", text: $userAddress.zip)
            }
            

            //MARK: - 提交订单
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
                .disabled(userAddress.hasValidAddress == false)
                .onTapGesture(perform: {
                    order.userAddress = userAddress
                })
            }
            
        }
        .onAppear(perform: {
            loadAddress()
            print("地址读取成功")
        })
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    //MARK: - 方法：读取地址
    func loadAddress(){
        
        guard let getAddress = UserDefaults.standard.data(forKey: "UserAddress") else {
            print("什么地址都没获取到")
            return
        }

        do {
            let decoder = JSONDecoder()
            let tempAddress = try decoder.decode(Address.self, from: getAddress)
            // ？
            userAddress = tempAddress
            print(tempAddress)
        } catch {
            print("地址获取错误")
        }
        
    }
    
}




#Preview {
    AddressView(order: Order())
}
