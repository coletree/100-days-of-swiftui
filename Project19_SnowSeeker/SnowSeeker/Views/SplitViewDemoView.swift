//
//  SplitViewDemoView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/4/12.
//

import SwiftUI

struct SplitViewDemoView: View {
    var body: some View {
        
        //例如希望在空间受限时，也保留主工具栏视图
        NavigationSplitView(preferredCompactColumn: .constant(.sidebar)) {
            NavigationLink("Primary View") {
                Text("New view")
            }
        } detail: {
            Text("Content View")
                .navigationTitle("Content View")
        }
        .navigationSplitViewStyle(.balanced)
        //这要求主副视图以 balance 策略显示，结果是纵向模式下的 iPad 现在也将显示主工具视图
        
    }
}

#Preview {
    SplitViewDemoView()
}
