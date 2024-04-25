//
//  GenericsFilterListView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

//MARK: - 该视图支持泛型的动态数据获取


//MARK: - 添加 CoreData 的导入，以便可以引用 NSManagedObject
import CoreData
import SwiftUI


struct FilteredList<T: NSManagedObject, Content: View>: View {
    
    //MARK: - 创建核心数据查询请求
    @FetchRequest var fetchRequest: FetchedResults<T>

    //MARK: - content闭包，列表中的每个元素会调用一次
    let content: (T) -> Content
    
    //MARK: - 定义视图的内容，它由传入的 content 闭包决定，但我们也可以给它外面包上其他视图结构
    var body: some View {
        //在该例子中，传入的 content 闭包会包含在 List 里面
        List(fetchRequest, id: \.self) {
            item in
            self.content(item)
        }
    }

    //MARK: - 初始化方法接受3个参数：用于过滤的键、具体过滤值、以及视图闭包
    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(
                sortDescriptors: [],
                predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue)
              )
        self.content = content
    }
    
}



//MARK: - 预览
//#Preview {
//    GenericsFilterListView()
//        .environment(\.managedObjectContext, DataController().container.viewContext)
//}
