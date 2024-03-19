//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Paul Hudson on 14/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - 属性
    
    //MARK: - 视图
    var body: some View {
        VStack {
            Text("HAHAHAH World")
                .padding()
                .background(.red)
                .padding()
                .background(.blue)
                .padding()
                .background(.green)
                .padding()
                .background(.yellow)

            Button("Hello World") {
                print(type(of: self.body))
            }
            .frame(width: 200, height: 100)
            .background(.red)

            VStack(spacing: 10) {
                CapsuleText(text: "First").foregroundStyle(.white)
                CapsuleText(text: "Second").foregroundStyle(.yellow)
            }

            GridStack(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
        }
    }
    
}







//MARK: - 其他

//视图：胶囊文字
struct CapsuleText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(.capsule)
    }
}

//视图：标题
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 4))
    }
}

//视图：扩展
extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}


//视图：水印
struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

//视图：扩展
extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}



struct GridStack<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
    
}


//视图：MottoView
struct MottoView: View {
    
    //视图作为属性
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")

    var body: some View {
        VStack {
            VStack {
                motto1.foregroundStyle(.red)
                motto2.foregroundStyle(.blue)
            }
        }
    }
    
}






//MARK: - 预览
#Preview {
    ContentView()
}
