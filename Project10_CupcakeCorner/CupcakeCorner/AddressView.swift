//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/22.
//

import SwiftUI




struct AddressView: View {
    
    
    //MARK: - 属性
    
    //属性：指定一个order属性，等待参数传入。
    //由于我们将 order 对象传递到更深层次的视图，这意味着有多个视图指向相同的数据。因此要带上 @Bindable 对此类进行绑定。
    @Bindable var order: Order

    
    
    
    //MARK: - 视图
    var body: some View {
        
        Form{
            
            //填写地址，和order类的属性进行绑定，修改它就修改order类
            Section {
                TextField("Name", text: $order.userAddress.name)
                TextField("Street Address", text: $order.userAddress.streetAddress)
                TextField("City", text: $order.userAddress.city)
                TextField("Zip", text: $order.userAddress.zip)
            }
            

            //提交订单：用一个 NavigationLink 将控制权传递给我们的 checkoutView
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
