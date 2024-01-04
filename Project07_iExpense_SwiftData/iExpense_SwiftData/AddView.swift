//
//  AddView.swift
//  iExpense
//
//  Created by coletree on 2024/1/4.
//
import SwiftData
import SwiftUI



struct AddView: View {
    
    
    //MARK: - 属性
    
    //1.模型上下文用于创建 swiftData 对象
    @Environment(\.modelContext) var modelContext
    
    //2.使用动态导航路径
    //@Binding var path: NavigationPath
    
    //2.使用环境参数解除视图
    @Environment(\.dismiss) var dismissIt
    @Environment(\.presentationMode) var presentationMode
    
    //3. 界面参数
    let types = ["Personal","Business"]
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0




    //MARK: - 视图
    var body: some View {
        
        VStack{
            //用于创建对象的表单：绑定了前面的状态参数
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
        //导航标题绑定状态参数：可实现在标题处改标题的效果
        .navigationTitle($name)
        //导航标题绑定状态参数：
        .navigationBarTitleDisplayMode(.inline)
        //隐藏默认的返回按钮
        .navigationBarBackButtonHidden(true)
        //自定义按钮：通过给按钮设定语义，从而定位其位置
        .toolbar {
            //保存按钮：生成新的 ExpenseItem 存入 expenses 类
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let expense = ExpenseItem(name: name, type: type, amount: amount)
                    modelContext.insert(expense)
                    //path = []
                    dismissIt()
                }
            }
            //取消按钮：什么都不做，但需要返回上一级根视图
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    //path = []
                    dismissIt()
                    //self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        

        
        
    }
    
}



//MARK: - 预览
#Preview {
    AddView()
}
