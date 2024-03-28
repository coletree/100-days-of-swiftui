//
//  ProgrammaticView.swift
//  HabitTracking
//
//  Created by coletree on 2024/3/25.
//

import SwiftUI



struct ProgrammaticView: View {

    //1. 创建一个 @State 属性来存储【整数数组】
    @State private var path = [Int]()
    
    var body: some View {
        
        //2. 将该属性绑定到 NavigationStack 的 path
        //这意味着【更改数组】将自动导航到数组中的任何内容，而且当用户按 Back 时也会更改数组导航栏
        NavigationStack(path: $path) {
            VStack {
                //第1个按钮，设置整个数组仅包含数字 32（如果数组发生其他变化使得 32 被删除，则意味着 NavigationStack 将返回到其原始状态）
                Button("Show 32") { path = [32] }
                //第2个按钮，给数组附加值 64，这意味着它将添加到我们导航到的任何内容中。（如果数组已经包含 32，那么现在在堆栈中将拥有3个视图：原始视图（称为“根”视图），然后是显示数字 32 的视图，最后是显示数字 64 的视图）。
                Button("Show 64") { path.append(64) }
                
                //第3个按钮，可以同时推送多个值。这将显示32的视图，然后显示64的视图，因此用户要点击“返回”两次才能返回根视图。
                Button("Show 32 then 64") {
                    path = [32, 64]
                }
            }
            .navigationDestination(for: Int.self) {
                selection in
                Text("You selected \(selection)")
            }
        }
    }
}


#Preview {
    ProgrammaticView()
}
