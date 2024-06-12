//
//  SharedIssuesView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/12.
//


import CloudKit
import SwiftUI




struct SharedIssuesView: View {


    // MARK: - 属性

    // 常量属性：
    let tag: SharedTag

    // 状态属性：
    @State private var issues = [SharedIssue]()

    // 状态属性：
    @State private var itemsLoadState = LoadState.inactive




    // MARK: - 视图
    var body: some View {
        List {
            Section {
                switch itemsLoadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No results")
                case .success:
                    ForEach(issues) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            // 检查 item.detail.isEmpty 是否为空，否则它将创建空的 Text 视图，会造成布局偏移
                            if item.content.isEmpty == false {
                                Text(item.content)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(tag.name)
        .onAppear(perform: fetchSharedIssues)
    }




    // MARK: - 方法


    // 方法：获取数据
    func fetchSharedIssues() {

            guard itemsLoadState == .inactive else { return }
            itemsLoadState = .loading

            // 1.接下来需要加载属于当前 project 的所有 items
            let recordID = CKRecord.ID(recordName: tag.id)
            let reference = CKRecord.Reference(recordID: recordID, action: .none)
            let pred = NSPredicate(format: "project == %@", reference)
            let sort = NSSortDescriptor(key: "title", ascending: true)
            let query = CKQuery(recordType: "Issue", predicate: pred)
            query.sortDescriptors = [sort]

            // 2.将新查询包装在 CKQueryOperation 中，这次请求“title”、“detail”和“completed”键：
            let operation = CKQueryOperation(query: query)
            operation.desiredKeys = ["title", "detail", "completed"]
            operation.resultsLimit = 50

            // 3. recordFetchedBlock 闭包用于获取单个记录时调用，收到记录后，我们从 CKRecord 中提取值或提供合理的默认值；
            operation.recordFetchedBlock = { record in
                let id = record.recordID.recordName
                let title = record["title"] as? String ?? "No title"
                let content = record["content"] as? String ?? ""
                let status = record["status"] as? Bool ?? false
                let sharedIssue = SharedIssue(id: id, title: title, content: content, status: status)
                issues.append(sharedIssue)
                itemsLoadState = .success
            }

            // 4. queryCompletionBlock 闭包用于查询完成时调用
            operation.queryCompletionBlock = { _, _ in
                if issues.isEmpty {
                    itemsLoadState = .noResults
                }
            }

            // 5.最后将该查询发送到 CloudKit：
            CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio").publicCloudDatabase.add(operation)

    }

}




// MARK: - 预览
#Preview {
    SharedIssuesView(tag: SharedTag.example)
}
