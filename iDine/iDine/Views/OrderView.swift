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
                
                //视图：已点菜品清单
                Section {
                    ForEach(order.items) { 
                        item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                //视图：结帐按钮
                Section {
                    //链接：跳转到结帐页面
                    NavigationLink("Place Order") {
                        CheckoutView()
                    }
                    .disabled(order.items.isEmpty)
                }
            }
            .navigationTitle("Order")
            //支持批量编辑
            .toolbar {
                EditButton()
            }
        }
        
    }
    
    
    //MARK: - 方法
    
    //方法：删除元素
    func deleteItems(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
    
    
    
    
}




//MARK: - 预览
#Preview {
    OrderView()
        .environment(Order())
}
