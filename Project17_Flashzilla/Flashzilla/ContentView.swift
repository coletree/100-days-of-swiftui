//
//  ContentView.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/26.
//

import SwiftUI




struct ContentView: View {
    
    
    
    //MARK: - 属性
    
    /*
     属性：创建并启动一个在主线程上，每秒触发一次的计时器
     每当该计时器触发时，都要从 timeRemaining 中减去 1，以便倒计时。
     虽然也可以尝试通过存储开始日期，并计算该日期与当前日期之间的差异来进行数学运算，但实际上没有必要！
     */
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //状态属性：用户当前剩余的游戏时间
    @State private var timeRemaining = 100
    

    
    //状态属性：标记是否要展示编辑卡片视图
    @State private var showingEditScreen = false
    
    //状态属性：数组有一个初始值设定项 init(repeating:count:) ，它采用一个值并重复多次来创建数组，特别适合测试。
    //@State private var cards = Array<Card>(repeating: .example, count: 10)
    //当视图首次显示时， resetCards() 被调用；当 EditCards 被关闭后，resetCards() 也被调用
    //这意味着我们可以放弃示例 cards 数据，并将其设为一个在运行时填充的空数组
    @State private var cards = [Card]()
    
    
    
    //环境属性：scenePhase
    @Environment(\.scenePhase) var scenePhase
    
    //状态属性：标记当前应用程序状态
    /*
     环境值 scenePhase 告诉我们应用程序在可见性方面是活跃的还是非活跃的
     但如果玩家已经浏览完抽认卡，我们也认为应用程序处于非活动状态，
     这种情况下，虽然场景阶段是 活跃的，但我们希望停止计时器
     */
    @State private var isActive = true
    
    
    
    
    //环境属性：accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    //环境属性：accessibilityVoiceOverEnabled
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        ZStack {
            
            
            //视图：背景图层，标记为纯装饰图像，不需要 VoiceOver 读出
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            
            //视图：卡片堆栈
            VStack {
                
                //视图：计时器
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                //视图：卡片堆栈
                ZStack {
                    //card数据模型用了Identifiable，这里只能改成cards，不能用整数
                    ForEach(cards) {
                        card in
                        
                        //这里强制解包
                        let index = cards.firstIndex(of: card)!
                        
                        /*
                         这里的 CardView 实例化时需要初始化参数，其中一个参数是 card 模型
                         另外两个参数是 removal 闭包，于是在这里后面就跟了两个闭包（一个对一个错）
                         这个闭包是在卡片拖动到一定程度时执行的，这个是在 CardView 里定义的
                        */
                        CardView(card: cards[index], removalRight: {
                            /*
                             将 removeCard(at:) 方法包装在 withAnimation() 中调用
                             那么删除卡片时，其他卡片将自动向上滑动，有动画
                            */
                            withAnimation {
                                removeCardRight(at: index)
                            }
                        }, removalWrong: {
                            /*
                             将 removeCard(at:) 方法包装在 withAnimation() 中调用
                             那么删除卡片时，其他卡片将自动向上滑动，有动画
                            */
                            withAnimation {
                                removeCardWrong(at: index)
                            }
                        })
                        
                        //修饰符：添加扩展的自定义修饰符，传入卡片索引
                        .stacked(at: index, in: cards.count)
                        
                        //修饰符：判断如果不是最上面的卡片，不允许被拖动；也不支持被 VoiceOver 读出
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                
                /*
                 通过将 allowsHitTesting() 设置为 false ，可以禁用视图的交互性；
                 这里通过检查 timeRemaining 剩余时间是否大于 0，决定是否禁用卡片交互
                 */
                .allowsHitTesting(timeRemaining > 0)
                
                //重置按钮视图：判断当卡片空了的时候，显示重置按钮
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
                
            }
            
            
            //视图：进入新增卡片界面的按钮
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            
            //判断视图：无颜色区分 & 启用了VoiceOver时，显示两个按钮
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                removeCardWrong(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        //可用性：VoiceOver读出的内容
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                removeCardRight(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        //可用性：VoiceOver读出的内容
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
            
            
        }
        .onReceive(timer) { time in
            //确保当前状态是 活跃，才进行计数，否则退出
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        //原API要被舍弃，这里必须加上两个参数oldState, newState，或者不加
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        //视图：编辑卡片
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .onAppear(perform: resetCards)
        
        
    }
    
    
    
    
    //MARK: - 方法
    
    //方法：删除具体卡片(回答正确时)
    func removeCardRight(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        print(cards.count)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    //方法：删除具体卡片(回答错误时，不能直接删除，需要继续回答)
    func removeCardWrong(at index: Int) {
        guard index >= 0 else { return }
        //将不会的卡片转存一下，后面再重新插入
        let tempCard = cards[index]
        cards.remove(at: index)
        cards.insert(tempCard, at:0)
        print(cards.count)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    //方法：重置所有卡片
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    //方法：读取数据
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    
    
    
}



//MARK: - 其他

//扩展：新的修饰符
extension View {
    
    //创建新的 stacked() 修饰符，它获取数组中的位置以及数组的总大小，并根据这些值将视图偏移一定量。
    //这能够创建有吸引力的卡牌堆，其中每张卡牌在屏幕上的位置都比之前的卡牌稍远一些。
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
