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
    
    //ObservedObject属性：该属性是在父视图列表中传入的
    //selectedIssue 属性是可选的，应用开始时不会选定任何内容。但当它达到 IssueView 该属性时，它肯定应该有值。
    //因此与其让 IssueView 读取可选值，不如为其提供一个非可选 Issue 属性
    @ObservedObject var issue: Issue
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        Form {
            
            //第1部份：标题、修改日期、优先级...
            Section {
                VStack(alignment: .leading) {
                    //标题: 与 issue 的 issueTitle 绑定
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                    //修改时间：仅展示
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    //状态: 与 issue 的 issueStatus 绑定
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                }
                
                //优先级: 与 issue 的 priority 绑定
                //由于CoreData那边使用 Integer 16 作为优先级属性，而 SwiftUI 认为 Int 值的 0 与 Int16 值的 0 不同。
                //因此，为了让这个选择器真正工作，我们不能直接用 tag(0)，而是需要一个类型转换。这是Core Data的缺点之一。
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                
                
                //该视图有个复杂的部分就是tag：需要提供一种方法让用户选择多个tag，这很棘手，因为内置 Picker 视图只支持单个选择
                //这意味着我们需要自己设置一些东西，理想情况下，用户可以很容易地预先看到他们的所有标签，并快速添加或删除标签
                //目前最有效的解决方案是使用包含所有【选定】和【未选定】标签的 Menu 视图
                //对【选定】标签，我们之前已经创建了 issueTags 属性，可以直接读取
                //对【未选定】标签，需要在 DataController 添加代码对比issue标签和所有标签，即“返回所有该Issue没有的标签”。这是 Swift 里集合的内置方法 symmetricDifference ，具体定义参见 DataController 中的 missingTags 方法
                //标签：用 Menu 显示所有已选和未选定的标签（连续闭包写法，label是第二个闭包）
                Menu {
                    //1.先展示该 issue 有的标签
                    ForEach(issue.issueTags) { tag in
                        Button {
                            //该删除方法是 coreData 数据模型自动生成的
                            issue.removeFromTags(tag)
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }
                    
                    //2.再展示该 issue 没有的标签
                    let otherTags = dataController.missingTags(from: issue)
                    if otherTags.isEmpty == false {
                        Divider()
                        Section("Add Tags") {
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    //该添加方法是 coreData 数据模型自动生成的
                                    issue.addToTags(tag)
                                }
                            }
                        }
                    }
                }
                label: {
                    //直接将有的 tag 名称作为标题
                    //Text("Tags").multilineTextAlignment(.leading)
                    Text(issue.issueTagsList)
                        .multilineTextAlignment(.leading)
                        //防止文本截断，把宽度设到最大
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //防止文本动画
                        .animation(nil, value: issue.issueTagsList)
                }

                
            }
            
            //第2部份：编辑 Issue 内容
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    //内容: 与 issue 的 issueContent 绑定
                    //这里用一个可自动扩展的单行输入框 TextField，而不是 TextEditor
                    TextField(
                        "Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical
                    )
                }
            }
            
            
        }
        //isDeleted属性也是 coredata 自动生成的，表示【该对象已删除】
        .disabled(issue.isDeleted)
        
    }
    
    
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    IssueView(issue: .example)
        .environmentObject(DataController.preview)
}
