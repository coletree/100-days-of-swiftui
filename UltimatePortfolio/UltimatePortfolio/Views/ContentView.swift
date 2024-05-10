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
        
        //MARK: 标题栏过滤器控件 (已移入子视图)
        .toolbar { ContentViewToolbar() }
        
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
