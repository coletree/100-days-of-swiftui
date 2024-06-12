//
//  SharedTagsView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/12.
//


import CloudKit
import SwiftUI




struct SharedTagsView: View {


    // MARK: - 属性

    // 常量属性：
    static let tag: String? = "Community"

    // 状态属性：
    @State private var tags = [SharedTag]()

    // 状态属性：注意默认状态是 inactive ，稍后将使用它来确保我们的网络请求仅启动一次
    @State private var loadState = LoadState.inactive




    // MARK: - 视图
    var body: some View {
        NavigationStack {
            Group {
                switch loadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No results")
                case .success:
                    List(tags) { tag in
                        NavigationLink(destination: SharedIssuesView(tag: tag)) {
                            VStack(alignment: .leading) {
                                Text(tag.name).font(.headline)
                                Text(tag.owner)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Shared Projects")
        }
        .onAppear(perform: fetchSharedTags)
    }




    // MARK: - 方法


    // 方法：获取数据
    func fetchSharedTags() {

        print("请求下载开始...")

        // 1. 首先，确保该方法只能运行一次，要避免在应用中切换界面导致 CloudKit 的多次触发
        guard loadState == .inactive else { return }
        loadState = .loading

        // 2. 接下来需要告诉 CloudKit 正在查找什么数据。这与 Core Data 类似
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Tag", predicate: pred)
        query.sortDescriptors = [sort]
        
        // 3. 还需要创建一个 CKQueryOperation 来定义想要返回的内容，它让我们可以添加限制
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "owner"]
        operation.resultsLimit = 50
        // 提示：如果不设置 desiredKeys ，CloudKit 将自动返回所有键
        print(operation)

        // 4.第一个是 recordFetchedBlock ：CloudKit 每下载一条记录作为查询结果，该闭包就会被调用一次
        operation.recordFetchedBlock = { record in
            let id = record.recordID.recordName
            let name = record["name"] as? String ?? "No name"
            let owner = record["owner"] as? String ?? "No owner"
            let sharedTag = SharedTag(id: id, name: name, owner: owner)
            tags.append(sharedTag)
            loadState = .success
        }

        // 5.第二个闭包是 queryCompletionBlock ：它将在检索到所有记录后被调用
        operation.queryCompletionBlock = { _, _ in
            if tags.isEmpty {
                loadState = .noResults
            }
        }

        // 6. 剩下就是将该操作发送到 iCloud。有了这个方法，SharedTagsView 现在几乎可以正常工作了
        // CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio").publicCloudDatabase.add(operation)
        CKContainer.default().publicCloudDatabase.add(operation)

        print(tags.count)
        print("请求下载完成")
    }

}




// MARK: - 预览
#Preview {
    SharedTagsView()
}
