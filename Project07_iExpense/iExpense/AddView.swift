//
//  AddView.swift
//  iExpense
//
//  Created by coletree on 2023/12/8.
//

import SwiftUI

struct AddView: View {
    
    
    //MARK: - 属性
    
    let types = ["Personal","Business"]
    var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0
    
    
    //导航路径参数
    @Binding var path: [Int]
    
    
    //环境参数
    //@Environment(\.dismiss) var dismissIt
    //@Environment(\.presentationMode) var presentationMode
    
    
    
    //MARK: - 视图
    
    var body: some View {
        
        VStack{
            
            //填写表单
            Form{
                TextField("名称：", text: $name)
                Picker(selection: $type, label: Text("选择类型：")) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            
        }
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        //隐藏默认的返回按钮
        .navigationBarBackButtonHidden(true)
        //自定义按钮：通过给按钮设定语义，从而定位其位置
        .toolbar {
            //保存按钮：生成新的 ExpenseItem 存入 expenses 类
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let expense = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.insert(expense, at: 0)
                    path = []
                    //dismissIt()
                }
            }
            //取消按钮：什么都不做，但需要返回上一级根视图
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    path = []
                    //self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        

        
        
    }
    
}


//MARK: - 预览
#Preview {
    //AddView(expenses: Expenses())
    AddView(expenses: Expenses(), path: .constant([1]))
}
