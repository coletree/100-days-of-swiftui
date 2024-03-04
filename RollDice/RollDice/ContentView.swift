//
//  ContentView.swift
//  RollDice
//
//  Created by coletree on 2024/3/1.
//

import SwiftUI

struct ContentView: View {
    
    
    //MARK: - 属性
    
    @State var myDice: Dice
    
    @State var thisTimeResult : Int = 1
    
    //设置骰子
    let diceType = [2,4,6,8,10,12,100]
    @State var currentIndex = 0
    
    //计时器
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var counter = 0
    
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack(alignment: .center, spacing: 40) {
            
            Text("\(thisTimeResult)")
                .font(.system(size: 100, weight: .heavy, design: .rounded))
                .onReceive(timer) {
                    time in
                    if counter == 15 {
                        timer.upstream.connect().cancel()
                        thisTimeResult = myDice.rollDice()
                        counter = 0
                    } else {
                        thisTimeResult = myDice.rollDice()
                        counter += 1
                    }
                }
            
            Button {
                //掷骰子的逻辑
                self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            } label: {
                Text("🎲 掷骰子")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .sensoryFeedback(.increase, trigger: thisTimeResult)
            
            
            //设置骰子
            Picker(selection: $currentIndex, label: Text("选择骰子")) {
                ForEach(diceType.indices) {
                    index in
                    Text("\(diceType[index])").tag(index)
                }
            }
            
            
        }
        .padding()
    }
    
    
    
    //MARK: - 方法

    
    
}





//MARK: - 预览
#Preview {
    ContentView(myDice: Dice(sided: 12))
}
