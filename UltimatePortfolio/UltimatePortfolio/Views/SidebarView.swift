//
//  SidebarView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/28.
//

import SwiftUI




//MARK: - 最左侧导航栏视图
struct SidebarView: View {
    
    
    //MARK: - 属性
    
    
    //希望在 SidebarView 中显示过滤器列表，并允许用户选择一个过滤器，以便可以显示其问题。这需要以下步骤：
    
    //1. 创建一个变量来存储用户选择的过滤器
    //SwiftUI 提供了几种存储选择的方法来解决第一步，但目前最简单的方法是在 DataController 中添加一个已发布的属性
    
    //2. 从环境中读取共享的 DataController 实例，以便能够访问用户的标签
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController
    
    //3. 将所有这些放在一个简单的列表中
    
    //【智能过滤器】使用我们之前创建的 .all 和 .recent 值创建智能过滤器数组
    //静态属性：创建“智能分类”的数组，里面包括 “全部” 和 “最近” 两个实例
    let smartFilters: [Filter] = [.all, .recent]
    
    //【Tag过滤器】CoreData数据：获取所有 Tag 数据，按照 .name 排序
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    //计算属性：将所有 tag 转换为相应的过滤器 Filter 对象，再在列表中展示
    var tagFilters: [Filter] {
        //遍历 tags 所有数组元素进行处理，生成 Filter
        tags.map {
            tag in
            Filter(
                id: tag.id ?? UUID(),           // 过滤器的 id 用 tag 的id，为什么？
                name: tag.name ?? "No name",    // 过滤器的名称就用 tag 的名称
                icon: "tag", tag: tag           // 过滤器的图标就用 tag 的图标
            )
        }
    }
    
    

    
    //MARK: - 视图
    var body: some View {
        
        
        //列表：绑定环境变量 dataController 中的 selectedFilter 属性
        List(selection: $dataController.selectedFilter) {
            
            //列表第1部份：是一些固定的过滤器
            Section("Smart Filters") {
                ForEach(smartFilters) { 
                    filter in
                    //导航链接附加值为过滤器
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            //列表第2部份：读取所有 tag，转化成过滤器
            Section("Tags") {
                ForEach(tagFilters) { 
                    filter in
                    //导航链接附加值为过滤器
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
        }
        .toolbar {
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
        }
        
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    SidebarView()
        //预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
