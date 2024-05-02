//
//  IssueView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/30.
//

import SwiftUI

struct IssueView: View {
    
    //MARK: - 属性
    
    @ObservedObject var issue: Issue
    
    
    
    //MARK: - 视图
    var body: some View {
        
        Form {
            
            Section {
                
                VStack(alignment: .leading) {
                    
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)

                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                }

                Picker("Priority", selection: $issue.priority) {
                    Text("Low")
                    Text("Medium")
                    Text("High")
                }
                
            }
            
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    IssueView(issue: .example)
}
