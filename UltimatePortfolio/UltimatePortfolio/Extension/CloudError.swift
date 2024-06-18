//
//  CloudError.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/14.
//


import CloudKit
import Foundation
import SwiftUI


// ExpressibleByStringInterpolation 协议允许直接从字符串创建 CloudError 实例，所需的只是单个 init(stringLiteral:) 初始值设定项
struct CloudError: Identifiable, ExpressibleByStringInterpolation {

    // ID 通过计算属性计算出来
    var id: String { message }

    // message属性
    var message: String

    // 本地化文案
    var localizedMessage: LocalizedStringKey {
        LocalizedStringKey(message)
    }

    // 自定义初始化方法
    init(stringLiteral value: String) {
        self.message = value
    }

    init(_ error: Error) {
        guard let error = error as? CKError else {
            self.message = "An unknown error occurred: \(error.localizedDescription)"
            return
        }
        switch error.code {
        // 处理逻辑错误
        case .badContainer, .badDatabase, .invalidArguments:
            self.message =  "A fatal error occurred: \(error.localizedDescription)"
        // 处理网络错误
        case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
            self.message =  "There was a problem communicating with iCloud; please check your network connection and try again."
        // 处理未授权错误
        case .notAuthenticated:
            self.message =  "There was a problem with your iCloud account; please check that you're logged in to iCloud."
        // 处理 CAS 错误
        case .requestRateLimited:
            self.message =  "You've hit iCloud's rate limit; please wait a moment then try again."
        // 处理超出配额错误
        case .quotaExceeded:
            self.message =  "You've exceeded your iCloud quota; please clear up some space then try again."
        // 默认其他情况
        default:
            self.message =  "An unknown error occurred: \(error.localizedDescription)"
        }
    }

}
