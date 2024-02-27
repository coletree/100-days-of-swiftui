//
//  EditCards.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/27.
//

import SwiftUI

struct EditCards: View {
    
    
    //MARK: - 属性
    
    //环境属性：解除视图
    @Environment(\.dismiss) var dismiss
    
    //状态属性：所有卡片的数组
    @State private var cards = [Card]()
    
    //状态属性：
    @State private var newPrompt = ""
    
    //状态属性：
    @State private var newAnswer = ""
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //导航视图
        NavigationStack {
            
            //列表：
            List {
                
                //视图：填写新卡片的表单
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    //提交按钮，调用 addCard 函数
                    Button("Add Card", action: addCard)
                }

                //视图：卡片堆栈
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            //工具栏设置
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }
        
    }

    
    
    //MARK: - 方法
    
    //方法：完成编辑。解除该视图
    func done() {
        dismiss()
    }

    //方法：从 UserDefaults 读取数据，并赋值给 cards 数组
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }

    //方法：保存数据到 UserDefaults 的 Cards 键
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }

    //方法：新增卡片。
    func addCard() {
        //去除空格键后做检查
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        //确保新增卡片的信息不为空
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        //生成卡片 card 实例：从状态属性 prompt 和 answer 中
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        //插入卡片
        cards.insert(card, at: 0)
        //完成添加后，保存所有数据
        saveData()
        newPrompt = ""
        newAnswer = ""
    }

    //方法：删除卡片
    func removeCards(at offsets: IndexSet) {
        //删除卡片
        cards.remove(atOffsets: offsets)
        //完成删除后，保存所有数据
        saveData()
    }
    
}





//MARK: - 预览
#Preview {
    EditCards()
}
