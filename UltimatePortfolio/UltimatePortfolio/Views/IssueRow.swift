//
//  IssueRow.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/30.
//

import SwiftUI




struct IssueRow: View {
    
    
    //MARK: - 属性

    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController
    
    //订阅者属性：该属性是靠显式传入的。到时候在父视图中会传入
    @ObservedObject var issue: Issue
    
    
    
    
    //MARK: - 视图
    //在 IssueRow 里面，将放置相当多的信息，用户只需扫描行即可清楚地了解其当前状态
    var body: some View {
        
        //重要的是会将所有这些信息封装在另一个 NavigationLink 中，该链接最终将为某个 issue 加载正确的详细信息视图
        NavigationLink(value: issue) {
            
            HStack {
                
                //高优先级的让它可见，否则它透明度为 0，根本不会出现。
                //这可能看起来很浪费，但显示不可见的图像比什么都不显示要好得多，因为它可以确保我们所有的行都具有一致的间距
                //如果我们完全排除图像视图，行的其余部分将向左移动以填充空间，并且看起来会很混乱
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(issue.priority == 2 ? 1 : 0)

                VStack(alignment: .leading) {
                    
                    Text(issue.issueTitle)
                        .font(.headline)
                        .lineLimit(1)

                    //展示标签
                    Text(issue.issueTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                }

                Spacer()

                VStack(alignment: .trailing) {
                    
                    //方案1：(issue.issueCreationDate.formatted(date: .numeric, time: .omitted))
                    //方案2：修改日期格式方便旁白读。但破坏了UI不好看。(issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted))
                    //方案3：不改变 UI，只改变 accessibilityLabel 修饰符
                    Text(issue.issueFormattedCreationDate)
                        .accessibilityLabel(issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)

                    if issue.completed {
                        Text("CLOSED")
                            .font(.body.smallCaps())
                    }
                    
                }
                .foregroundStyle(.secondary)
                
            }
            
        }
        //增加旁白：优先级高的时候要读出来
        .accessibilityHint(issue.priority == 2 ? "High priority" : "")

    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}



//MARK: - 预览
#Preview {
    IssueRow(issue: .example)
}
