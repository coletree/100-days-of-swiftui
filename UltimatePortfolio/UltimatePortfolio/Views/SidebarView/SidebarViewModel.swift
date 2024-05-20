//
//  SidebarViewModel.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/20.
//

// 在 MVVM 的视图模型中，应该避免使用任何 UI 的内容，所以干脆不要引入 SwiftUI ，以帮助检查
import CoreData
import Foundation
import SwiftUI




/// 视图模型：放到对应视图的扩展中，这样不同的视图的视图模型都可以用一样的名字
extension SidebarView {

    // 首先要创建一个使用 Observable 宏的新类，以便我们能够从任何监视的 SwiftUI 视图中报告更改
    // ObservableObject 是 Combine 框架的协议；如果改用 Observation 框架则换成 @Observable 宏
    class ViewModel: ObservableObject {


        // MARK: - 属性

        // 全局数据模型：添加新属性来存储对全局数据控制器的访问
        var dataController: DataController

        // 过滤器列表属性：
        // 1.智能过滤器：使用之前创建的 .all 和 .recent 值创建智能过滤器数组
            // 静态属性：创建智能过滤器数组 smartFilters ，里面包括 “全部” 和 “最近” 两个实例
            let smartFilters: [Filter] = [.all, .recent]

        // 2.Tag过滤器属性：读取 CoreData 的 tag 数据
            // @FetchRequest 获取所有 Tag 数据，按照 .name 排序
            @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>

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

        // 新建标签相关属性: 因为没有单独的页面，所以采用 alert 弹窗实现
        // 1.重命名当前是否正在进行中
        var renamingTag = false
        // 2.尝试重命名的标签
        var tagToRename: Tag?
        // 3.新标签的名称
        var tagName = ""


        // MARK: - 方法

        // 自定义初始化：初始化时人为传入全局数据模型
        init(dataController: DataController) {
            self.dataController = dataController
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


    }

}
