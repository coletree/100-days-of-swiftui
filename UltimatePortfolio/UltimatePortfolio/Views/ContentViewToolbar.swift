//
//  ContentViewToolbar.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/10.
//

import SwiftUI


struct ContentViewToolbar: View {


    // MARK: - 属性

    // 抽出视图后会收到错误，因为代码引用了 dataController 和 showingAwards ，所以添加以下两个新属性

    // 环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController




    // MARK: - 视图
    var body: some View {

        // 菜单: 用于过滤数据
        Menu {

            // 按钮：切换控制过滤器是否开启
            Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                dataController.filterEnabled.toggle()
            }

            // 分隔符
            Divider()

            // 菜单：排序方式选项。影响数据模型的 SortType 和 sortNewestFirst
            Menu("Sort By") {

                // 选择器：绑定排序方式 SortType 的实例
                Picker("Sort By", selection: $dataController.sortType) {
                    Text("Date Created").tag(SortType.dateCreated)
                    Text("Date Modified").tag(SortType.dateModified)
                }

                // 分隔符
                Divider()

                // 选择器：绑定布尔值 sortNewestFirst
                Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                    Text("Newest to Oldest").tag(true)
                    Text("Oldest to Newest").tag(false)
                }

            }

            // 选择器：状态选项。如果过滤器关闭，则禁用
            Picker("Status", selection: $dataController.filterStatus) {
                Text("All").tag(Status.all)
                Text("Open").tag(Status.open)
                Text("Closed").tag(Status.closed)
            }
            .disabled(dataController.filterEnabled == false)

            // 选择器：优先级选项。如果过滤器关闭，则禁用
            Picker("Priority", selection: $dataController.filterPriority) {
                Text("All").tag(-1)
                Text("Low").tag(0)
                Text("Medium").tag(1)
                Text("High").tag(2)
            }
            .disabled(dataController.filterEnabled == false)

        }
        label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(dataController.filterEnabled ? .fill : .none)
        }

        // 按钮：创建新 issue
        Button(action: dataController.newIssue) {
            Label("New Issue2", systemImage: "square.and.pencil")
        }

    }




    // MARK: - 方法




}




// MARK: - 预览
#Preview {
    ContentViewToolbar()
        // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
        .environmentObject(DataController.preview)
}
