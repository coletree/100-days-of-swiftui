//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/23.
//

import CoreData
import SwiftUI




@main
struct UltimatePortfolioApp: App {


    // MARK: - 属性

    // 状态属性：实作视图模型 DataController
    @StateObject var dataController = DataController()

    // 环境属性：获取当前应用状态
    @Environment(\.scenePhase) var scenePhase




    // MARK: - 根视图
    var body: some Scene {
        WindowGroup {
            // 定义一个三栏布局
            // NavigationSplitView(// preferredCompactColumn: .constant(.detail)){
            NavigationSplitView {
                SidebarView(dataController: dataController)
            } content: {
                ContentView()
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
