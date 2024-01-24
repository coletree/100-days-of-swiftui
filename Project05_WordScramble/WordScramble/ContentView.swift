//
//  ContentView.swift
//  WordScramble
//
//  Created by coletree on 2023/11/29.
//

import SwiftUI


struct ContentView: View {
    
    //MARK: - 属性
    
    //状态属性：用户输入的所有正确的词
    @State private var usedWords = [String]()
    
    //状态属性：根词
    @State private var rootWord = ""
    
    //状态属性：当前正在输入的词
    @State private var newWord = ""
    
    //状态属性：用户输入正确的词数量
    @State private var bingoNum = 0
    
    //状态属性：出错信息弹窗
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    
    //MARK: - 视图
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("你已经拼出了\(bingoNum)个单词。继续加油：")
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }

                Section {
                    //如果 usedWords 中有大量重复项，使用 id: \.self 会导致问题
                    ForEach(usedWords, id: \.self) {
                        word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                                .foregroundStyle(.gray)
                            Text(word)
                        }
                        //VoiceOver 可用性
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle(rootWord)
            .toolbar{
                Button("Restart") {
                    resetGame()
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            //视图：提示框
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    
    //MARK: - 方法
    
    
    //方法：游戏开始
    func startGame(){
        //1. 我们传入一个文件 URL，如果可以加载该文件，它将发送回一个包含该文件内容的字符串。
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                // 4. 随机选取一个词，或使用 "silkworm" 作为默认
                rootWord = allWords.randomElement() ?? "silkworm"
                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    //方法：重置游戏
    func resetGame(){
        usedWords = [String]()
        newWord = ""
        bingoNum = 0
        startGame()
    }
    
    //方法：提交新词
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 2 else {
            wordError(title: "答案至少包含3个字母", message: "再想想")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "答案不能和原词一样", message: "开动脑筋")
            return
        }
        
        //检查是否已经提交过该词
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        //检查是否可能
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
            newWord = ""
            bingoNum += 1
        }
    }
    
    
    //方法：检查是否已经提交过该词
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    //方法：检查单词是否是可能的
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            //用word里的每个字母，去查找tempWord里是否包含
            if let pos = tempWord.firstIndex(of: letter) {
                //一旦找到（返回索引值），就利用该索引位置把该位置的字母删掉
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    //方法：是否真实存在这个单词
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    //方法：错误提示
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
