//
//  Error-CloudKitMessages.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/14.
//

import CloudKit
import Foundation



// Error 的扩展
//extension Error {
//
//    func getCloudKitError() -> CloudError {
//        guard let error = self as? CKError else {
//            return "An unknown error occurred: \(self.localizedDescription)"
//        }
//        switch error.code {
//        // 处理逻辑错误
//        case .badContainer, .badDatabase, .invalidArguments:
//            return "A fatal error occurred: \(error.localizedDescription)"
//        // 处理网络错误
//        case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
//            return "There was a problem communicating with iCloud; please check your network connection and try again."
//        // 处理未授权错误
//        case .notAuthenticated:
//            return "There was a problem with your iCloud account; please check that you're logged in to iCloud."
//        // 处理 CAS 错误
//        case .requestRateLimited:
//            return "You've hit iCloud's rate limit; please wait a moment then try again."
//        // 处理超出配额错误
//        case .quotaExceeded:
//            return "You've exceeded your iCloud quota; please clear up some space then try again."
//        // 默认其他情况
//        default:
//            return "An unknown error occurred: \(error.localizedDescription)"
//        }
//    }
//
//}
