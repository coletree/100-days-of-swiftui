//
//  StoreView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/24.
//

import StoreKit
import SwiftUI




struct StoreView: View {


    // MARK: - 属性

    /// 环境属性：读取数据控制器
    @EnvironmentObject var dataController: DataController

    /// 环境属性：用于解除视图
    @Environment(\.dismiss) var dismiss

    // 状态属性：可购买的全部产品，它通过向 StoreKit 请求返回。为了使用缓存，这部分代码已移到视图模型中
    // @State private var products = [Product]()

    /// 状态属性：可购买产品的加载状态，从枚举中读取
    @State private var loadState = LoadState.loading

    /// 枚举：商品读取状态（读取中，已读取，出错）
    enum LoadState { case loading, loaded, error }

    /// 状态属性：用户无购买权限的弹窗
    @State private var showingPurchaseError = false




    // MARK: - 视图
    var body: some View {

        /// 根据枚举 LoadState 的不同状态展示几种可能视图
        NavigationStack {
            VStack(spacing: 0) {
                // HEADED
                VStack {
                    Image(decorative: "unlock")
                        .resizable()
                        .scaledToFit()

                    Text("Upgrade Today!")
                        .font(.title.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)

                    Text("Get the most out of the app")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.blue.gradient)

                // BODY
                ScrollView {
                    VStack {
                        switch loadState {
                        case .loading:
                            Text("Fetching offers…")
                                .font(.title2.bold())
                                .padding(.top, 50)
                            ProgressView()
                                .controlSize(.large)

                        case .loaded:
                            // 加载商品代码
                            ForEach(dataController.products) { product in
                                Button {
                                    purchase(product)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(product.displayName)
                                                .font(.title2.bold())
                                            Text(product.description)
                                        }
                                        Spacer()
                                        Text(product.displayPrice)
                                            .font(.title)
                                            .fontDesign(.rounded)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.1), in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                }
                                .buttonStyle(.plain)
                            }

                        case .error:
                            Text("Sorry, there was an error loading our store.")
                            .padding(.top, 50)
                            // 出错后重试
                            Button("Try Again") {
                                Task {
                                    await load()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(20)
                }

                // FOOTER
                Button("Restore Purchases", action: restore)
                Button("Cancel") {
                    dismiss()
                }
                .padding(.top, 20)
            }

        }
        /// 监视 Premium Locked 是否解锁
        .onChange(of: dataController.fullVersionUnlocked, checkForPurchase)
        /// 在显示后 StoreView 立即调用
        .task {
            await load()
        }
        .alert("In-app purchases are disabled", isPresented: $showingPurchaseError) {
        } message: {
            Text("""
            You can't purchase the premium unlock because in-app purchases are disabled on this device.
            Please ask whomever manages your device for assistance.
            """)
        }

    }




    // MARK: - 方法

    /// 方法：解除视图
    func checkForPurchase() {
        if dataController.fullVersionUnlocked {
            dismiss()
        }
    }

    /// 方法：触发购买流程
    func purchase(_ product: Product) {
        // 确保用户有权购买再往下执行
        guard AppStore.canMakePayments else {
            showingPurchaseError.toggle()
            return
        }
        // 调用视图模型中的购买方法
        Task { @MainActor in
            try await dataController.purchase(product)
        }
    }

    /// 方法：加载所有可购买商品
    func load() async {
        // 开始加载时，将状态改为 loading
        loadState = .loading
        do {
            // 然后开始使用视图模型那边的加载方法
            try await dataController.loadProducts()
            if dataController.products.isEmpty {
                loadState = .error
            } else {
                loadState = .loaded
            }
        } catch {
            loadState = .error
        }
    }

    /// 方法：恢复购买
    func restore() {
        Task {
            try await AppStore.sync()
        }
    }

}




// MARK: - 预览
#Preview {
    StoreView()
}
