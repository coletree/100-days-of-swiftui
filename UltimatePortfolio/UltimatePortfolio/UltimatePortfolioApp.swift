//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/23.
//

import CoreData
import CoreSpotlight
import SwiftUI




@main
struct UltimatePortfolioApp: App {


    // MARK: - 属性

    // 状态属性：使用 @StateObject 创建并持有 DataController 实例，该实例生命周期和根视图一致
    @StateObject var dataController = DataController()

    // 环境属性：获取当前应用状态
    @Environment(\.scenePhase) var scenePhase

    // 应用程序委托：告诉 SwiftUI 使用应用委托类 AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate




    // MARK: - 根视图
    var body: some Scene {
        WindowGroup {
            // 定义一个三栏布局
            // NavigationSplitView(// preferredCompactColumn: .constant(.detail)){
            NavigationSplitView {
                SidebarView(dataController: dataController)
            } content: {
                ContentView(dataController: dataController)
            } detail: {
                DetailView()
            }
            // 把视图模型 dataController 放入环境中
            .environmentObject(dataController)
            // 把 dataController 中的上下文，赋予环境变量 managedObjectContext
            .environment(\.managedObjectContext, dataController.container.viewContext)
            // 监视环境属性 scenePhase，如果发现应用所处阶段有变化，则触发后面闭包
            .onChange(of: scenePhase) { _, newValue in
                if newValue != .active {
                    dataController.save()
                }
            }
            // 当用户从 spotlight 跳转进来时，执行 loadSpotlightItem 方法
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)


        }
    }




    // MARK: - 方法

    /// 方法：处理用户从 spotlight 搜索结果跳转进来的行为。该方法接受任何类型的 NSUserActivity ，然后查看数据以从 Spotlight 中找到唯一标识符
    func loadSpotlightItem(_ userActivity: NSUserActivity) {

            // NSUserActivity 有一个 userInfo 字典，我们需要在里面挖掘一个特定的 Core Spotlight 键来读出 Issue 的标识符
            // 如果字典存在，如果键存在，并且它的值是字符串，那么我们将使用它
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {

            // 使用之前编写的 DataController 的 issue(with:) 方法，可以获取标识符字符串并发回匹配 Issue 对象
            // 我们调用它来查找点击的任何 Issue，并将其赋予 dataController 的 selectedIssue，并将选择的过滤器设置为 .all
            dataController.selectedIssue = dataController.issue(with: uniqueIdentifier)
            dataController.selectedFilter = .all

        }

    }


}




/*
 本项目分为三个部分，分别是：
 1.构建核心应用程序，我们将在其中查看 SwiftUI、核心数据、架构、测试、可访问性、文档、网络、本地化等。
 2.与系统集成，我们将研究 StoreKit、Core Spotlight、小部件、通知、触觉等。
 3.针对每个平台进行设计，我们将扩展我们的基础 iOS 应用程序，以便在 macOS 和 watchOS 上同样运行。
 
 - 只有第1部分是必须的。每个人都必须完全按照第一部分的顺序进行操作，这很重要，因为这是我们构建应用程序核心的地方。
 - 完成第1部分后，您可以按照您想要的任何顺序完成第 2 部分或第 3 部分中的任何或全部 - 它们都是可选的，并且或多或少都是独立的。
 - 整个项目适用于 iOS 16、macOS Ventura 和 watchOS 9 的 Xcode 14 ，但它在未来的版本中应该会很好用。
 - 建议您拥有 Apple 开发者计划的活跃帐户，但我认为除了 StoreKit 等之外不需要它。
*/
