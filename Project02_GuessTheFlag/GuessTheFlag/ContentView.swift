//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by coletree on 2023/11/17.
//

import SwiftUI





struct ContentView: View {
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showscore = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var buttonText = ""
    
    @State private var score = 0
    @State private var current = 0
    
    
    
    @State private var rotationNum = 0.0
    @State private var opacityNum = 1.0
    @State private var scaleNum = 1.0
    @State private var chosenFlag: Int? = nil
    
    
    
    
    let roundNum = 8
    
    
    var body: some View {
        
        ZStack {
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
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
    
    func resetGame(){
        current = 0
        score = 0
        askQuestion()
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        chosenFlag = -1
        rotationNum = 0.0
        opacityNum = 1.0
        scaleNum = 1.0
    }
    
}

#Preview {
    ContentView()
}



//定义国旗的视图
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







extension View {
    func GiveMeTitle() -> some View {
        modifier(MyTitleStyle())
    }
}
