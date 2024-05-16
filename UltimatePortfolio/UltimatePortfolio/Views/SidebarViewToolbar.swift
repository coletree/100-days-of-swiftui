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

        // 按钮：新建 tag
        Button(action: dataController.newTag) {
            Label("Add tag", systemImage: "plus")
        }

        // 徽章弹窗：将其从父视图移入子视图
        .sheet(isPresented: $showingAwards) {
            AwardsView()
        }

    }




    // MARK: - 方法




}



// MARK: - 预览
#Preview {
    SidebarViewToolbar()
        // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
