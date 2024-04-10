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
    
    //储存生成的二维码图像
    @State private var qrCode = UIImage()
    
    
    
    
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
                
                //Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                //要解决紫色警告的循环调用问题，需要 Image 视图使用缓存的 QR 代码：
                //这样意味着需要另外找一个地方来更新二维码：
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    //设置长按菜单
                    .contextMenu {
                        //let image = generateQRCode(from: "\(name)\n\(emailAddress)")
                        ShareLink(
                            item: Image(uiImage: qrCode),
                            preview: SharePreview("My QR Code", image: Image(uiImage: qrCode))
                        )
                    }
                
            }
            .navigationTitle("Your code")
            //视图出现时：生成二维码
            //当名称和邮件发生变更时：更新二维码
            .onAppear(perform: updateCode)
            .onChange(of: name, updateCode)
            .onChange(of: emailAddress, updateCode)
        }
        
        
    }
    
    
    
    
    
    //MARK: - 方法
    
    
    //方法：只负责生成二维码，返回UIImage
    func generateQRCode(from string: String) -> UIImage {
        
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        //出现紫色警告，意味着当前的视图主体调用 generateQRCode() 来创建上下文菜单附加到的可共享图像
        //但现在调用该方法会在 qrCode 属性中保存一个用 @State 进行标记的值
        //@State 值的改变，又会反过来导致视图主体被重新调用
        //于是这会导致一个循环，因此 SwiftUI 会退出并标记一个大警告

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    //方法：更新二维码。重新调用生成的方法，并将方法返回的 UIImage 赋予 @State 的 qrCode
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    
    
}




//MARK: - 预览
#Preview {
    MeView()
}
