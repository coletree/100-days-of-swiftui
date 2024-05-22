//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/23.
//

import SwiftUI


// MARK: - 中间列表视图
struct ContentView: View {


    // MARK: - 属性

    // 环境属性：从环境中读取 dataController 实例
    // @EnvironmentObject var dataController: DataController

    // 视图模型：引入该视图的视图模型
    @StateObject private var viewModel: ViewModel




    // MARK: - 视图
    var body: some View {

        // MARK: 列表
        // dataController 里储存了用户选择的 Issue，要和 List 的 selection 进行绑定
        List(selection: $viewModel.dataController.selectedIssue) {

            // MARK: 通过函数返回 issue 列表
            // 之前的计算属性 [issues] 被移到视图模型中了，并改成了方法
            ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)

        }
        .navigationTitle("Issues")

        // FIXME: 搜索框(让列表支持搜索)
        .searchable(
            text: $viewModel.dataController.filterText,
            tokens: $viewModel.dataController.filterTokens,
            suggestedTokens: .constant(viewModel.dataController.suggestedFilterTokens),
            prompt: "Filter issues, or type # to add tags") { tag in
                Text(tag.tagName)
            }

        // MARK: 标题栏过滤器控件 (已移入子视图)
        .toolbar { ContentViewToolbar() }

    }




    // MARK: - 方法

    // 自定义初始化：视图模型需要能够访问实例 DataController ，但无法从环境中读取该实例
    // 因此添加此初始值设定项，以实例化和存储视图模型状态对象
    init(dataController: DataController) {
        // 利用传入的 DataController 来创建视图模型
        let viewModel = ViewModel(dataController: dataController)
        // StateObject 是一个属性包装器，用于管理视图模型的生命周期，并确保视图在视图模型的状态改变时自动更新
        // _viewModel 是 @StateObject 属性包装器的底层存储器，在初始化时需要通过 wrappedValue 参数设置它的初始值
        // StateObject 应该在视图的初始化时设置，并且只能在初始化方法中设置一次
        _viewModel = StateObject(wrappedValue: viewModel)
    }


}




// MARK: - 预览
#Preview {
    ContentView(dataController: DataController.preview)
    // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
    // .environmentObject(DataController.preview)
}
