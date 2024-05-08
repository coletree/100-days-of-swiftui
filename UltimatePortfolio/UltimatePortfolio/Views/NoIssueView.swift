//
//  NoIssueView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/30.
//

import SwiftUI




struct NoIssueView: View {


    //MARK: - 属性
    
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController

    
    
    
    //MARK: - 视图
    var body: some View {
        
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("New Issue") {
            // make a new issue
            dataController.newIssue()
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    NoIssueView()
}
