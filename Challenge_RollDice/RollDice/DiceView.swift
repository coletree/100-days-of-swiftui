//
//  DiceView.swift
//  RollDice
//
//  Created by coletree on 2024/7/10.
//

import CoreHaptics
import SwiftUI




struct DiceView: View {


    // MARK: - 属性

    // 读取环境属性
    @Environment(DiceRollStore.self) var store

    // 属性：骰子最大值
    var sided : Int

    // 属性：骰子当前值
    @State private var currentNum : Int

    // 属性：骰子的状态
    @State private var isRolling = false
    @State private var isRollingComplete = true

    // 属性：震动效果
    @State private var engine: CHHapticEngine?




    // MARK: - 视图
    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.gray, lineWidth: 8)
                .frame(width: 140, height: 140, alignment: .center)

            Text("\(currentNum)")
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .foregroundStyle( (currentNum == 1 || currentNum == sided) ? .red : .black)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .transition(.opacity)
                .animation(.easeInOut)

        }
        // 点击骰子开始投掷
        .onTapGesture(perform: rollDice2)
        .disabled(isRolling)
        // 更新数字
        .onChange(of: sided) { oldValue, newValue in
            currentNum = Int.random(in: 1...newValue)
        }

    }




    // MARK: - 方法

    // 方法：自定义初始化方法
    init(sided: Int) {
        self.sided = sided
        _currentNum = State(wrappedValue: Int.random(in: 1...sided))
    }

    // 方法：掷骰子1
    func rollDice() {

        // 改变骰子状态
        isRolling = true

        // 变化节奏设置
        var time = 0.0
        let needTimes: Double = 3
        let step: Double = 0.2

        // 启动计时器
        _ = Timer.scheduledTimer(withTimeInterval: step, repeats: true) { timer in

            if time < needTimes {

                time += step

                // 计算下一次延迟时间 delay
                let delay = easeOutDelay(time, step)
                print(delay)

                // 该语句内的命令会延迟执行
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    currentNum = Int.random(in: 1...sided)
                    // print("timers等于\(time)，这轮骰子是\(currentNum)")
                }

            } else {
                // 停止计时器
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + needTimes) {
                    currentNum = Int.random(in: 1...sided)
                    print("闭包完成，times等于\(time)，最终值是\(currentNum)")
                    // 掷骰子完成
                    rollDiceComplete()
                }
            }

        }

    }

    // 方法：掷骰子2
    func rollDice2() {

        // 改变骰子状态
        isRolling = true

        // 变化次数设置
        let times: Int = 10

        // 把过程中生成的数值存起来
        var tempRolls: [Int] = []
        for _ in 0..<times {
            tempRolls.append(Int.random(in: 1...sided))
        }
        print(tempRolls)

        // 展示骰子数值
        for i in 0 ..< tempRolls.count {

            // 计算下一次延迟时间 delay
            let delay = pow(Double(i), 3) * 0.005
            print(delay)

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                currentNum = tempRolls[i]
            }
            if i == tempRolls.count - 1{
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    // 掷骰子完成
                    rollDiceComplete()
                }
            }
        }

    }


    // 方法：变速效果
    func easeOutDelay(_ m: Double, _ x: Double) -> Double {
        let t = 2.2
        return pow(m, t) * x
        // return (100 - num) / num * n
        // return 1.0
        // return t * t
        // return sin(t * .pi / 2)
        // return 1 - pow(1 - t, 4)
        // return 1 - pow(1 - t, 3)
        // return t * (2 - t)
    }

    // 方法：掷骰子完成
    func rollDiceComplete() {
        // 设置状态
        isRolling = false
        // 震动反馈
        complexSuccess()
        // 保存记录
        store.add(DiceRoll(faces: sided, result: currentNum, date: Date()))
    }

    // 方法：准备震动效果
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    // 方法：运行震动效果
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }

        var events = [CHHapticEvent]()

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

}




// MARK: - 预览
#Preview {
    DiceView(sided: 8)
        .environment(DiceRollStore())
}
