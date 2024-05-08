//
//  Extension-View.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/8.
//

import Foundation
import SwiftUI




//MARK: 避免 macOS 不支持 navigationBarTitleDisplayMode 的 bug
extension View {
    func inlineNavigationBar() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
