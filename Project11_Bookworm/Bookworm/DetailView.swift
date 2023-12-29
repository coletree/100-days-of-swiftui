//
//  DetailView.swift
//  Bookworm
//
//  Created by coletree on 2023/12/28.
//

import SwiftData
import SwiftUI


struct DetailView: View {
    
    
    //MARK: - 属性
    
    //1. 传入的 book 对象
    let book: Book
    
    //2. 用于保存 SwiftData 模型上下文（以便我们可以删除内容）
    //以工作表形式呈现的视图有自己的环境，因此如果您想共享值，则需要将它们传入。
    @Environment(\.modelContext) var modelContext
    
    //3. 用于保存关闭操作（以便可以从导航堆栈中弹出视图）
    @Environment(\.dismiss) var dismiss
    
    //4. 控制是否显示删除确认警报
    @State private var showingDeleteAlert = false
    
    
    
    //MARK: - 视图
    var body: some View {
        
        ScrollView {
            
            //1. 基本信息
            ZStack(alignment: .bottom) {
                
                Image(book.genre)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, minHeight: 0, idealHeight: 300, maxHeight: .infinity, alignment: .center)

                Text(book.genre.uppercased())
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: 0, y: -20)
                
            }
            
            Spacer(minLength: 20)
            
            Text(book.author)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.vertical,8)

            Text(book.review)
                .foregroundStyle(.secondary)
                .padding(.horizontal,15)
            
            Spacer(minLength: 40)
            
            
            //2. 评价信息
            
            //写法1: 不希望用户能够在此处调整评级，因此我们可以使用另一个常量绑定将其转换为简单的只读视图。
            //StarRatingView(rating: .constant(book.rating)).padding()
            
            //写法2:
            HStack {
                ForEach(1..<book.rating + 1, id: \.self){
                    _ in
                    Text("⭐️").font(.largeTitle)
                }
            }
            
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        //设置标题栏按钮
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
        //设置弹窗
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            //如果选了delete，则执行方法 deleteBook
            Button("Delete", role: .destructive, action: deleteBook)
            //如果选了cancel，则什么都不做，swift会自动收起弹窗
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("要删除这本书吗?")
        }
        
    }
    
    
    //MARK: - 方法
    func deleteBook() {
        //如此方便，不需要告诉 swift ，删除的是哪本书，之前还以为要传递索引值再去找
        modelContext.delete(book)
        dismiss()
    }
    
    
    
}


//MARK: - 预览
//由于最前面定义了一个 Book 属性，导致 DetailView.swift 底部的预览代码失效；
//以往，这个问题是通过发送一个示例对象，或者.constant(value)的绑定常量来解决；
//但涉及 SwiftData 时就麻烦一点：因为创建一个SwiftData对象，需要一个视图上下文来在里面创建它；

#Preview {
    do {

        //1.由于并不希望创建的模型容器实际存储任何内容；则需要创建【自定义配置】，告诉 SwiftData 仅将信息存储在内存中；
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        //2.使用刚刚的【自定义配置】，来创建一个模型容器；
        let container = try ModelContainer(for: Book.self, configurations: config)
        
        //3. 这是准备好的 book 对象数据（这个不能放到前面，顺序不能换）
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4)
        
        //4.返回以下内容给Preview；
        return DetailView(book: example).modelContainer(container)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
