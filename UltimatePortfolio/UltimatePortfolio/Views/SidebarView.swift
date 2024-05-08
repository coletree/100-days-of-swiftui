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

    
    //过滤器列表由两部分组成：
    
    // 1.智能过滤器：使用之前创建的 .all 和 .recent 值创建智能过滤器数组
        // 静态属性：创建智能过滤器数组 smartFilters ，里面包括 “全部” 和 “最近” 两个实例
        let smartFilters: [Filter] = [.all, .recent]
    
    // 2.Tag过滤器：读取 CoreData 的 tag 数据
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
    
    
    //用于新建 tag: 因为没有单独的页面，所以采用 alert 弹窗实现
    @State private var renamingTag = false           //重命名当前是否正在进行中
    @State private var tagToRename: Tag?             //尝试重命名的标签
    @State private var tagName = ""                  //新标签的名称
    
    
    //状态属性：跟踪奖项视图是否展示
    @State private var showingAwards = false
    
    

    
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
                            //设置长按上下文菜单
                            .contextMenu {
                                Button {
                                    rename(filter)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            }

                    }
                }
                //添加滑动删除
                .onDelete(perform: delete)
            }
            
        }
        //工具栏菜单
        .toolbar {
            
            //按钮：创建测试数据。让它只在测试时有用
            #if DEBUG
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
            #endif
            
            //按钮：新建 tag
            Button(action: dataController.newTag) {
                Label("Add tag", systemImage: "plus")
            }
            
            //按钮：切换 AwardView 是否打开
            Button {
                showingAwards.toggle()
            } label: {
                Label("Show awards", systemImage: "rosette")
            }

            
        }
        //弹窗：新建 tag，绑定 $renamingTag 布尔值
        .alert("Rename tag", isPresented: $renamingTag) {
            //完成按钮：点击后执行 “completeRename”
            Button("OK", action: completeRename)
            //取消按钮：点击后不需要设置，它会自动关闭弹窗并让绑定值恢复
            Button("Cancel", role: .cancel) { }
            //输入框：绑定状态属性 $tagName
            TextField("New name", text: $tagName)
        }
        //弹窗：
        .sheet(isPresented: $showingAwards) {
            AwardsView()
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
    
    //方法：开始重命名 tag（输入 filter 进行修改）
    func rename(_ filter: Filter) {
        //当开始重命名时，状态切换为 true，然后读取 filter 的名称和 tag
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    
    //方法：完成重命名 tag
    func completeRename() {
        tagToRename?.name = tagName
        //不需要将 Boolean 设置回 false，因为 alert 绑定 renamingTag 后会自动处理
        //调用视图模型保存数据
        dataController.save()
    }

    
    
}




//MARK: - 预览
#Preview {
    SidebarView()
        //预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
