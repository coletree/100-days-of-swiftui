//
//  SwiftUIView.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/27.
//

import SwiftUI

struct SwiftUIView: View {
    
    
    // GestureState 属性代表一个手势事件在整个期間是否被偵測到。
    @GestureState private var isDetectingLongPress = false

    // 这里另外用了一个状态参数
    @State private var completedLongPress = false

    var longPress: some Gesture {
        //设置最短持续时间3秒
        LongPressGesture(minimumDuration: 3)
        //使用 Updating 方法：在长按手势执行期间这个方法都会被调用，当手势值发生变化时，SwiftUI调用的回调包括以下3个参数：
        //value（currentState） 参数代表手势目前更新状态
        //state（gestureState） 参数是之前 isDetectingLongPress 属性的值
        //设定 “gestureState = currentState”，代表 isDetectingLongPress 属性会持续更新为长按手势的最新状态
        //transaction 参数是手势上下文，储存了目前状态处理更新的內容，例如动画
            .updating($isDetectingLongPress) {
                currentState, gestureState, transaction in
                gestureState = currentState
                //设置transaction的动画内容
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
        //设置长按手势识别结束时，更新状态参数。（finished 是 onEnded的参数，表示手势识别的最后状态值）
            .onEnded {
                finished in
                self.completedLongPress = finished
            }
    }

    //给相应的视图加上手势识别：
    var body: some View {
        Circle()
        //如果isDetectingLongPress=true，则显示红色，否则再判断 completedLongPress是否为真，如果为真显示绿色，否则显示蓝色
            .fill(self.isDetectingLongPress ? Color.red : (self.completedLongPress ? Color.green : Color.blue))
            .frame(width: 100, height: 100, alignment: .center)
            .gesture(longPress)
    }
    
    
    
}




#Preview {
    SwiftUIView()
}
