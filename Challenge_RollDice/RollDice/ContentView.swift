//
//  ContentView.swift
//  RollDice
//
//  Created by coletree on 2024/3/1.
//

import SwiftUI
import CoreHaptics



struct ContentView: View {


    // MARK: - 属性

    // 读取环境属性
    @Environment(DiceRollStore.self) var store

    // 当前骰子
    @State private var selectedDice: Int = 10

    // 可选骰子
    let allDices = [4, 6, 8, 10, 12, 20, 100]




    // MARK: - 视图
    var body: some View {

        NavigationStack {

            // 掷骰子区
            VStack {

                HStack {
                    Text("选择骰子:")
                    Picker("选择骰子", selection: $selectedDice) {
                        ForEach(allDices, id: \.self) { dice in
                            Text("\(dice) 面骰子")
                                .tag(dice)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()

                VStack(alignment: .center, spacing: 20) {

                    DiceView(sided: selectedDice)
                        .padding(.top, 20)

                    Text("点击上方 🎲 开始投掷")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 40)
                }

            }

            // 历史列表
            List {
                Button("清除历史记录") {
                    store.deleteAll()
                }
                ForEach(store.rolls.reversed()){ roll in
                    HStack {
                        Text("\(roll.result)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .padding(.leading, 10)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("骰子面数：\(roll.faces)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text(roll.date, format: .dateTime)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

        }

    }


}




// MARK: - 预览
#Preview {
    ContentView()
        .environment(DiceRollStore())
}
