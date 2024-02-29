//
//  CardView.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/27.
//

import SwiftUI




struct CardView: View {
    
    //MARK: - 属性
    
    //属性：单个卡片数据实例
    let card: Card
    
    //属性：存储一个闭包，该方法可以填充稍后想要的任何代码。借助该闭包，可以灵活地在 ContentView 中获取回调
    var removalRight: (() -> Void)? = nil
    
    var removalWrong: (() -> Void)? = nil
    
    //状态属性：是否展示正确答案
    @State private var isShowingAnswer = false
    
    //状态属性：储存卡片被拖动的范围
    @State private var offset = CGSize.zero
    
    //状态属性：背景色。用这个属性解决卡片回位时会先变红的问题
    @State var bgColor: Color = .white
    
    //环境属性：accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    //环境属性：accessibilityVoiceOverEnabled
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    


    
    
    //MARK: - 视图
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    //判断：三元运算符可以直接用
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    //判断：三元运算符可以直接用
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(using: offset)
                        //改用了扩展来实现
                        //.fill(bgColor)
                )
                .shadow(radius: 10)

            VStack {
                //判断：如果启用了VoiceOver，那再看isShowingAnswer的状态
                //如果 isShowingAnswer为true ，显示 answer；否则显示 prompt
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
                //判断：如果没有启用VoiceOver，那两个都显示
                else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 2)
        /*
         使用 2 是有意为之的，因为它允许卡片在被稍微拖动时保持不透明。因此，如果用户根本没有拖动，则不透明度为 2.0，这与不透明度为 1 相同。如果用户向左或向右拖动 50 点，我们将其除以 50 得到 1，然后从 2 中减去该值得到 1，所以不透明度仍然是 1——卡片仍然完全不透明。但超过 50 点时，我们开始淡出卡片，直到左侧或右侧 100 点时不透明度为 0。
         */
        .opacity(2 - Double(abs(offset.width / 80)))
        //明确卡片是可点击的按钮
        .accessibilityAddTraits(.isButton)
        //拖动手势
        .gesture(
            DragGesture()
                .onChanged { 
                    gesture in
                    offset = gesture.translation
                    bgColor = offset.width > 0 ? .green : .red
                }
                .onEnded { 
                    _ in
                    if offset.width > 200 {
                        //大于200是代表正确
                        //offset 判断：拖动超过 200 后，执行闭包 removalRight
                        //注意：问号代表该闭包只会在有值的时候被调用
                        removalRight?()
                    }
                    else if offset.width < -200 {
                        //小于-200是代表错误
                        //offset 判断：拖动超过 -200 后，执行闭包 removalWrong
                        //注意：问号代表该闭包只会在有值的时候被调用
                        removalWrong?()
                        offset = .zero
                    }else {
                        //松手后，先让卡片背景色变成白色
                        bgColor = .white
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        //增加动画
        .animation(.bouncy, value: offset)
        
    }

    
    //MARK: - 方法
    
    
    
    
}



//MARK: - 其他


//扩展：shape 的 fill 方法
extension Shape {
    func fill(using offset: CGSize) -> some View{
        if offset.width == 0{
            return self.fill(.white)
        }else if offset.width < 0{
            return self.fill(.red)
        }else{
            return self.fill(.green)
        }
    }
}





//MARK: - 预览
#Preview {
    CardView(card: Card.example)
}
