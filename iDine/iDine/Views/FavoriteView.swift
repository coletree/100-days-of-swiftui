//
//  FavoriteView.swift
//  iDine
//
//  Created by coletree on 2024/4/22.
//

import SwiftUI

struct FavoriteView: View {
    
    
    //MARK: - 属性
    
    //环境属性：读取在 App.swift 文件中定义的 order 属性
    @Environment(Favor.self) var favor
        
    let bio = "The rain in Spain falls mainly on the Spaniards fdsa fds a"
    
    @Environment(\.redactionReasons) var redactionReasons
    
    @State private var animationsRunning = false
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack{
            List{
                
                VStack {
                    Link("Visit Apple", destination: URL(string: "https://apple.com")!)
                    Text("[Visit Apple](https://apple.com)")
                    Button("Start Animations") {
                                withAnimation {
                                    animationsRunning.toggle()
                                }
                            }

                            VStack {
                                HStack {
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.iterative, value: animationsRunning)
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.cumulative, value: animationsRunning)
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.reversing.iterative, value: animationsRunning)
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing, value: animationsRunning)
                                }

                                HStack {
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.iterative, options: .repeating, value: animationsRunning)
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.cumulative, options: .repeat(3), value: animationsRunning)
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.reversing.iterative, options: .speed(3), value: animationsRunning)
                                    Image(systemName: "square.stack.3d.up")
                                        .symbolEffect(.variableColor.reversing.cumulative, options: .repeat(3).speed(3), value: animationsRunning)
                                }
                            }
                            .font(.largeTitle)


                }
                
                
                VStack {
                    Text("Card number")
                        .font(.headline)
                    
                    Text("1234 5678 9012 3456")
                        .textSelection(.enabled)
                        .privacySensitive()
                }
                
                VStack {
                    Text("Card number")
                        .font(.headline)
                    
                    if redactionReasons.contains(.privacy) {
                        Text("[HIDDEN]").privacySensitive()
                    } else {
                        Text("1234 5678 9012 3456").privacySensitive()
                    }
                }
                .redacted(reason: .privacy)
                .textSelection(.enabled)
                
                
                VStack {
                    // show just the date
                    Text(Date.now.addingTimeInterval(600), style: .date)

                    // show just the time
                    Text(Date.now.addingTimeInterval(600), style: .time)

                    // show the relative distance from now, automatically updating
                    Text(Date.now.addingTimeInterval(600), style: .relative)

                    // make a timer style, automatically updating
                    Text(Date.now.addingTimeInterval(600), style: .timer)
                }
                    
                
                
                ForEach(favor.favorItems) {
                    item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price)")
                    }
                }
                .onDelete(perform: deleteFavorItems)
            }
            .navigationTitle("Favor")
            //支持批量编辑
            .toolbar {
                EditButton()
            }
        }
        
    }
    
    
    //MARK: - 方法
    
    //方法：删除收藏
    func deleteFavorItems(at offsets: IndexSet) {
        favor.favorItems.remove(atOffsets: offsets)
    }
    
    
    
}




//MARK: - 预览
#Preview {
    FavoriteView()
        .environment(Favor())
}
