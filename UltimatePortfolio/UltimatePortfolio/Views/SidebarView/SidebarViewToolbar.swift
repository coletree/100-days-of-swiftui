//
//  SidebarViewToolbar.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import SwiftUI


struct SidebarViewToolbar: View {


    // MARK: - 属性

    // 抽出视图后会收到错误，因为代码引用了 dataController 和 showingAwards ，所以添加以下两个新属性

    // 环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    // 状态属性：绑定父视图的 @State var showingAwards，从父视图移入子视图了
    @State private var showingAwards = false

    // 状态属性：创建超过3个tag时，点击按钮需要弹窗提示购买解锁
    @State private var showingStore = false

    // 状态属性：
    @State private var showingCommunity = false




    // MARK: - 视图
    var body: some View {

        // 按钮：创建测试数据。让它只在测试时有用
        #if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
        #endif

        // 按钮：切换 AwardView 是否打开
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
        // 徽章弹窗：将其从父视图移入子视图
        .sheet(isPresented: $showingAwards) {
            AwardsView()
        }

        // 按钮：新建 tag
        Button(action: tryNewTag) {
            Label("Add tag", systemImage: "plus")
        }
        // 购买弹窗：创建超过3个tag时，会弹出
        .sheet(isPresented: $showingStore, content: StoreView.init)


        // 按钮：测试CloudKit
        Button {
            showingCommunity.toggle()
        } label: {
            Label("iCloud", systemImage: "arrow.triangle.2.circlepath.icloud.fill")
        }
        .sheet(isPresented: $showingCommunity, content: SharedTagsView.init)


    }




    // MARK: - 方法

    // 方法：类似一个转发，为了修复按钮代码中的编译错误
    // 因为添加到 Button 按钮中的方法，必须是没有返回值的 Void ，而不能是返回 Bool
    // 因此，与其直接指向 dataController.newTag ，不如创建一个新方法，如果失败，该方法可以运行 newTag() 并显示购买页面
    func tryNewTag() {
        if dataController.newTag() == false {
            showingStore = true
        }
    }


}



// MARK: - 预览
#Preview {
    SidebarViewToolbar()
        // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
