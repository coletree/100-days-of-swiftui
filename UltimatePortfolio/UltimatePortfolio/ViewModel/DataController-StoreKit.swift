//
//  DataController-StoreKit.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/23.
//

import Foundation
import StoreKit




/// DataController 的扩展：专门处理 IAP 的部分
extension DataController {


    // MARK: - 属性

    /// 常量：可购买商品 Premium unlock 的商品 ID
    static let unlockPremiumProductID = "com.coletree.UltimatePortfolio.premiumUnlock"

    /// 计算属性：判断 Premium unlock 是否被购买，以及当 Premium unlock 被购买后，设置该属性
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }




    // MARK: - 方法

    // 方法：对交易进行确认然后解锁，最后通知评估 finish
    @MainActor
    func finalize(_ transaction: Transaction) async {
        if transaction.productID == Self.unlockPremiumProductID {
            objectWillChange.send()
            fullVersionUnlocked = transaction.revocationDate == nil
            await transaction.finish()
        }
    }

    // 方法：加载可购买商品
    @MainActor
    func loadProducts() async throws {
        // 确保数据为空再进行加载
        guard products.isEmpty else { return }
        try await Task.sleep(for: .seconds(3))
        products = try await Product.products(for: [Self.unlockPremiumProductID])
    }

    // 方法：检查商品当前是否授权 和 监视未来的交易更新
    func monitorTransactions() async {
        // 检查之前的购买
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement {
                await finalize(transaction)
            }
        }
        // 监视未来可能传入的交易
        for await update in Transaction.updates {
            if let transaction = try? update.payloadValue {
                await finalize(transaction)
            }
        }
    }

    // 方法：负责触发整个购买流程。触发完交给 finalize 解锁权益
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        if case let .success(validation) = result {
            try await finalize(validation.payloadValue)
        }
    }




}
