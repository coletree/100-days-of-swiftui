//
//  AwardsView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/8.
//

import SwiftUI

struct AwardsView: View {


    // MARK: - 属性


    // 计算属性：定义将使用的列
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }

    // 环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    // 状态属性：控制徽章弹窗
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false

    var awardTitle: String {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
        }
    }



    // MARK: - 视图
    var body: some View {

        NavigationStack {

            ScrollView {

                // 将以 LazyVGrid 一系列按钮的形式显示奖励选项
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                // 从方法中返回颜色，
                                .foregroundColor(color(for: award))
                        }
                        // 增加旁白，从方法中返回旁白
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(award.description)

                    }
                }

            }
            .navigationTitle("Awards")
            // 徽章弹窗
            .alert(awardTitle, isPresented: $showingAwardDetails) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(selectedAward.description)
            }

        }

    }




    // MARK: - 方法

    /*
     之前代码中，会根据计算奖励来决定具体颜色以及辅助功能标签，但查看 body 代码的人其实不关心数据的计算方式，只关心它的使用方式
     于是我们把这两部份挪出来作为函数方法，这样除了简化 body 部分的代码外，还有一个额外好处是可以更轻松地编写测试代码
    */

    // 方法：根据 award 计算应该用什么颜色
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
    }

    // 方法：根据 award 计算应该用什么旁白
    // 这里返回的值类型是 LocalizedStringKey ，这意味着它在运行时会由 SwiftUI 自动本地化
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked"
    }




}




// MARK: - 预览
#Preview {
    AwardsView()
    // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
    .environmentObject(DataController.preview)
}
