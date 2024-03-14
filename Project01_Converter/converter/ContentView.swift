//
//  ContentView.swift
//  converter
//
//  Created by coletree on 2023/11/14.
//

import SwiftUI


struct ContentView: View {
    
    enum unitAll:String, CaseIterable {
        case Celsius = "摄氏度"
        case Fahrenheit = "华氏度"
        case Kelvin = "开尔文"
        
//        var text: String {
//            switch self {
//            case .Celsius: return "摄氏度"
//            case .Fahrenheit: return "华氏度"
//            case .Kelvin: return "开尔文"
//            }
//        }
    }
    
    //let unitAll = ["米","分米","厘米","毫米"]
    
    @State private var sourceValue: Double = 26.0
    @State private var sourceUnit : unitAll = .Celsius
    @State private var targetUnit : unitAll = .Kelvin
    
    var middleValue: Double{
        switch sourceUnit{
            case .Celsius: return sourceValue * 1
            case .Fahrenheit: return (sourceValue - 32) * 5/9
            case .Kelvin: return sourceValue - 273.15
        }
    }
    
    var finalValue:Double{
        switch targetUnit{
            case .Celsius: return middleValue * 1
            case .Fahrenheit: return middleValue * 9 / 5 + 32
            case .Kelvin: return middleValue + 273.15
        }
    }
    
    
    var body: some View {
        Form {
            Section(header: Text("输入具体温度值和单位：")) {
                TextField("", value: $sourceValue, format: .number)
                Picker("原始单位：", selection: $sourceUnit) {
                    ForEach(unitAll.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section(header: Text("设置想要转换的单位即可显示结果：")) {
                Picker("目标单位：", selection: $targetUnit) {
                    ForEach(unitAll.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                Text("转换结果是: \(String(format: "%.2f", finalValue))")
                Text("转换结果是: \(finalValue.formatted(.number))")
            }
        }
    }
}

#Preview {
    ContentView()
}
