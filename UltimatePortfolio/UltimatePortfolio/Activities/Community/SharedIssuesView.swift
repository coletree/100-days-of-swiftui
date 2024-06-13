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

    // 状态属性：跟踪 issue 的加载状态
    @State private var itemsLoadState = LoadState.inactive

    // UserDefault 数据
    @AppStorage("username") var username: String?

    // 状态属性：加载所有消息，包括我们编写的任何消息
    @State private var messages = [ChatMessage]()

    // 状态属性：跟踪消息的加载状态
    @State private var messagesLoadState = LoadState.inactive

    // 状态属性：是否显示登录视图
    @State private var showingSignIn = false

    // 状态属性：绑定用户当前输入的文本
    @State private var newChatText = ""

    // 使用 @ViewBuilder 将其设为计算属性。
    @ViewBuilder var messagesFooter: some View {
        if username == nil {
            Button("Sign in to comment", action: signIn)
                .frame(maxWidth: .infinity)
        } else {
            VStack {
                TextField("Enter your message", text: $newChatText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textCase(nil)
                Button(action: sendChatMessage) {
                    Text("Send")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .contentShape(Capsule())
                }
            }
        }
    }



    // MARK: - 视图
    var body: some View {
        List {

            // 问题列表
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

            // 评论区
            Section(
                header: Text("Chat about this Tag…"),
                footer: messagesFooter
            ) {
                if messagesLoadState == .success {
                    ForEach(messages) { message in
                        Text("\(Text(message.from).bold()): \(message.text)")
                            .multilineTextAlignment(.leading)
                    }
                }
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(tag.name)
        // 视图出现时运行
        .onAppear(perform: {
            fetchSharedIssues()
            fetchChatMessages()
        })
        // 工作表在布尔值为 true 时显示 SignInView 视图
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }




    // MARK: - 方法

    // 方法：获取数据
    func fetchSharedIssues() {

            guard itemsLoadState == .inactive else { return }
            itemsLoadState = .loading

            // 1.接下来需要加载属于当前 project 的所有 items
            let recordID = CKRecord.ID(recordName: tag.id)
            let reference = CKRecord.Reference(recordID: recordID, action: .none)
            let pred = NSPredicate(format: "tag == %@", reference)
            let sort = NSSortDescriptor(key: "title", ascending: true)
            let query = CKQuery(recordType: "Issue", predicate: pred)
            query.sortDescriptors = [sort]

            // 2.将新查询包装在 CKQueryOperation 中，主要请求数组中的三个键：
            let operation = CKQueryOperation(query: query)
            operation.desiredKeys = ["title", "content", "status"]
            operation.resultsLimit = 20

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
            operation.queryCompletionBlock = { _, error in
                if let error = error {
                    print("查询出错: \(error.localizedDescription)")
                    return
                }
                if issues.isEmpty {
                    itemsLoadState = .noResults
                }
            }

            // 5.最后将该查询发送到 CloudKit：
            CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio").publicCloudDatabase.add(operation)
            // CKContainer.default().publicCloudDatabase.add(operation)

            print("请求下载完成")

    }

    // 方法：登录
    func signIn() {
        showingSignIn = true
    }

    // 方法：发布评论
    func sendChatMessage() {

        // 首先，确保有消息文本和用户名，否则拒绝发送
        let text = newChatText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 2 else { return }
        guard let username = username else { return }

        // 接下来，使用该用户名和文本创建一条“消息”记录，并添加对我们要发布到的项目的引用：
        let message = CKRecord(recordType: "Message")
        message["from"] = username
        message["text"] = text
        let tagID = CKRecord.ID(recordName: tag.id)
        message["tag"] = CKRecord.Reference(recordID: tagID, action: .deleteSelf)

        // 重要的部分：获取 newChatText 的副本，然后清除它。这将导致 UI 立即更新
        // 因此用户不会尝试在其中添加更多文本，但也意味着如果 CloudKit 工作失败，我们可以恢复到原始消息：
        let backupChatText = newChatText
        newChatText = ""

        // 将 CKRecord 发送到 iCloud 上进行保存
        // 由于只有一条记录，因此可以在公共数据库上调用 save() 方法，而不是创建 CKModifyRecordsOperation
        // 这将在操作完成时，发送回已保存的记录或错误
        // 因此可以在失败时，使用它来恢复 newChatText ；或者在成功时，将用户的新消息附加到 messages 数组
        let container = CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio")
        container.publicCloudDatabase.save(message) { record, error in
            if let error = error {
                print(error.localizedDescription)
                newChatText = backupChatText
            } else if let record = record {
                let message = ChatMessage(from: record)
                messages.append(message)
            }
        }

    }

    // 方法：获取评论
    func fetchChatMessages() {
        guard messagesLoadState == .inactive else { return }
        messagesLoadState = .loading

        let recordID = CKRecord.ID(recordName: tag.id)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        let pred = NSPredicate(format: "tag == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "Message", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["from", "text"]

        operation.recordFetchedBlock = { record in
            let message = ChatMessage(from: record)
            messages.append(message)
            messagesLoadState = .success
        }

        operation.queryCompletionBlock = { _, _ in
            if messages.isEmpty {
                messagesLoadState = .noResults
            }
        }

        let container = CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio")
        container.publicCloudDatabase.add(operation)
    }

}




// MARK: - 预览
#Preview {
    SharedIssuesView(tag: SharedTag.example)
}
