//
//  ContentView.swift
//  MyAlbum
//
//  Created by coletree on 2024/1/27.
//

import SwiftUI




struct ContentView: View {
    
    
    //MARK: - 属性
    
    //属性：网格布局
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    //状态属性：是否展示 AddPhotoView
    @State var showAddPhotoView = false
    
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<20) {
                        index in
                        //这里放置你想要在网格中显示的内容
                        NavigationLink(
                            //设置目标页面，并且传了一个参数进去
                            destination: PhotoDetailView()
                        ) {
                            //NavigationLink的视图内容
                            VStack(alignment: .center, spacing: -2) {
                                Image(.coletree)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                Text("Item \(index + 1)")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.black)
                                    .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 8, x: 4, y: 4)
                            .padding(.bottom, 20)
                        }
                        
                        
                    }
                }
                .padding(20)
            }
            .navigationTitle("Photos")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button(action: {
                        //按钮动作
                    }) {
                        HStack {
                            Text("Sort")
                        }
                    }
                    Button(action: {
                        //按钮动作
                        self.showAddPhotoView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.app.fill")
                            Text("Add")
                        }
                    }
                    
                }
                
            }
            //添加弹窗
            .sheet(isPresented: $showAddPhotoView){
                AddPhotoView()
            }
        }
        
    }
    
    
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
