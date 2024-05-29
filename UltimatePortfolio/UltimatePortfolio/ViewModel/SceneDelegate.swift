//
//  SceneDelegate.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/27.
//

import Foundation
import SwiftUI




class SceneDelegate: NSObject, UIWindowSceneDelegate {

    // 方法：尝试将 shortcutItem.type 转换为 URL 实例，然后打开 URL
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: shortcutItem.type) else {
            completionHandler(false)
            return
        }
        windowScene.open(url, options: nil, completionHandler: completionHandler)
    }

    // 方法：解决冷启动问题
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let shortcutItem = connectionOptions.shortcutItem {
            if let url = URL(string: shortcutItem.type) {
                scene.open(url, options: nil)
            }
        }
    }

}
