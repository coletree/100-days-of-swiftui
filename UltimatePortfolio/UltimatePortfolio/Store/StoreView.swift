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

    /// 状态属性：可以在应用程序中购买的全部产品，它由 StoreKit 作为数组返回
    @State private var products = [Product]()




    // MARK: - 视图
    var body: some View {

        NavigationStack {
            if let product = products.first {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(.title)
                    Text(product.description)

                    Button("Buy Now") {
                        /// 调用购买方法
                        purchase(product)
                    }
                }
            }
        }
        /// 监视 Premium Locked 是否解锁
        .onChange(of: dataController.fullVersionUnlocked, checkForPurchase)
        /// 在显示后 StoreView 立即调用
        .task {
            await load()
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
        Task { @MainActor in
            try await dataController.purchase(product)
        }
    }

    /// 方法：加载所有可购买商品
    func load() async {
        do {
            products = try await Product.products(for: [DataController.unlockPremiumProductID])
        } catch {
            print("Error loading products: \(error.localizedDescription)")
        }
    }

}




// MARK: - 预览
#Preview {
    StoreView()
}
