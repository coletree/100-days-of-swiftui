//
//  ContentView.swift
//  multiplicationTables
//
//  Created by coletree on 2023/12/6.
//

import SwiftUI

struct ContentView: View {
    
    
    //MARK: - 属性
    
    //状态属性：与用户交互绑定
    var testAmountList = [5, 10, 20]
    @State private var rootNumber: Int = 6
    @State private var testAmount: Int = 5
    @State var answerFieldData = ""

    //状态属性：每局游戏设置，包括题目数组，当前局数，总得分
    @State private var questionList = [question]()
    @State private var current = 0
    @State private var score = 0
    
    //状态属性：表示游戏是否已开始
    @State private var gameBegin = false

    //状态属性：用于每个题目计算
    @State private var firstNum = 0
    @State private var secondNum = 0
    @State private var trueAnswer = 0

    //状态属性：答完题的提示参数
    @State var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var buttonText = "下一题"

    @State private var prompText = "点击上方按钮开始游戏"
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        List {
            
            //视图：设置题目区
            Section{
                Stepper(value: $rootNumber, in: 3...12) {
                    Text("要练习的乘法数字是: \(rootNumber)")
                }
                Picker(selection: $testAmount, label: Text("你想要测试多少题")) {
                    ForEach(testAmountList, id: \.self) {
                        Text("\($0)")
                    }
                }
                HStack {
                    Spacer()
                    //按钮：游戏开始前的
                    if !gameBegin{
                        Button(action: {
                            //游戏开始的函数
                            gameBegin.toggle()
                            setGame(questionRoot: rootNumber)
                            askQuestion()
                            
                        }, label: {
                            Text("练习开始")
                                .foregroundStyle(.white)
                        })
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background(.blue)
                        .clipShape(.capsule)
                    }
                    //按钮：游戏开始后
                    else{
                        Button(action: {
                            //游戏结束的函数：
                            gameBegin.toggle()
                            
                            
                        }, label: {
                            Text("结束游戏")
                                .foregroundStyle(.white)
                        })
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background(.gray)
                        .clipShape(.capsule)
                    }
                    
                }
            }
            header: {
                Text("设置你要练习的内容: ")
            }
            
            
            //视图：游戏区
            VStack(spacing: 20){
                //游戏开始前
                if !gameBegin{
                    VStack() {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(prompText).foregroundStyle(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                }
                //游戏开始后
                else{
                    Text("请答题(\(current)/\(testAmount))")
                    
                    Text("\(firstNum) x \(secondNum) = ?")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    
                    TextField("输入答案", text: $answerFieldData)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        //点击按钮确认答案
                        checkAnswer()
                    }, label: {
                        Text("提交答案")
                            .foregroundStyle(.white)
                    })
                    .padding(.vertical,10)
                    .padding(.horizontal,40)
                    .background(.blue)
                    .clipShape(.capsule)
                    .alert(alertTitle, isPresented: $showAlert)
                        {
                            Button(buttonText) {
                                if current < testAmount{
                                    askQuestion()
                                }else{
                                    endGame()
                                }
                          }
                      } message: {
                                Text(alertMsg)
                      }
                }

                
                
            }
            .padding()
            
            
            
        }
        .padding(.top, 80)
        .ignoresSafeArea(.all)
        
    }
    
    
    //MARK: - 方法
    
    
    //方法：设置游戏题目，根据输入的根数字，依次生成题目数组
    func setGame( questionRoot number : Int ){
        for secondNum in 1 ... 12 {
            //这里是将 question 对象一个个填入数组，这个对象里包括第一个、第二个字母、也包括答案、
            questionList.append(question(first: number, second: secondNum))
        }
    }
    
    //方法：结束游戏。清空题目数组，数据恢复为原始状态。
    func endGame(){
        questionList = [question]()
        gameBegin = false
        current = 0
        score = 0
    }

    
    //开始出题
    func askQuestion(){
        
        let lowerBound = 0
        let upperBound = questionList.count - 1
        let randomInt = Int.random(in: lowerBound...upperBound)
        let question = questionList[randomInt]
        
        firstNum = question.first
        secondNum = question.second
        trueAnswer = question.multiple
        answerFieldData = ""
        current += 1
        
        questionList.remove(at: randomInt)
        print(questionList.count)
    }
    
    //检查答案
    func checkAnswer(){
        
        guard Int(answerFieldData) != nil else {
            answerFieldData = ""
            return
        }
        
        let userAnswer = Int(answerFieldData)
        
        if current < testAmount{
            if userAnswer == trueAnswer{
                score += 1
                alertTitle = "答对了"
                alertMsg = "继续努力"
            }else{
                alertTitle = "答错了"
                alertMsg = "请好好想想"
            }
        }else{
            if userAnswer == trueAnswer{
                score += 1
                let finalScore = Int(Double(score) / Double(testAmount) * 100)
                alertTitle = "答对了"
                alertMsg = "本轮游戏你已经全部回答完毕，得分为\(finalScore)"
                buttonText = "OK"
            }else{
                let finalScore = Int(Double(score) / Double(testAmount) * 100)
                alertTitle = "答错了"
                alertMsg = "本轮游戏你已经全部回答完毕，得分为\(finalScore)"
                buttonText = "OK"
            }
        }
        showAlert = true
    }
    

}



//MARK: - 其他


//建立了每一条题目的模型
struct question{
    var first : Int
    var second : Int
    var multiple : Int {
        first * second
    }
}




//MARK: - 预览
#Preview {
    ContentView()
}
