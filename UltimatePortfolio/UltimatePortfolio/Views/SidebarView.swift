//
//  SidebarView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/28.
//

import SwiftUI




//MARK: - 最左侧导航栏视图
//SidebarView 中会显示【过滤器列表】，并允许用户选择具体过滤器，从而显示该过滤器下的所有 issues
struct SidebarView: View {


    //MARK: - 属性
    
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    
    //【过滤器列表】由两部分组成：【智能过滤器数组】+【Tag过滤器数组】
    
    //【智能过滤器】部分使用之前创建的 .all 和 .recent 值创建智能过滤器数组
    // 静态属性：创建智能过滤器数组 smartFilters ，里面包括 “全部” 和 “最近” 两个实例
    let smartFilters: [Filter] = [.all, .recent]
    
    //【Tag过滤器】部分要读取 CoreData 数据：
    // @FetchRequest 获取所有 Tag 数据，按照 .name 排序
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    //计算属性：将获取到的所有 tag 数据，用 map 方法转换为相应的过滤器数组 [Filter]
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(
                id: tag.tagID,            // 过滤器的 id 用 tag 的id，为什么？
                name: tag.tagName,        // 过滤器的名称就用 tag 的名称
                icon: "tag",              // 过滤器的图标就用 tag 的图标
                tag: tag
            )
        }
    }
    
    

    
    //MARK: - 视图
    var body: some View {
        
        //列表：绑定环境变量 dataController 中的 selectedFilter 属性
        //于是当用户选择列表的过滤器时，就会改变 dataController 属性，可以传递到后面的视图
        List(selection: $dataController.selectedFilter) {
            
            //第1部份：固定的智能过滤器 smartFilters
            Section("Smart Filters") {
                ForEach(smartFilters) { 
                    filter in
                    //导航链接附加值为过滤器
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            //第2部份：读取所有 tag 并转化成过滤器 tagFilters
            Section("Tags") {
                ForEach(tagFilters) { 
                    filter in
                    //导航链接附加值为过滤器
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                            //在侧边栏中每个标签旁边显示其活动问题的数量
                            .badge(filter.tag?.tagActiveIssues.count ?? 0)
                    }
                }
                //添加滑动删除
                .onDelete(perform: delete)
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
    
    //方法：在 SidebarView 中添加滑动删除支持，使用新 delete() 方法
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            //由于已经在 dataController 类中添加了 delete 方法
            //因此可以从 SidebarView 和 ContentView 中直接调用去删除 tag 和 issue
            dataController.delete(item)
        }
    }

    
    
}




//MARK: - 预览
#Preview {
    SidebarView()
        //预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
