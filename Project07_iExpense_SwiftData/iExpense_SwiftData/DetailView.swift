//
//  DetailView.swift
//  iExpense
//
//  Created by coletree on 2023/12/19.
//
import SwiftData
import SwiftUI



struct DetailView: View {
    
    
    //MARK: - 属性
    
    //1.模型上下文用于创建 swiftData 对象
    @Environment(\.modelContext) var modelContext

    //2.等待传入的单笔消费对象
    var expense: ExpenseItem
    
    
    let types = ["Personal","Business"]
    @State private var name = ""
    @State private var type = ""
    @State private var amount = 0
    
    
    //导航路径参数
    //@Binding var path: [Int]
    
    //环境参数
    @Environment(\.dismiss) var dismissIt
    @Environment(\.presentationMode) var presentationMode




    //MARK: - 视图
    var body: some View {
        
        VStack{
            
            //消费对象的编辑表单
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
        .onAppear(perform: {
            self.name = expense.name
            self.type = expense.type
            self.amount = expense.amount
        })
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        //隐藏默认的返回按钮
        .navigationBarBackButtonHidden(true)
        //自定义按钮：通过给按钮设定语义，从而定位其位置
        .toolbar {
            //保存按钮：生成新的 ExpenseItem 存入 expenses 类
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    expense.name = name
                    expense.type = type
                    expense.amount = amount
                    //path = []
                    dismissIt()
                }
            }
            //取消按钮：什么都不做，但需要返回上一级根视图
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    //path = []
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
         }

        

        
    }
    
    
}



//MARK: - 预览
#Preview {
    do {
        //1.由于并不希望创建的模型容器实际存储任何内容；则需要创建【自定义配置】，告诉 SwiftData 仅将信息存储在内存中；
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        //2.使用刚刚的【自定义配置】，来创建一个模型容器；
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        //3. 这是准备好的 ExpenseItem 对象数据（这个不能放到前面，顺序不能换）
        let example = ExpenseItem(name: "title", type: "Personal", amount: 10)
        //4.返回以下内容给Preview；
        return DetailView(expense: example).modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
