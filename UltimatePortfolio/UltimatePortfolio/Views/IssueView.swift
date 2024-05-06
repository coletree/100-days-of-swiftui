//
//  IssueView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/30.
//

import SwiftUI

struct IssueView: View {
    
    //MARK: - 属性
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController
    
    @ObservedObject var issue: Issue
    
    
    
    //MARK: - 视图
    var body: some View {
        
        Form {
            
            //第1部份：
            Section {
                VStack(alignment: .leading) {
                    //问题的标题
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                    //问题的修改时间
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    //问题的状态
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                }
                
                //由于CoreData那边使用 Integer 16 作为优先级属性，而 SwiftUI 认为 Int 值的 0 与 Int16 值的 0 不同。
                //因此，为了让这个选择器真正工作，我们不能直接用 tag(0)，而是需要一个类型转换。这是Core Data的缺点之一。
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                
                //在优先级选择器下方放置一个菜单，并在其中显示所有已选和未选定的标签
                Menu {
                    // show selected tags first
                    ForEach(issue.issueTags) { tag in
                        Button {
                            issue.removeFromTags(tag)
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }

                    // now show unselected tags
                    let otherTags = dataController.missingTags(from: issue)

                    if otherTags.isEmpty == false {
                        Divider()

                        Section("Add Tags") {
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    issue.addToTags(tag)
                                }
                            }
                        }
                    }
                } label: {
                    Text("Tags")
                        .multilineTextAlignment(.leading)
                }
            }
            
            //第2部份：
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField("Description", text: $issue.issueContent, prompt: Text("Enter the issue description here"), axis: .vertical) 
                }
            }
            
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    IssueView(issue: .example)
        .environmentObject(DataController.preview)
}
