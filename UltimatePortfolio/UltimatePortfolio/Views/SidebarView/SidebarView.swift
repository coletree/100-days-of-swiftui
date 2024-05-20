//
//  SidebarView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/28.
//

import SwiftUI




// MARK: - 最左侧导航栏视图
// SidebarView 中会显示【过滤器列表】，并允许用户选择具体过滤器，从而显示该过滤器下的所有 issues
struct SidebarView: View {


    // MARK: - 属性

    // 环境属性：从环境中读取 dataController 实例
    // @EnvironmentObject var dataController: DataController

    // 视图模型：引入该视图的视图模型
    @StateObject private var viewModel: ViewModel




    // MARK: - 视图
    var body: some View {

        // 列表：绑定环境变量 dataController 中的 selectedFilter 属性
        // 于是当用户选择列表的过滤器时，就会改变 dataController 属性，可以传递到后面的视图
        List(selection: $viewModel.dataController.selectedFilter) {

            // 第1部份：固定的智能过滤器 smartFilters
            Section("Smart Filters") {
                ForEach(viewModel.smartFilters) { filter in
                    // 已抽出子视图
                    SmartFilterRow(filter: filter)
                }
            }

            // 第2部份：读取所有 tag 并转化成过滤器 tagFilters
            Section("Tags") {
                ForEach(viewModel.tagFilters) { filter in
                    // 把 filter 和 rename方法，和 delete方法都传入子视图
                    UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
                }
                // 添加滑动删除
                .onDelete(perform: delete)
            }

        }
        // 工具栏菜单
        // 或写成 .toolbar(content: SidebarViewToolbar.init)
        .toolbar {
            SidebarViewToolbar()    // 抽出了子视图
        }
        // 弹窗：新建 tag，绑定 $renamingTag 布尔值
        .alert("Rename tag", isPresented: $viewModel.renamingTag) {
            // 完成按钮：点击后执行 “completeRename”
            Button("OK", action: viewModel.completeRename)
            // 取消按钮：点击后不需要设置，它会自动关闭弹窗并让绑定值恢复
            Button("Cancel", role: .cancel) { }
            // 输入框：绑定状态属性 $tagName
            TextField("New name", text: $viewModel.tagName)
        }
        // 导航标题
        .navigationTitle("Filters")

    }




    // MARK: - 方法

    // 自定义初始化：视图模型需要能够访问实例 DataController ，但无法从环境中读取该实例
    // 因此自定义初始化方法，从这里传入 DataController
    init(dataController: DataController) {
        // 利用传入的 DataController 来创建视图模型
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // 方法：在 SidebarView 中添加滑动删除支持
    // 该方法属于和 UI 相关的方法，所以不需要移到视图模型中
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = viewModel.tags[offset]
            // 由于已经在 dataController 类中添加了 delete 方法
            // 因此可以从 SidebarView 和 ContentView 中直接调用去删除 tag 和 issue
            viewModel.dataController.delete(item)
        }
    }

}




// MARK: - 预览
#Preview {
    // SidebarView(viewModel: DataController.preview)
    // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
    SidebarView(dataController: DataController.preview)
    // 使用 MVVM 架构后，从初始化中获得数据控制器，不再使用环境对象获取，删除它
    // .environmentObject(DataController.preview)
}
