//
//  ExpensesView.swift
//  iExpense_SwiftData
//
//  Created by coletree on 2024/1/4.
//
import SwiftData
import SwiftUI




struct ExpensesView: View {
    
    
    //MARK: - 属性
    
    //1.模型上下文用于创建 swiftData 对象
    @Environment(\.modelContext) var modelContext
    
    //2.读取数据
    @Query var expenses: [ExpenseItem]




    //MARK: - 视图
    var body: some View {
        
        List {
            ForEach(expenses) {
                item in
                NavigationLink(value: item) {
                    
                    HStack {
                        
                        //展示信息
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.type).foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        //展示金额
                        if item.amount < 10 {
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(Color.green)
                        } else if item.amount < 100 {
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(Color.orange)
                                .fontWeight(.bold)
                        } else {
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(Color.red)
                                .fontWeight(.bold)
                        }
                        
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: "USD")))")
                    .accessibilityHint(item.type)
                    
                    
                }
            }
            .onDelete(perform: removeItems)
        }
        
    }
    
    
    
    //MARK: - 方法
    
    //方法：自定义初始化：通过初始化方法来给属性赋值
    init(filter: Predicate<ExpenseItem>?, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(filter: filter, sort: sortOrder)
    }
    
    //方法：删除列表项（接受一个IndexSet类型的参数）：
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
    
    
}





//MARK: - 预览
#Preview {
    ExpensesView(
        filter: #Predicate<ExpenseItem> {
            item in
            item.type == "Personal"
        },
        sortOrder: [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount),
        ]
    )
    //这歌视图因为不需要创建 swiftData 对象，所以只需要给它一个上下文
    .modelContainer(for: ExpenseItem.self)
}


