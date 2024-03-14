//
//  ContentView.swift
//  WeSplit
//
//  Created by coletree on 2023/11/13.
//

import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    
    //常量属性：小费的比例等级
    let tipPercentages = [0, 10, 15, 20, 25]
    
    //状态属性：分别是用户需要输入的3部分数据：总金额、人数、以及小费比例
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 10
    
    //状态属性：控制设置视图是否展开
    @State private var settingsExpanded = false
    
    //焦点状态：
    @FocusState private var amountIsFocused: Bool
    
    //计算属性：全部要付的总金额
    var grandAll: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    //计算属性：每个人应付的总钱数
    var totalPerPerson: Double {
        // calculate the total per person here
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = grandAll / peopleCount
        return amountPerPerson
    }
    
    
    
    //MARK: - body 视图
    var body: some View {
        
        //自定义绑定类型，建完后控件可以选择与其绑定，而不是直接绑定状态属性。有点像中间值
        let binding = Binding(
            get: { tipPercentage },
            set: { tipPercentage = $0 + 20 }
        )


        NavigationStack {
            
            Form {
                
                //视图：输入账单总金额的区块
                Section {
                    
                    //根据具体值去区别显示的文案
                    Text(tipPercentage == 0 ? "输入账单金额(没设置小费)" : "输入账单金额")
                        .foregroundStyle(tipPercentage == 0 ? .red : .black)
                    
                    //输入框：与状态参数绑定，并用格式化显示为货币的样子
                    TextField(
                        "Input Amount",
                        value: $checkAmount,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                    )
                    //设置输入框的键盘类型，以及将其焦点和状态参数绑定
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                
                }
                header: {
                    //no content
                } 
                footer: {
                    //文本：根据具体值去区别显示的文案
                    Text("本次消费总金额为：") +
                    Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }

                //视图：设置视图 DisclosureGroup ，与状态参数绑定，默认折叠
                DisclosureGroup("总金额为\(grandAll)", isExpanded: $settingsExpanded) {
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 50) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Picker("Tip percentage", selection: binding) {
                        ForEach(0..<100, id: \.self) {
                            if $0 % 10 == 0 {
                                Text($0, format: .percent)
                            }
                        }
                    }
                    .pickerStyle(.navigationLink)
                    //.pickerStyle(.wheel)
                }
                
                //视图：计算出每人需要支付金额的区块
                Section(
                    header: Text("每人需要付的金额：").bold(), 
                    footer: Text("精确到小数点后两位")
                ){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
            }
            //导航栏设置：toolbar根据判断情况放置按钮
            .navigationTitle("AA计算器")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            
        }
        
    }
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
