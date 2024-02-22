//
//  MeView.swift
//  HotProspects
//
//  Created by coletree on 2024/2/21.
//

import CoreImage.CIFilterBuiltins
import SwiftUI





struct MeView: View {
    
    
    //MARK: - 属性
    
    //添加两个属性保存姓名和电子邮件地址
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
    
    //需要两个属性来存储活动的 Core Image 上下文，和 Core Image 的 QR 代码生成器过滤器的实例
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    //MARK: - 视图
    var body: some View {
        
        
        NavigationStack {
            
            Form {
                
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title2)

                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title2)
                
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
            }
            .navigationTitle("Your code")
        }
        
        
    }
    
    
    
    
    
    //MARK: - 方法
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    
    
    
}




//MARK: - 预览
#Preview {
    MeView()
}
