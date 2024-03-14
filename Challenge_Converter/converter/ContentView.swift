//
//  ContentView.swift
//  converter
//
//  Created by coletree on 2023/11/14.
//

import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    
    //枚举属性：定义了一组单位
    enum unitAll: String, CaseIterable {
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
    
    //状态属性：输入值，输入单位，输出单位
    @State private var sourceValue: Double = 26.0
    @State private var sourceUnit : unitAll = .Celsius
    @State private var targetUnit : unitAll = .Kelvin
    
    //计算属性：这里设置一个中间值，让用户不管选什么单位，都先转成统一的单位
    var middleValue: Double{
        switch sourceUnit{
            case .Celsius: return sourceValue * 1
            case .Fahrenheit: return (sourceValue - 32) * 5/9
            case .Kelvin: return sourceValue - 273.15
        }
    }
    
    //输出值：然后在由中间值，转成目标单位的最终值。
    //这种分两步走的办法，可以避免直接去写每两个不同单位的转化，那样太麻烦
    var finalValue:Double{
        switch targetUnit{
            case .Celsius: return middleValue * 1
            case .Fahrenheit: return middleValue * 9 / 5 + 32
            case .Kelvin: return middleValue + 273.15
        }
    }
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        Form {
            
            //视图：用户输入具体数值和单位
            Section(header: Text("输入具体温度值和单位：")) {
                //输入框：和源数值绑定，格式化为数字
                TextField("", value: $sourceValue, format: .number)
                //选择器：和源单位绑定
                Picker("原始单位：", selection: $sourceUnit) {
                    //获取枚举的全部成员，然后将每个成员的原始值显示为文本
                    ForEach(unitAll.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                //显示为分段选择器
                .pickerStyle(.segmented)
            }
            
            //视图：根据选择的单位，展示转化后的数值
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




//MARK: - 预览
#Preview {
    ContentView()
}
