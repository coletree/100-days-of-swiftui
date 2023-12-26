//
//  ContentView.swift
//  BetterRest
//
//  Created by coletree on 2023/11/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    //@State private var alertMessage = alertMsg
    //@State private var alertTitle = ""
    //@State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var alertMsg: String {
        return calculateBedtime()
    }
    
    
    
    
    
    var body: some View {
        NavigationStack {
            
            Form {
                Section(header: Text("输入你想要起床的时间")){
                    DatePicker("明天的...", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    // .labelsHidden()
                }
                Section(header: Text("选择你的情况")) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("你今天喝了几杯咖啡")
                        //Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
                        Picker(selection: $coffeeAmount, label: Text(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cup(s)")){
                            ForEach(1...10, id: \.self){
                                number in
                                Text("\(number)")
                            }
                        }.pickerStyle(MenuPickerStyle())
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("你想要睡几个小时")
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                }
                
            }
            .padding(.top, 30)
            .navigationTitle("BetterRest")
            
            VStack(alignment: .center, spacing: 10){
                Text("你理想的就寝时间是:")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                Text(alertMsg)
                    .font(.system(size: 32))
                    .fontWeight(.bold)
            }.padding(30)
            
//            .toolbar {
//                Button("计算", action: calculateBedtime)
//            }
//            
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    
    // 计算时间的方法
    func calculateBedtime() -> String {
        // 首先需要创建 SleepCalculator 类的实例。
        // 使用 do / catch 块，是因为使用 Core ML 可能会在两个地方引发错误：
        // 加载模型以及当要求预测时。虽然很少有过预测失败的情况，但安全总没有坏处！
        do {
            let config = MLModelConfiguration()
            
            // 该模型的实例会读取所有该类的数据，并输出一个预测。
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // 将上面计算的时和分对应的秒数，加到一起，做预测
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            // 感谢 Apple 强大的 API，直接从 Date 中减去一个值，然后您将得到一个新的 Date ！
            // 创建一个名为 sleepTime 的常量，其中包含他们需要上床睡觉的时间。
            let sleepTime = wakeUp - prediction.actualSleep
            
            //alertTitle = "你理想的上床时间是…"
            // 由于 sleepTime 是一个 Date 而不是一个格式整齐的字符串，因此将通过 formatted() 格式化它确保它是可读的。
            let alertMsg = sleepTime.formatted(date: .omitted, time: .shortened)
            return alertMsg
        } catch {
            //alertTitle = "出错了"
            let alertMsg = "Sorry, there was a problem calculating your bedtime."
            return alertMsg
        }
        //showingAlert = true
    }
    
}

#Preview {
    ContentView()
}
