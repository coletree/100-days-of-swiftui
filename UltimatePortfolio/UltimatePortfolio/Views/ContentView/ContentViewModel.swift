//
//  ContentViewModel.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/21.
//


// 在 MVVM 的视图模型中，应该避免使用任何 UI 的内容，所以干脆不要引入 SwiftUI ，以帮助检查
import CoreData
import Foundation




/// 视图模型：放到对应视图的扩展中，这样不同的视图的视图模型都可以用一样的名字 ViewModel ，不会互相影响
extension ContentView {

    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {


        // MARK: - 属性

        // 全局数据模型：添加新属性来存储对全局数据控制器的访问
        var dataController: DataController

        // 计算属性：是否应该展示评分弹窗
        var shouldRequestReview: Bool {
            dataController.count(for: Tag.fetchRequest()) >= 5
        }



        // MARK: - 方法

        // 自定义初始化：初始化时人为注入全局数据模型 DataController
        init(dataController: DataController) {
            self.dataController = dataController
        }

        // 方法：在 ContentView 中添加滑动删除支持
        func delete(_ offsets: IndexSet) {
            // 一开始从视图模型中调用 issuesForSelectedFilter 返回数组
            let issues = dataController.issuesForSelectedFilter()
            for offset in offsets {
                let item = issues[offset]
                // 由于已经在 dataController 类中添加了 delete 方法
                // 因此可以从 SidebarView 和 ContentView 中直接调用去删除 tag 和 issue
                dataController.delete(item)
            }
        }


    }

}
