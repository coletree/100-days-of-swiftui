//
//  ContentView.swift
//  iExpense
//
//  Created by coletree on 2023/12/7.
//
import Observation
import SwiftUI


struct ContentView: View {
    
    
    //使用 @State 可以使对象保持活动状态，实际上是 @Observable宏赋予SwiftUI监视对象任何更改的能力
    @State private var expenses = Expenses()
    
    //添加视图的显示状态
    @State private var showingAddExpense = false
    
    //导航路径参数
    @State private var path = [Int]()
    
    
    var body: some View {
        
        
        //NavigationStack{
        NavigationStack(path: $path){
            
            
            List {
                //类别1-个人: 读取 expenses 类的 itemsA 属性
                Section {
                    ForEach(expenses.itemsA) {
                        item in
                        NavigationLink(
                            destination: DetailView(expenses: Expenses(), expense: item)
                        ){
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                if item.amount < 10{
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .foregroundStyle(Color.green)
                                }else if item.amount < 100{
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .foregroundStyle(Color.orange)
                                        .fontWeight(.bold)
                                }else{
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .foregroundStyle(Color.red)
                                        .fontWeight(.bold)
                                }
                            }
                        }

                    }
                    .onDelete(perform: removeItems)
                }
                
                //类别2-企业: 读取 expenses 类的 itemsB 属性
                Section {
                    ForEach(expenses.itemsB) {
                        item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            if item.amount < 10{
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(Color.green)
                            }else if item.amount < 100{
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(Color.orange)
                                    .fontWeight(.bold)
                            }else{
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(Color.red)
                                    .fontWeight(.bold)
                            }
                            
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }

            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add", value: 1)
            }
            .navigationDestination(for: Int.self) {
                selection in
                AddView(expenses: expenses, path: $path)
            }
            
        }
        .ignoresSafeArea()
        
        
    }
    
    
    //删除列表项的方法（接受一个IndexSet类型的参数）：
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}




//预览
#Preview {
    ContentView()
}
