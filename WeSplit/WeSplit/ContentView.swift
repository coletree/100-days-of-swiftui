//
//  ContentView.swift
//  WeSplit
//
//  Created by coletree on 2023/11/13.
//

import SwiftUI

struct ContentView: View {
    
    let tipPercentages = [10, 15, 20, 25, 0]
    @FocusState private var amountIsFocused: Bool
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var settingsExpanded = false
    
    @State private var tipPercentage = 10
    
    
    //设置两个计算属性
    var grandAll: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    var totalPerPerson: Double {
        // calculate the total per person here
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = grandAll / peopleCount
        return amountPerPerson
    }
    
    
    
    var body: some View {
        
        let binding = Binding(
            get: { tipPercentage },
            set: { tipPercentage = $0 }
        )
        
        NavigationStack {
            Form {
                
                Section {
                    Text(tipPercentage == 0 ? "输入账单金额(没设置小费)" : "输入账单金额")
                        .foregroundStyle(tipPercentage == 0 ? .red : .black)
                    TextField(
                        "Input Amount",
                        value: $checkAmount,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                    )
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                }
                
                DisclosureGroup("总金额为\(grandAll)", isExpanded: $settingsExpanded) {
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<100, id: \.self) {
                            if $0 % 5 == 0 {
                                Text($0, format: .percent)
                            }
                        }
                    }
                    .pickerStyle(.navigationLink)
                    //.pickerStyle(.segmented)
                }
                
                //第三部份
                Section(
                    header: Text("每人需要付的金额：").bold(), footer: Text("精确到小数点后两位")
                ){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
            }
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

#Preview {
    ContentView()
}
