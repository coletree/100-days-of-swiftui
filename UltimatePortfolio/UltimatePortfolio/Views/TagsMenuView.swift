//
//  TagsMenuView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import SwiftUI


struct TagsMenuView: View {
    
    
    //MARK: - 属性
    
    //抽出视图后会收到错误，因为代码引用了 dataController 和 showingAwards ，所以添加以下两个新属性
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController
    
    //ObservedObject属性：该属性是在父视图列表中传入的。如果不用 ObservedObject ，后面无法绑定
    @ObservedObject var issue : Issue
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
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
    
    
}




//MARK: - 预览
#Preview {
    TagsMenuView(issue: Issue.example)
        //预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
