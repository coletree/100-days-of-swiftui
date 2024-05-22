//
//  SidebarViewModel.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/20.
//


// 在 MVVM 的视图模型中，应该避免使用任何 UI 的内容，所以干脆不要引入 SwiftUI ，以帮助检查
import CoreData
import Foundation
// import SwiftUI




/// 视图模型：放到对应视图的扩展中，这样不同的视图的视图模型都可以用一样的名字 ViewModel ，不会互相影响
extension SidebarView {

    // 视图模型需要能够自动更新 UI，这意味着要遵循 ObservableObject 协议（可被观察对象协议）
    // ObservableObject 是 Combine 框架的协议；如果改用 Observation 框架，则要换成 @Observable 宏
    // 于是，先创建一个新类，以便能够从任何监视的 SwiftUI 视图中报告更改
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {


        // MARK: - 属性

        // 全局数据模型：添加新属性来存储对全局数据控制器的访问
        var dataController: DataController

        // 1.智能过滤器：使用之前创建的 .all 和 .recent 值创建智能过滤器数组
        // 静态属性：创建智能过滤器数组 smartFilters ，里面包括 “全部” 和 “最近” 两个实例
        let smartFilters: [Filter] = [.all, .recent]

        // 2.Tag过滤器属性：读取 CoreData 的 tag 数据
        // @FetchRequest 只能用于视图，在视图模型中无效，改用手动方式获取
        // @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
        private let tagsController: NSFetchedResultsController<Tag>
        @Published var tags = [Tag]()


        // 计算属性：将获取到的所有 tag 数据，用 map 方法转换为相应的过滤器数组 [Filter]
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

        // 新建标签相关属性: 用 @Published 标注，以便每次更改都会更新相关视图
        // 1.重命名当前是否正在进行中
        @Published var renamingTag = false
        // 2.尝试重命名的标签
        @Published var tagToRename: Tag?
        // 3.新标签的名称
        @Published var tagName = ""




        // MARK: - 方法

        // 自定义初始化：初始化时人为注入全局数据模型 DataController
        init(dataController: DataController) {

            self.dataController = dataController

            // 创建 NSFetchRequest 加载数据。不会直接执行它，而是将其传递到 fetched results 中
            let request = Tag.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]

            tagsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            tagsController.delegate = self

            do {
                try tagsController.performFetch()
                tags = tagsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch tags")
            }

        }

        // 当尝试再次按下“添加样本”按钮时，会发现当前所有样本标签都会消失，准确说是行还保留，但内容将消失
        // 这是因为 “添加新的示例数据” 会清除当前拥有的所有内容，将其替换为新数据
        // 我们没有告诉 UI 在发生这些更改时如何更新，因此它只会看到我们之前拥有的所有标签的标题都消失了
        // 这就是 `NSFetchedResultsController` 委托的用武之地。
        // 如果我们在视图模型中实现 `controllerDidChangeContent()` 方法，那么当数据更改时，我们会收到通知。
        // 然后就可以提取新更新的对象并将其分配给 `tags` 数组，然后它将触发其 `@Published` 属性包装器以宣布对 UI 的更新

        // 方法：当 controller 的内容发生更改时，要自己指定如何更新UI
        // 这里指定执行 “提取新新对象，并将其分配给 tags 数组”，然后它将触发其 @Published 属性包装器，最终以实现 UI 的更新
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newTags = controller.fetchedObjects as? [Tag] {
                tags = newTags
            }
        }

        // 方法：定义一个删除方法，它接受要删除的过滤器。我们不允许删除智能过滤器，只能删除用户创建的过滤器
        func delete(_ filter: Filter) {
            guard let tag = filter.tag else {
                return
            }
            dataController.delete(tag)
            dataController.save()
        }

        // 方法：开始重命名 tag（输入 filter 进行修改）
        func rename(_ filter: Filter) {
            // 当开始重命名时，状态切换为 true，然后读取 filter 的名称和 tag
            tagToRename = filter.tag
            tagName = filter.name
            renamingTag = true
        }

        // 方法：完成重命名 tag
        func completeRename() {
            tagToRename?.name = tagName
            // 不需要将 Boolean 设置回 false，因为 alert 绑定 renamingTag 后会自动处理
            // 调用视图模型保存数据
            dataController.save()
        }

        // 方法：在 SidebarView 中添加滑动删除支持
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let item = tags[offset]
                // 由于已经在 dataController 类中添加了 delete 方法
                // 因此可以从 SidebarView 和 ContentView 中直接调用去删除 tag 和 issue
                dataController.delete(item)
            }
        }


    }

}
