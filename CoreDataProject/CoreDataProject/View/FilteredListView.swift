//
//  FilteredListView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

import CoreData
import SwiftUI




struct FilteredListView: View {
    
    
    //MARK: - 属性
    
    //这里只是声明存储我们的获取请求，以便可以在 body 内使用。但是不在这里创建获取请求（没有填 sortDescriptors），因为我们不确定要搜索什么。
    //相反，我们将创建一个自定义初始值设定项，它接受过滤器字符串并使用它来设置 fetchRequest 属性。
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    
    
    //MARK: - 视图
    var body: some View {
        List(fetchRequest, id: \.self) { 
            singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    
    
    //MARK: - 方法
    
    //自定义初始化方法：它接受过滤器字符串并使用它来设置 fetchRequest 属性
    //里面的参数 filter ，由上一个视图传入
    init(filter: String) {
        
        //这将使用当前的托管对象上下文运行获取请求。因为这个视图将在 ContentView 内部使用，所以我们甚至不需要将托管对象上下文注入到环境中，它将继承 ContentView 的上下文
        // _fetchRequest 开头有一个下划线，这是故意的。我们不是写入提取请求中的提取结果对象，而是写入一个全新的提取请求。通过分配给 _fetchRequest ，我们并不是想说“这是供您使用的一大堆新查询结果”，而是告诉 Swift 我们想要更改整个获取请求本身。
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
        
    }
    
    
}



//MARK: - 预览
//#Preview {
//    FilteredListView()
//        .environment(\.managedObjectContext, DataController().container.viewContext)
//}
