//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/26.
//

import CoreData
import Foundation



//创建控制数据的类：它将处理加载数据，本地保存数据，同步到CloudKit，等工作
//这里要用 ObservableObject，不能用 Observable ，不然后面 delete 方法的 objectWillChange 属性就无法用
class DataController : ObservableObject {
    
    
    //MARK: - 属性
    
    //常量属性：创建容器，加载 Model 数据模型
    //let container = NSPersistentContainer(name: "Model")
    
    //常量属性：创建 CloudKit 的容器（前面已经在 CoreData 编辑器的配置中勾选了 used with Cloudkit）
    let container : NSPersistentCloudKitContainer
    

    //@Published属性：SwiftUI 提供了几种存储"用户选择过滤器"的方法，最简单的是添加 @Published 属性
    
    //1. 声明变量来存储用户选择的过滤器，它会通知订阅者。默认为“所有”
    @Published var selectedFilter: Filter? = Filter.all
    
    //2. 声明变量来存储用户选择的 Issue 问题，它会通知订阅者
    @Published var selectedIssue: Issue?
    
    
    
    
    //MARK: - 方法
    
    //方法：自定义初始化
    init(inMemory: Bool = false) {
        
        //给容器属性赋值（后面 Model 就是告诉程序要加载的数据库）
        container = NSPersistentCloudKitContainer(name: "Model")
        
        //如果布尔值为真，则禁用持久化存储功能
        if inMemory{
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        //设置：自动将【底层持久性存储发生的更改】应用于视图
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        //设置：合并策略为属性合并 mergeByPropertyObjectTrump，它允许将来自本地对象的更改与来自远程对象的更改按属性组合在一起
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        //设置：告诉 Core Data 在存储发生更改时收到通知
        container.persistentStoreDescriptions.first?.setOption(
                true as NSNumber,
                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )
        
        //设置：告诉系统在发生更改时调用新 remoteStoreChanged() 方法
        NotificationCenter.default.addObserver(
                forName: .NSPersistentStoreRemoteChange,
                object: container.persistentStoreCoordinator,
                queue: .main,
                using: remoteStoreChanged
        )
        
        //设置：容器读取数据库中的数据
        container.loadPersistentStores {
            storeDescription, error in
            //如果发生错误，则退出程序。error 是 optional 类型，所以用 if let 解包
            if let error{
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        
    }
    
    //方法: 将上下文中的 live 数据，持久化存储下来。存储前先检查是否有变化，节省资源
    func save(){
        if container.viewContext.hasChanges{
            try? container.viewContext.save()
        }
    }
    
    //方法: 删除实体对象。这里只限制对象要符合 NSManagedObject 协议，这样不管是 issue 还是 tag ，都可以用这个方法
    func delete(_ object: NSManagedObject){
        //当对象发生变化时，会向外界发出通知
        objectWillChange.send()
        //删除传入的对象
        container.viewContext.delete(object)
        //持久化保存下来
        save()
    }
    
    //方法：远程数据发生更改时进行以下处理
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    
    //方法：接受一个 issue 并返回一个包含它缺少的所有标签的数组
    //在内部加载所有可能存在的标签；计算当前未分配给问题的标签；对这些标签进行排序，然后将它们发回。
    func missingTags(from issue: Issue) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []

        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(issue.issueTags)

        return difference.sorted()
    }
    
    
    
    
    //MARK: - 测试专用
    
    //静态属性：为了方便后面视图的预览，创建一下预处理数据。
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    //方法: 添加测试数据
    func createSampleData(){
        
        //常量属性：获取容器的上下文，必须有上下文才能创建/修改数据，context会把数据存到内存
        let viewContext = container.viewContext
        
        for i in 1...5 {
            
            //生成 tag
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(i)"
            
            for j in 1...10{
                //生成 issue
                let issue = Issue(context: viewContext)
                issue.title = "Issue: \(i) - \(j)"
                issue.content = "问题的描述在这里"
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                issue.creationDate = .now
                //modificationDate 已经设置成了派生属性，由程序自动更新，无需自行设置
                //issue.modificationDate = .now
                
                //这个 addToIssues 方法是程序自动生成的实体类里带的
                tag.addToIssues(issue)
            }
        }
        
        //使用上下文 viewContext，调用 save 方法将数据写入持久化存储设备
        try? viewContext.save()
        
    }
    
    //方法: 创建批量删除所有数据的请求，以方便测试
    /*
     1. 在 Issue 上使用 FetchRequest 方法获取所有的 issue 实体对象（不需要指定任何过滤器）
     2. 将该获取请求包装在【批量删除请求】中，该请求告诉 Core Data 删除与请求匹配的所有对象，即所有 issue
     3. 在视图上下文上执行批量删除请求
     有个问题就是：运行批量删除请求需要读出每个已删除对象的核心数据标识符，然后将它们合并到实时视图上下文中。
     这比预期的工作量要多，所以我们将这部份单独封装在新的 delete() 方法中，这样至少可以重用。
    */
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>){
        
        //创建批量删除的请求：
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        //用什么来作为批量删除的唯一识别符呢？这里指定是 ObjectIDs
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        //然后让上下文执行【批量删除请求】，其执行后的返回结果转型为 NSBatchDeleteResult，赋值给 delete
        //delete 是 optional 类型，因此这里做解包，解包成功后才执行后续代码
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult{
            
            //changes 是一个字典 [NSDeletedObjectsKey: [ID数组] ]
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? [] ]
            //FIXME: 合并
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
        
    }
    
    //方法: 批量删除所有数据。（创建两个请求，调用前面的 delete 方法）
    func deleteAll(){
        
        //创建 tag 的批量删除请求，并执行
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        //创建 issue 的批量删除请求，并执行
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)
        
        //保存更改
        save()
        
    }
    
    
    
    
}
