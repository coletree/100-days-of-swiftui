//
//  BucketListApp.swift
//  BucketList
//
//  Created by coletree on 2024/1/15.
//

import SwiftUI

@main
struct BucketListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    print(URL.documentsDirectory)
                })
        }
    }
}
