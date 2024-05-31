//
//  GenericsFilterListView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

/// 该视图支持泛型的动态数据获取，由父视图传入（具体请求 + 列表样式的闭包）给该视图生成界面


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

    
    //MARK: - 初始化方法
    
    //写法1：接受3个参数 —— 用于过滤的键、用于过滤的值、以及视图闭包
//    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
//        _fetchRequest = FetchRequest<T>(
//                sortDescriptors: [],
//                // %K 代表过滤的键； %@ 代表后面的值
//                predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue)
//        )
//        self.content = content
//    }
    
    //写法2：加入字符串参数
//    init(type: String = "CONTAINS[c]", filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
//        _fetchRequest = FetchRequest<T>(
//            sortDescriptors: [],
//            // %K 代表过滤的键； \(type)代表传入的字符串； %@ 代表后面的值
//            predicate: NSPredicate(format: "%K \(type) %@", filterKey, filterValue)
//        )
//        self.content = content
//    }
    
    //写法3：接受枚举，而不是字符串。因为字符串会容易拼错，使用枚举确保安全
//    init(type: FilterType = .contains, filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
//        _fetchRequest = FetchRequest<T>(
//            sortDescriptors: [],
//            predicate: NSPredicate(format: "%K \(type.rawValue) %@", filterKey, filterValue)
//        )
//        self.content = content
//    }
    
    //写法4：
//    init(
//            type: FilterType = .beginsWith,
//            filterKey: String,
//            filterValue: String,
//            sortDescriptors: [SortDescriptor<T>] = [],
//            @ViewBuilder content: @escaping (T) -> Content
//    ) {
//        _fetchRequest = FetchRequest<T>(
//                sortDescriptors: sortDescriptors,
//                predicate: NSPredicate(format: "%K \(type.rawValue) %@", filterKey, filterValue)
//            )
//        self.content = content
//    }
    
    
    //写法5：
    init(
            type: FilterType = .beginsWith,
            filterKey: String? = nil,
            filterValue: String? = nil,
            sortDescriptors: [SortDescriptor<T>] = [],
            @ViewBuilder content: @escaping (T) -> Content
    ) {
            if let filterKey = filterKey, let filterValue = filterValue {
                _fetchRequest = FetchRequest<T>(
                    sortDescriptors: sortDescriptors,
                    predicate: NSPredicate(format: "%K \(type.rawValue) %@", filterKey, filterValue)
                )
            } else {
                _fetchRequest = FetchRequest<T>(
                    sortDescriptors: sortDescriptors
                    // 没有谓词即不过滤
                )
            }
            self.content = content
    }



}



enum FilterType: String {
    case beginsWith = "BEGINSWITH"
    case contains = "CONTAINS[c]"
}



//MARK: - 预览
//#Preview {
//    GenericsFilterListView()
//        .environment(\.managedObjectContext, DataController().container.viewContext)
//}
