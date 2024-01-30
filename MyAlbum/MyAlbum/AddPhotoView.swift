//
//  AddPhotoView.swift
//  MyAlbum
//
//  Created by coletree on 2024/1/27.
//

import PhotosUI
import SwiftUI





struct AddPhotoView: View {
    
    //MARK: - 属性
    
    //环境变量：用于解除视图
    @Environment(\.dismiss) var dismiss
    

    //状态属性：跟踪用户选择的图片
    @State private var selectedItem: PhotosPickerItem?
    
    //状态属性：展示在界面上的Image视图
    @State private var processedImage: Image?
    
    //状态属性：图片标题
    @State var picTitle = ""
    
    
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            Form{
                
                Section{
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let processedImage {
                            processedImage
                                .resizable()
                                .scaledToFit()
                        } else {
                            ContentUnavailableView("选择图片", systemImage: "photo.badge.plus", description: Text("点击导入相册图片"))
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .onChange(of: selectedItem) {
                    Task {
                        processedImage = try await selectedItem?.loadTransferable(type: Image.self)
                    }
                }
                
                Section{
                    TextField("Describe the photo", text: $picTitle)
                }
                
            }
        }
        .navigationBarTitle("Add Photo")
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
                }) {
                    HStack {
                        Image(systemName: "plus.app.fill")
                        Text("Add")
                    }
                }
                
            }
            
        }
        
    }
    
    
    
}




//MARK: - 预览
#Preview {
    AddPhotoView()
}
