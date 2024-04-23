//
//  iDineApp.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI

@main
struct iDineApp: App {

    //状态属性: 为 Order 类创建订单数据实例
    @State private var order = Order()
    
    //状态属性: 为 Favor 类创建订单数据实例
    @State private var favor = Favor()
    

    var body: some Scene {
        WindowGroup {
            //视图：将主视图改成了 MainView
            MainView()
                //将 order 实例放入环境
                .environment(order)
                .environment(favor)
        }
    }

}
