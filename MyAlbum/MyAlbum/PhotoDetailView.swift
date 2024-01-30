//
//  PhotoDetailView.swift
//  MyAlbum
//
//  Created by coletree on 2024/1/27.
//

import SwiftUI




struct PhotoDetailView: View {
    
    //MARK: - 属性
    
    //var photo : Photo
    
    
    
    //MARK: - 视图
    var body: some View {
        
        ZStack {
            Image(.coletree)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
                .overlay {
                    Color.black.opacity(0.4)
                }
            Text("photo.title")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .fontWeight(.heavy)
                .accessibilityLabel("Label")
        }
        .ignoresSafeArea(.all)
        
    }

    
    
}




//MARK: - 预览
#Preview {
    PhotoDetailView()
}
