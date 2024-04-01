//
//  AddBookView.swift
//  Bookworm
//
//  Created by coletree on 2023/12/27.
//


import SwiftData
import SwiftUI




struct AddBookView: View {
    
    
    //MARK: - 属性
    
    //环境属性：创建模型上下文
    //要使用SwiftData，先要声明一个【模型上下文】的环境属性
    //该视图有自己的环境，因此如果您想使用共享值，需要先将它们传入
    @Environment(\.modelContext) var modelContext
    
    //环境属性：关闭当前页面函数
    @Environment(\.dismiss) var dismissIt
    
    //状态参数：用于新建 book 对象的表单
    @State var title: String = ""
    @State var author: String = ""
    @State var genre: String = "Fantasy"
    @State var review: String = ""
    @State var rating: Int = 0
    
    //常量属性：所有的分类选项
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    

    //计算属性：验证表单输入框，通过一些方法返回布尔值
    var titleIsValid : Bool {
        return titleValid()
    }
    
    var authorIsValid : Bool {
        return authorValid()
    }
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            Form{
                
                //1. 填写基本信息
                Section{
                    TextField("书籍名称:", text: $title)
                    TextField("作者名称:", text: $author)
                    Picker("类别:", selection: $genre) {
                        ForEach(genres, id: \.self){
                            item in
                            Text(item).tag(item)
                        }
                    }
                    
                }
                
                //2. 填写评价信息
                Section("Write a review"){
                    
                    //当表单或列表中有 row 时，SwiftUI 喜欢假设 row 本身是可点击的。
                    //这使得用户可以更轻松地进行选择，因为他们可以点击行中的任意位置来触发其中的按钮。
                    HStack {
                        Text("书籍评分：")
                        Spacer()
                        StarRatingView(rating: $rating)
                    }.padding(.vertical,10)
                    
                    //传统的Picker
//                  Picker("", selection: $rating) {
//                    ForEach(0..<6){
//                        Text("\($0)").tag($0)
//                    }
//                  }
//                  .pickerStyle(.segmented)
                    
                    TextEditor(text: $review)
                        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 60, idealHeight: 140, maxHeight: 200, alignment: .center)
                    
                }
                
                //3. 保存按钮
                Section {
                    Button("Save") {
                        //写入新的 swiftData 对象
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismissIt()
                    }
                    .disabled(!(titleIsValid && authorIsValid))
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                }
                
                
            }
        }
        .navigationTitle("Add Book")
        
    }
    
    
    //MARK: - 方法
    
    //方法：检查书籍名是否填写正确
    func titleValid() -> Bool {
        let processed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if processed.isEmpty{
            return false
        }
        return true
    }
    
    //方法：检查作者名是否填写正确
    func authorValid() -> Bool {
        let processed = author.trimmingCharacters(in: .whitespacesAndNewlines)
        if processed.count <= 1{
            return false
        }
        return true
    }
    
    
}


//MARK: - 预览
#Preview {
    AddBookView()
}
