//
//  AppDelegate.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/27.
//

import Foundation
import SwiftUI




// 应用委托类：AppDelegate，用于“编写 SwiftUI 不具备的 UIKit 的功能”
class AppDelegate: NSObject, UIApplicationDelegate {

    // 方法：让应用程序知道，当需要创建新场景时，可以通过创建 SceneDelegate 实例来实现
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        // 告诉 iOS 使用之前创建的 SceneDelegate 类
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }

}
