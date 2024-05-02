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
    
    //计算属性：返回某个 tag 或者某个智能过滤器下的所有 Issue
    var issues: [Issue] {
        
        //获取用户选择的过滤器(如果获取不到，就默认是 "过滤器All" )，根据过滤器的 tag 属性去生成后面的 Issues
        let filter = dataController.selectedFilter ?? .all
        
        //声明所有Issue数组
        var allIssues: [Issue]
        
        //之前已将这两种类型打包为一个 Filter 类型，因此可以在两种类型之间进行选择。但现在是时候让它们的行为方式不同了
        //如果过滤器中存在特定标签，应该立即发回它的所有问题；
        if let tag = filter.tag {
            
            //第1个零合并：由于 tag 对象储存的 issues 属性类型为 NSSet，因此这里要转型为 [Issue]
            allIssues = tag.issues?.allObjects as? [Issue] ?? []
        } 
        //如果过滤器中没有标签，我们将发出一个提取请求 fetch(request)，以返回所有问题
        //然后在谓词中通过区分 modificationDate 属性，实现区分 all 和 recent 的效果
        //fetch 方法用于从持久化存储中获取数据。它接受一个 NSFetchRequest 类型的参数 request,用于定义要获取的数据。
        //NSFetchRequest 可以指定要获取的实体类型、过滤条件、排序等。
        else {
            let request = Issue.fetchRequest()
            
            //这告诉 Core Data 仅匹配自过滤器的最小修改日期以来修改的问题。可悲的是 as NSDate 这部分是必需的，因为 Core Data 不了解 Swift Date 的类型，而是需要较旧的 NSDate 类型。
            request.predicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            
            //第2个零合并：因为发出 fetch 请求可能会失败，所以用 try? 转为 optional 并使用零合并
            allIssues = (try? dataController.container.viewContext.fetch(request)) ?? []
        }

        //将所有问题排序后返回
        return allIssues.sorted()
        
    }
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //dataController 里储存了用户选择的 Issue，要和 List 的 selection 进行绑定
        List(selection: $dataController.selectedIssue) {
            
            ForEach(issues) { 
                issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: delete)
            
        }
        .navigationTitle("Issues")
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    //方法：在 ContentView 中添加滑动删除支持，使用新 delete() 方法
    func delete(_ offsets: IndexSet) {
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
