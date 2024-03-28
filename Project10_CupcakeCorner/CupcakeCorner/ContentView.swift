//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by coletree on 2023/12/21.
//

import SwiftUI
//导入自定义震动库
import CoreHaptics



struct ContentView: View {

    
    //MARK: - 属性
    
    //状态属性：控制触觉反馈的
    @State private var engine: CHHapticEngine?

    //状态属性：创建 @observable类的单个实例。这是创建订单实例的唯一地方，后面程序中的每个视图都将传递该属性，因此它们都使用相同的数据。
    @State private var order = Order()

    
    
    
    //MARK: - 视图
    var body: some View {

        NavigationStack{
            
            Form{
                
                //视图：选择蛋糕参数
                Section{
                    VStack(alignment: .leading) {
                        Text("Choose your cake's type:")
                            .fontWeight(.medium)
                        //蛋糕类型列表是一个字符串数组，但我们将用户的选择存储为整数，如何匹配两者？一个简单的解决方案是使用数组的 indices 属性，它为我们提供了每个项目的位置，然后我们可以将其用作数组索引。
                        Picker("Select your cake type", selection: $order.typeIndex) {
                            ForEach(Order.types.indices, id: \.self){
                                item in
                                Text(Order.types[item]).tag(item)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom,8)
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 1...20)
                    
                }
                
                //视图：置蛋糕订单额外需求
                Section{
                    Toggle(isOn: $order.specialRequestEnabled) { Text("Any special requests?") }
                    if order.specialRequestEnabled {
                        Toggle(isOn: $order.extraFrosting) { Text("Add extra frosting") }
                        Toggle(isOn: $order.addSprinkles) { Text("Add extra sprinkles") }
                    }else{
                        Toggle(isOn: $order.extraFrosting) { Text("Add extra frosting") }
                            .disabled(true)
                        Toggle(isOn: $order.addSprinkles) { Text("Add extra sprinkles") }
                            .disabled(true)
                    }
                }
                .sensoryFeedback(.increase, trigger: order.specialRequestEnabled)
                .sensoryFeedback(.increase, trigger: order.extraFrosting)
                .sensoryFeedback(.increase, trigger: order.addSprinkles)
                
                //MARK: - 填写订单地址
                Section {
                    NavigationLink("填写订单地址") {
                        AddressView(order: order)
                    }
                }
                
            }
            .navigationTitle("Order your cakes:")
            
            
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    //方法：自定义震动
    func prepareHaptics() {
        //确保手机支持震动，不支持就直接返回
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            //支持的话，生成一个新 CHHapticEngine 实例，赋予之前的状态属性；
            engine = try CHHapticEngine()
                    //并且调用该实例的 start 方法
            try engine?.start()
        } catch {
            //有错的时候报错
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    
    
    
}



//MARK: - 预览
#Preview {
    ContentView()
}
