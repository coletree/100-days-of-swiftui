//
//  DetailView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/28.
//

import SwiftUI



//MARK: - 右侧详情视图
struct DetailView: View {
    
    
    //MARK: - 属性
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController
    
    
    
    
    //MARK: - 视图
    //DetailView 要根据用户现在是否选择了某些内容，决定显示 IssueView 或 NoIssueView
    var body: some View {
        
        VStack {
            //如果 selectedIssue 有值，就展示 IssueView
            if let issue = dataController.selectedIssue {
                IssueView(issue: issue)
            }
            //如果 selectedIssue 无值，就展示 NoIssueView
            else {
                NoIssueView()
            }
        }
        .navigationTitle("Details")
        //由于这是详细信息视图，Apple 建议我们使用内联导航栏样式
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    DetailView()
        .environmentObject(DataController.preview)
}
