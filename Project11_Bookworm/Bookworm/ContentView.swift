//
//  ContentView.swift
//  Bookworm
//
//  Created by coletree on 2023/12/26.
//

import SwiftData
import SwiftUI


struct ContentView: View {

    
    //MARK: - 属性
    
    //1. 环境属性
    @Environment(\.modelContext) var modelContext
    
    //2. 读取 SwiftData 对象
    @AppStorage("notes") private var notes = ""
    @Query(sort: [
        SortDescriptor(\Book.rating, order: .reverse),
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) var books: [Book]
    
    //3. 状态属性
    @State var showAddBookView = false
    
    

    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            List {
                
                ForEach(books, id: \.self) {
                    book in
                    NavigationLink(value: book) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.title).font(.headline)
                                    .foregroundStyle( book.rating == 1 ? .red : .black )
                                Text(book.author).foregroundStyle(.secondary)
                                //当编写 day().month().year() 时，我们要求的是数据，而不是排列它，iOS 将使用用户的偏好自动格式化该数据
                                Text(book.createDate.formatted(date: .long, time: .shortened))
                                    .font(.footnote)
                            }
                            Spacer()
                            EmojiRatingView(rating: book.rating).font(.largeTitle)
                        }
                    }
                }
                //onDelete(perform:) 左滑删除修饰符，它需要位于 ForEach 上，而不是 List
                .onDelete(perform: deleteBooks)
                
            }
            //导航目的页设置：NavigationDestination不能加到里面的ForEach上，否则会导致循环多次导航
            .navigationDestination(for: Book.self) {
                item in
                DetailView(book: item)
            }
            //导航基本设置：
            .navigationTitle("BookShelf \(books.count)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showAddBookView = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            //弹窗设置
            .sheet(isPresented: $showAddBookView) {
                AddBookView()
            }
            
        }

    }
    
    
    //MARK: - 方法
    
    //方法1：删除一本书
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our query
            let book = books[offset]
            // delete it from the context
            modelContext.delete(book)
        }
    }
    
    
    
}





//MARK: - 预览
#Preview {
    ContentView()
}
