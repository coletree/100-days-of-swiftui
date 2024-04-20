//
//  iDineApp.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI

@main
struct iDineApp: App {
    
    //状态属性: 为类创建订单数据
    @State private var order = Order()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(order)
        }
    }
    
}
