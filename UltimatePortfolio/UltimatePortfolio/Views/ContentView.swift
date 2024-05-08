//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/23.
//

import SwiftUI


//MARK: - 中间列表视图
struct ContentView: View {
    
    
    //MARK: - 属性
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    
    
    
    //MARK: - 视图
    var body: some View {
        
        //MARK: 列表
        //dataController 里储存了用户选择的 Issue，要和 List 的 selection 进行绑定
        List(selection: $dataController.selectedIssue) {
            
            //MARK: 通过函数返回 issue 列表
            //之前的计算属性 [issues] 被移到视图模型中了，并改成了方法
            ForEach(dataController.issuesForSelectedFilter()) {
                issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: delete)
            
        }
        .navigationTitle("Issues")
        
        //FIXME: 搜索框(让列表支持搜索)
        .searchable(
            text: $dataController.filterText,
            tokens: $dataController.filterTokens,
            suggestedTokens: .constant(dataController.suggestedFilterTokens),
            prompt: "Filter issues, or type # to add tags") {
                tag in
                Text(tag.tagName)
            }
        
        //MARK: 标题栏过滤器控件
        .toolbar {
            
            //菜单: 用于过滤
            Menu{
                
                //切换按钮：控制过滤器是否开启
                Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                    dataController.filterEnabled.toggle()
                }

                //分隔符
                Divider()

                //排序选项菜单：影响数据模型的 SortType 和 sortNewestFirst
                Menu("Sort By") {
                    
                    //Picker选择器：绑定 SortType 的实例
                    Picker("Sort By", selection: $dataController.sortType) {
                        Text("Date Created").tag(SortType.dateCreated)
                        Text("Date Modified").tag(SortType.dateModified)
                    }

                    //分隔符
                    Divider()

                    //Picker选择器：绑定布尔值 sortNewestFirst
                    Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                        Text("Newest to Oldest").tag(true)
                        Text("Oldest to Newest").tag(false)
                    }
                    
                }

                //状态选项：如果过滤器关闭，则禁用
                Picker("Status", selection: $dataController.filterStatus) {
                    Text("All").tag(Status.all)
                    Text("Open").tag(Status.open)
                    Text("Closed").tag(Status.closed)
                }
                .disabled(dataController.filterEnabled == false)

                //优先级选项：如果过滤器关闭，则禁用
                Picker("Priority", selection: $dataController.filterPriority) {
                    Text("All").tag(-1)
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }
                .disabled(dataController.filterEnabled == false)
                
            }
            label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .symbolVariant(dataController.filterEnabled ? .fill : .none)
            }
            
            //按钮：创建新 issue
            Button(action: dataController.newIssue) {
                Label("New issue", systemImage: "square.and.pencil")
            }

        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    //方法：在 ContentView 中添加滑动删除支持
    func delete(_ offsets: IndexSet) {
        //一开始从视图模型中调用 issuesForSelectedFilter 返回数组
        let issues = dataController.issuesForSelectedFilter()
        for offset in offsets {
            let item = issues[offset]
            //由于已经在 dataController 类中添加了 delete 方法
            //因此可以从 SidebarView 和 ContentView 中直接调用去删除 tag 和 issue
            dataController.delete(item)
        }
    }
    
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
        //预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
