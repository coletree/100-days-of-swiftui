//
//  OrderView.swift
//  iDine
//
//  Created by coletree on 2024/4/19.
//

import SwiftUI

struct OrderView: View {
    
    
    //MARK: - 属性
    
    //环境属性：读取在 App.swift 文件中定义的 order 属性
    @Environment(Order.self) var order
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            List {
                Section {
                    ForEach(order.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                }
                
                Section {
                    NavigationLink("Place Order") {
                        Text("Check out")
                    }
                }
            }
            .navigationTitle("Order")
        }
        
    }
    
    
}




//MARK: - 预览
#Preview {
    OrderView()
        .environment(Order())
}
