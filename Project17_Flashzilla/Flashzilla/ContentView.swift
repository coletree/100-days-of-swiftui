//
//  ContentView.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/26.
//

import SwiftUI


struct ContentView: View {

    //状态属性：记录圆圈被拖动了多远
    @State private var offset = CGSize.zero

    //状态属性：记录圆圈是否正处于拖动的过程中
    @State private var isDragging = false
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    

    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
                
        //创建一个手势序列，强制必须先长按，才可以进行拖拽
        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
        
        
        Text("Hello, World!")
            .onReceive(timer) {
                        time in
                print("The time is now \(time)")
            }
        
    }
}





#Preview {
    ContentView()
}
