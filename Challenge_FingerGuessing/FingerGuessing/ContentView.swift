//
//  ContentView.swift
//  FingerGuessing
//
//  Created by coletree on 2023/11/23.
//

import SwiftUI




struct ContentView: View {
    
    
    //MARK: - 属性
    
    //常量：定义三种属性
    let fingerGes: [String] = ["✊🏻", "✌🏻", "🤚🏻"]
    
    //枚举：定义整数型枚举 Result，每个值实例代表一种结果
    enum Result: Int, CaseIterable {
        case win = 0
        case lose = 1
        case draw = 2
        
        var text: String {
            switch self {
            case .win: return "Win"
            case .lose: return "Lose"
            case .draw: return "Draw"
            }
        }
    }
    
    //状态属性：每轮随机生成谜面
    @State private var aiChoose = Int.random(in: 0...2)
    @State private var aiCondition = Int.random(in: 0...2)
    
    //状态属性：记录当前局数，和总得分
    @State private var score = 0
    @State private var current = 0
    
    //状态属性：贴身弹窗的内容
    @State private var showsAlert = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var buttonText = "继续"
    

    
    
    //MARK: - 视图
    var body: some View {
        
        let conditionWord = Result(rawValue: aiCondition)?.text ?? "Win"
        
        VStack(spacing:40) {
            Text(fingerGes[aiChoose])
                .font(.system(size: 128))
            HStack(spacing: 2) {
                Text("Choose you gesture to ")
                Text("\(conditionWord)")
                    .fontWeight(.heavy)
                    .foregroundStyle(.red)
            }
            .font(.title2)
            
            HStack {
                ForEach(0..<fingerGes.count, id: \.self) {
                    number in
                    Button(fingerGes[number]) {
                        let tempResult = checkResult(num: number)
                        showResultAlert(type: tempResult)
                    }
                }
                .font(.system(size: 64))
                .padding()
            }
            
        }
        //结果弹窗
        .alert(alertTitle, isPresented: $showsAlert) {
            Button(buttonText) {
                if current < 5{
                    askQuestion()
                }else{
                    resetGame()
                }
            }
        } message: {
            Text(alertMsg)
        }
        
    }
    
    
    
    
    //MARK: - 方法
    
    // 检查游戏结果
    func checkResult(num playerChoose: Int) -> Bool {
        
        current += 1
        
        var actualResult:Result
        
        //通过 switch 判断各种胜负关系
        switch aiChoose {
        case 0:
            if playerChoose == 0{
                actualResult = .draw
            }else if playerChoose == 1{
                actualResult = .lose
            }else{
                actualResult = .win
            }
        case 1:
            if playerChoose == 0{
                actualResult = .win
            }else if playerChoose == 1{
                actualResult = .draw
            }else{
                actualResult = .lose
            }
        case 2:
            if playerChoose == 0{
                actualResult = .lose
            }else if playerChoose == 1{
                actualResult = .win
            }else{
                actualResult = .draw
            }
        default:
            actualResult = .draw
        }
        
        //判断实际结果 和 游戏开始设定的目标 是否一致，一致就得分，否则不得分。并且返回布尔值
        if actualResult == Result(rawValue: aiCondition){
            score += 1
            return true
        }else{
            return false
        }
        
        
    }
    
    // 展示结果
    func showResultAlert(type:Bool){
        if current < 5{
            if type {
                alertTitle = "你答对了。(\(current)/5)"
                alertMsg = "真聪明"
            }else{
                alertTitle = "你答错了!(\(current)/5)"
                alertMsg = "请审题、请审题、请审题"
            }
        }else{
            alertTitle = "全部玩完了"
            alertMsg = "5次里面你答对了\(score)次"
            buttonText = "重新来一局"
        }

        showsAlert = true
    }
    
    // 重新出题
    func askQuestion() {
        aiChoose = Int.random(in: 0...2)
        aiCondition = Int.random(in: 0...2)
    }
    
    // 重置游戏分数
    func resetGame(){
        current = 0
        score = 0
        askQuestion()
    }
    
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
