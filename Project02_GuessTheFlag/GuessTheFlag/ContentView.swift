//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by coletree on 2023/11/17.
//

import SwiftUI




struct ContentView: View {
    
    
    //MARK: - 属性
    
    //状态属性：所有国家的数组
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Spain",
        "UK",
        "Ukraine",
        "US"
    ]
    
    //属性：所有国家国旗的说明，这是一个字典数据
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    //属性：每局游戏的总回合数
    let roundNum = 8
    
    //状态属性：当前回合数
    @State private var current = 0
    
    //状态属性：每回合正确答案索引
    @State private var correctAnswer = Int.random(in: 0...2)
    
    //状态属性：每局的分数
    @State private var score = 0
    
    //状态属性：游戏分数展示相关
    @State private var showscore = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var buttonText = ""

    //状态属性：游戏动画相关
    @State private var rotationNum = 0.0
    @State private var opacityNum = 1.0
    @State private var scaleNum = 1.0
    
    //状态属性：用户选择的国旗
    @State private var chosenFlag: Int? = nil
    

    
    
    //MARK: - 视图
    var body: some View {
        
        ZStack {
            
            //视图：背景椭圆
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.4),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.9),
                ],
                center: .top,
                startRadius: 200,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            //视图：主体布局
            VStack {
                
                Spacer()
                Spacer()
                
                VStack{
                    Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                }
                
                VStack(spacing:20){
                    
                    VStack() {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .GiveMeTitle()
                    }
                    
                    //从数组中取出头3个元素
                    ForEach(0..<3){
                        number in
                        Button(action: {
                            flapTapped(number: number)
                            chosenFlag = number
                            withAnimation(.easeInOut(duration: 1)) {
                                rotationNum = 360
                                opacityNum = 0.5
                                scaleNum = 0.5
                            }
                        }, label: {
                            FlagImage(
                                imageURL: countries[number],
                                rotationAmount: (chosenFlag == number ? rotationNum : 0),
                                opacityAmount: (chosenFlag == number ? 1 : opacityNum),
                                scaleAmount: chosenFlag == number ? 1 : scaleNum
                            )
                            //通过索引查找国旗名字，再通过国旗名字去字典中查找说明，并附上一个默认值
                            .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        })
                        
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding(.horizontal, 30)
                
                Spacer()
                
                VStack{
                    Text("Your score is \(score)")
                        .foregroundStyle(.white)
                        .font(.subheadline.bold())
                }
                
                Spacer()
                Spacer()
                
            }
            
        }
        //每回合的提示框
        .alert(alertTitle, isPresented: $showscore) {
            Button(buttonText) {
                if current < 8{
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
    
    //方法：点击国旗
    func flapTapped(number: Int){
        current += 1
        if current < 8{
            if number == correctAnswer {
                score += 1
                alertTitle = "回答正确"
                alertMsg = "\(current)/8"
                buttonText = "继续"
            }else{
                alertTitle = "回答错误，你选的是\(countries[number])国旗"
                alertMsg = "\(current)/8"
                buttonText = "继续"
            }
        }else{
            if number == correctAnswer {
                score += 1
                alertTitle = "回答正确"
                alertMsg = "本轮结束，你这局的分数是：\(score)"
                buttonText = "再来一局"
            }else{
                alertTitle = "回答错误，你选的是\(countries[number])国旗"
                alertMsg = "本轮结束，你这局的分数是：\(score)"
                buttonText = "再来一局"
            }
        }
        showscore = true
    }
    
    //方法：重置游戏
    func resetGame(){
        current = 0
        score = 0
        askQuestion()
    }
    
    //方法：出题
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        chosenFlag = -1
        rotationNum = 0.0
        opacityNum = 1.0
        scaleNum = 1.0
    }
    
    
}




//子视图：国旗的视图
struct FlagImage: View {
    
    var imageURL: String
    var rotationAmount: Double
    var opacityAmount: Double
    var scaleAmount: Double
    
    var body: some View {
        Image(imageURL)
            .clipShape(.ellipse)
            .shadow(radius: 5)
            .rotation3DEffect(.degrees( rotationAmount ), axis: (x: 0.0, y: 1.0, z: 0.0))
            .opacity( opacityAmount )
            .scaleEffect( scaleAmount )
    }
}


//自定义标题样式
struct MyTitleStyle: ViewModifier{
    func body(content: Content) -> some View {
            return content
            .font(.largeTitle.weight(.semibold))
            .foregroundColor(.blue)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 8)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
   }
}


//拓展：自定义标题样式
extension View {
    func GiveMeTitle() -> some View {
        modifier(MyTitleStyle())
    }
}





//MARK: - 预览
#Preview {
    ContentView()
}



