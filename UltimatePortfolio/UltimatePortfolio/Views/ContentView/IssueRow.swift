//
//  IssueRow.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/30.
//

import SwiftUI




struct IssueRow: View {


    // MARK: - 属性

    // 环境属性：从环境中读取 dataController 实例
    // @EnvironmentObject var dataController: DataController

    // 订阅者属性：该属性是靠显式传入的。到时候在父视图中会传入
    // @ObservedObject var issue: Issue

    // 视图模型：引入该视图的视图模型
    @StateObject private var viewModel: ViewModel




    // MARK: - 视图
    // 在 IssueRow 里面，将放置相当多的信息，用户只需扫描行即可清楚地了解其当前状态
    var body: some View {

        // 重要的是会将所有这些信息封装在另一个 NavigationLink 中，该链接最终将为某个 issue 加载正确的详细信息视图
        // 这一行不能改成 viewModel
        NavigationLink(value: viewModel.issue) {

            HStack {

                // 高优先级的让它可见，否则它透明度为 0，根本不会出现。
                // 这可能看起来很浪费，但显示不可见的图像比什么都不显示要好得多，因为它可以确保我们所有的行都具有一致的间距
                // 如果我们完全排除图像视图，行的其余部分将向左移动以填充空间，并且看起来会很混乱
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(viewModel.iconOpacity)
                    // 增加用于 UI 测试的额外标识符
                    .accessibilityIdentifier(viewModel.iconIdentifier)

                VStack(alignment: .leading) {

                    Text(viewModel.issueTitle)
                        .font(.headline)
                        .lineLimit(1)

                    // 展示标签
                    Text(viewModel.issueTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                }

                Spacer()

                VStack(alignment: .trailing) {

                    // 方案1：(issue.issueCreationDate.formatted(date: .numeric, time: .omitted))
                    // 方案2：修改日期格式方便旁白读。但破坏了UI不好看。(issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted))
                    // 方案3：不改变 UI，只改变 accessibilityLabel 修饰符 
                    Text(viewModel.creationDate)
                        .accessibilityLabel(viewModel.accessibilityCreationDate)
                        .font(.subheadline)

                    if viewModel.completed {
                        Text("CLOSED")
                            .font(.body.smallCaps())
                    }

                }
                .foregroundStyle(.secondary)

            }

        }
        // 增加旁白：优先级高的时候要读出来
        .accessibilityHint(viewModel.accessibilityHint)

        // 增加用于 UI 测试的额外标识符
        .accessibilityIdentifier(viewModel.issueTitle)


    }




    // MARK: - 方法

    // 自定义初始化：引入视图模型
    init(issue: Issue) {
        let viewModel = ViewModel(issue: issue)
        _viewModel = StateObject(wrappedValue: viewModel)
    }




}




// MARK: - 预览
#Preview {
    IssueRow(issue: .example)
}
