//
//  ContentView.swift
//  iExpense
//
//  Created by coletree on 2024/1/4.
//
import Observation
import SwiftData
import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    
    //1.模型上下文
    @Environment(\.modelContext) var modelContext
    
    //2.设置属性储存排序方式
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount, order: .reverse),
    ]
    
    //3.设置属性储存过滤方式
    @State private var filterString = "All"
    
    
    var filterType : Predicate<ExpenseItem>? {
        if filterString == "Personal"{
            return #Predicate<ExpenseItem> { 
                item in
                item.type == "Personal"
            }
        }else if filterString == "Business"{
            return #Predicate<ExpenseItem> {
                item in
                item.type == "Business"
            }
        }else{
            return nil
        }
    }
    
    
    
    
    
    //3. 储存导航路径参数
    @State private var path = NavigationPath()
    
    
    


    
    
    //MARK: - 视图
    var body: some View {
        
        //NavigationStack 使用编程动态导航
        NavigationStack(path: $path){
            
            //把具体列表抽出成子视图了，这样读取数据的代码能放到子视图，这样能利用子视图的初始化方法做数据刷新；
            //子视图接受参数1：过滤的方法
            //子视图接受参数2：排序方法的 sortOrder
            ExpensesView(filter: filterType, sortOrder: sortOrder)
            
            //导航标题
            .navigationTitle("iExpense")
            //工具栏
            .toolbar {
                
                //按钮：筛选显示的数据
                Menu("Type", systemImage: "line.3.horizontal.decrease.circle") {
                    Picker("Filter", selection: $filterString) {
                        Text("All").tag("All")
                        Divider()
                        Text("Personal").tag("Personal")
                        Text("Business").tag("Business")
                    }
                }
                
                //按钮：控制排序逻辑。和状态参数绑定，最终传入到子视图
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    //用 tag 修饰符，包裹具体选项的值（可以是任何值）。该值与状态属性绑定
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name").tag(
                            [
                                SortDescriptor(\ExpenseItem.name),
                                SortDescriptor(\ExpenseItem.amount, order: .reverse),
                            ]
                        )
                        Text("Sort by amount").tag(
                            [
                                SortDescriptor(\ExpenseItem.amount, order: .reverse),
                                SortDescriptor(\ExpenseItem.name)
                            ]
                        )
                    }
                }
                
                //按钮：导航去新增页面。通过整数类型指定目的地
                NavigationLink("Add", value: 1)
                
            }
            //当NavigationLink的值为整数时，导航去新增页面
            .navigationDestination(for: Int.self) { 
                selection in
                AddView()
            }
            //当NavigationLink的值为 ExpenseItem 时，导航去 DetailView 页面
            .navigationDestination(for: ExpenseItem.self) {
                selection in
                DetailView(expense: selection)
            }
            
        }
        .ignoresSafeArea()
        
        
    }
    
    
    
    //MARK: - 方法
    


    
}




//MARK：- 预览
#Preview {
    ContentView()
}
