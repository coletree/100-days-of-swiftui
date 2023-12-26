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

    

    var body: some View {
        
        Form{
            
            //MARK: - 填写地址，和order类的属性进行绑定，修改它就修改order类
            Section {
                TextField("Name", text: $order.userAddress.name)
                TextField("Street Address", text: $order.userAddress.streetAddress)
                TextField("City", text: $order.userAddress.city)
                TextField("Zip", text: $order.userAddress.zip)
            }
            

            //MARK: - 提交订单
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
                .disabled(order.userAddress.hasValidAddress == false)
            }
            
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
}


//MARK: - 预览
#Preview {
    AddressView(order: Order())
}
