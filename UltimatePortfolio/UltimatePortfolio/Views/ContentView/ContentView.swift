//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/23.
//

import CloudKit
import SwiftUI


// MARK: - 中间列表视图
struct ContentView: View {


    // MARK: - 属性

    // 环境属性：从环境中读取 dataController 实例
    // @EnvironmentObject var dataController: DataController

    // 视图模型：引入该视图的视图模型
    @StateObject private var viewModel: ViewModel

    // 环境属性：从环境中读取 requestReview 操作
    @Environment(\.requestReview) var requestReview

    private let newIssueActivity = "com.coletree.ultimateportfolio.newIssue"

    // @AppStorage 属性：包装器检查有效的用户名
    @AppStorage("username") var username: String?

    // 状态属性：存储当前是否显示登录视图
    @State private var showingSignIn = false

    // 枚举：Tag 的几种可能状态
    enum CloudStatus {
        case checking, exists, absent
    }

    // 状态属性：跟踪该 Tag 在云端的状态
    @State private var cloudStatus = CloudStatus.checking

    // 状态属性：CloudKit 错误提示文案
    @State private var cloudError: CloudError?




    // MARK: - 视图
    var body: some View {

        // MARK: 列表
        // dataController 里储存了用户选择的 Issue，要和 List 的 selection 进行绑定
        List(selection: $viewModel.dataController.selectedIssue) {

            // MARK: 通过函数返回 issue 列表
            // 之前的计算属性 [issues] 被移到视图模型中了，并改成了方法
            ForEach(viewModel.dataController.issuesForSelectedFilter(), id: \.issueID) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)

        }
        .navigationTitle("Issues")

        // FIXME: 搜索框(让列表支持搜索)
        .searchable(
            text: $viewModel.dataController.filterText,
            tokens: $viewModel.dataController.filterTokens,
            suggestedTokens: .constant(viewModel.dataController.suggestedFilterTokens),
            prompt: "Filter issues, or type # to add tags") { tag in
                Text(tag.tagName)
            }

        // MARK: 标题栏过滤器控件 (已移入子视图)
        .toolbar {
            ContentViewToolbar()
            // 按钮：上传iCloud
            switch cloudStatus {
            case .checking:
                ProgressView()
            case .exists:
                Button(action: removeFromCloud) {
                    Label("Remove from iCloud", systemImage: "icloud.slash")
                }
            case .absent:
                Button(action: uploadToCloud) {
                    Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                }
            }
        }

        // MARK: 用户评分弹窗
        .onAppear(perform: askForReview)
        // 响应主图标的快捷方式
        .onOpenURL(perform: openURL)
        // 处理快捷方式指令
        .userActivity(newIssueActivity) { activity in
            // isEligibleForPrediction 属性仅适用于 iOS 和 watchOS。因此要做平台判断
            #if os(iOS) || os(watchOS)
            activity.isEligibleForPrediction = true
            #endif
            activity.title = "New Issue"
        }
        // 响应快捷指令
        .onContinueUserActivity(newIssueActivity, perform: resumeActivity)
        // 登录弹窗
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
        // 每次显示视图时，就进行云端状态检查
        .onAppear(perform: updateCloudStatus)
        // CloudKit 错误弹窗
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error"),
                message: Text(error.localizedMessage)
            )
        }

    }




    // MARK: - 方法

    // 自定义初始化：视图模型需要能够访问实例 DataController ，但无法从环境中读取该实例
    // 因此添加此初始值设定项，以实例化和存储视图模型状态对象
    init(dataController: DataController) {
        // 利用传入的 DataController 来创建视图模型
        let viewModel = ViewModel(dataController: dataController)
        // StateObject 是一个属性包装器，用于管理视图模型的生命周期，并确保视图在视图模型的状态改变时自动更新
        // _viewModel 是 @StateObject 属性包装器的底层存储器，在初始化时需要通过 wrappedValue 参数设置它的初始值
        // StateObject 应该在视图的初始化时设置，并且只能在初始化方法中设置一次
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /// 方法：请求用户评分
    @MainActor
    func askForReview() {
        if viewModel.shouldRequestReview {
            requestReview()
        }
    }

    // 快捷方式：打开创建 issue 的页面
    func openURL(_ url: URL) {
        if url.absoluteString.contains("newIssue") {
            viewModel.dataController.newIssue()
        }
    }

    // 快捷指令：响应快捷指令的行为
    func resumeActivity(_ userActivity: NSUserActivity) {
        viewModel.dataController.newIssue()
    }


    // 方法：更新 tag 状态
    func updateCloudStatus() {
        if let tag = viewModel.dataController.selectedFilter?.tag{
            tag.checkCloudStatus { exists in
                if exists {
                    cloudStatus = .exists
                } else {
                    cloudStatus = .absent
                }
            }
        } else {
            cloudStatus = .absent
        }
    }

    // 方法：上传记录到云端
    func uploadToCloud() {
        if let username = username {
            if let records = viewModel.dataController.selectedFilter?.tag?.prepareCloudRecords(owner: username) {
                let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
                operation.savePolicy = .allKeys
                operation.modifyRecordsCompletionBlock = { _, _, error in
                    if let error = error {
                        // cloudError = error.getCloudKitError()
                        cloudError = CloudError(error)
                    }
                    updateCloudStatus()
                }
                cloudStatus = .checking
                let container = CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio")
                container.publicCloudDatabase.add(operation)
                // container.sharedCloudDatabase.add(operation)
                // container.privateCloudDatabase.add(operation)
                print("\(records.count) 条记录发送成功")
            } else {
                showingSignIn = true
            }
        } else {
            showingSignIn = true
        }
    }

    // 方法：从云端删除记录
    func removeFromCloud() {
        if let name = viewModel.dataController.selectedFilter?.tag?.objectID.uriRepresentation().absoluteString {
            let id = CKRecord.ID(recordName: name)
            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])
            // 第二次改变
            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    // cloudError = error.getCloudKitError()
                    cloudError = CloudError(error)
                }
                updateCloudStatus()
            }
            // 第一次改变
            cloudStatus = .checking
            CKContainer(identifier: "iCloud.com.coletree.ultimateportfolio").publicCloudDatabase.add(operation)
        } else {
            return
        }

    }


}




// MARK: - 预览
#Preview {
    ContentView(dataController: DataController.preview)
    // 预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
    .environmentObject(DataController.preview)
}
