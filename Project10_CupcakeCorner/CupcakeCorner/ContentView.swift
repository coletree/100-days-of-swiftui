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

    //MARK: - 状态属性
    @State private var engine: CHHapticEngine?

    @State private var order = Order()

    
    

    var body: some View {

        NavigationStack{
            
            Form{
                
                //MARK: - 选择蛋糕参数
                Section{
                    //MARK: 选择类型
                    VStack(alignment: .leading) {
                        Text("Choose your cake's type:")
                            .fontWeight(.medium)
                        Picker("Select your cake type", selection: $order.typeIndex) {
                            ForEach(Order.types.indices, id: \.self){
                                item in
                                Text(Order.types[item]).tag(item)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom,8)
                    }
                    //MARK: 选择数量
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 1...20)
                    
                }
                
                //MARK: - 设置蛋糕订单额外需求
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
    
    
    //MARK: - 自定义震动
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

    func complexSuccess() {
        //确保手机支持震动，不支持就直接返回
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        //创建了一个 CHHapticEvent 事件数组
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
        
    }


    
}




#Preview {
    ContentView()
}
