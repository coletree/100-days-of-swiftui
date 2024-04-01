//
//  ContentView.swift
//  Instafilter
//
//  Created by coletree on 2024/1/9.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI



struct ContentView: View {
    

    //MARK: - 属性

    
    //UserDefault键：使用 UserDefault 记录滤镜使用的次数
    @AppStorage("filterCount") var filterCount = 0
    
    //环境参数：请求AppStore评分
    @Environment(\.requestReview) var requestReview
    
    //状态属性：跟踪用户选择的图片
    @State private var selectedItem: PhotosPickerItem?
    
    //状态属性：展示在界面上的Image视图
    @State private var processedImage: Image?
    
    //常量：创建 CI 框架的【图像上下文】
    let context = CIContext()
    
    //状态属性：创建 CI 框架的【当前过滤器/滤镜】，默认值是.sepiaTone()
    //原先的代码 CIFilter.sepiaTone() 会返回一个符合 CISepiaTone 协议的 CIFilter 对象。
    //但添加了显式类型注释后，意味过滤器遵循 CIFilter 而不是 CISepiaTone ，这样将丢弃一些之前的属性设置方法
    @State private var currentFilter: CIFilter = CIFilter.bumpDistortion()
    
    //状态属性：滤镜的强度等参数
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
    @State private var filterScale = 5.0
    
    //状态属性：控制【滤镜选择器】是否弹出
    @State private var showingFilters = false
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack{
            
            VStack {
                
                Spacer()
                
                //图片选择区：把原来的 Image、ContentUnavailableView 当作 PhotosPicker 的 label，可以扩大点击区域
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
                //使用按钮.plain样式，可以让选择按钮区域不用默认的蓝色
                .buttonStyle(.plain)
                //监控状态属性 PhotosPickerItem。由于上面的图片选择器是绑定 $selectedItem ，所以 @State 无法实时反应变动，需要改用 onChange
                .onChange(of: selectedItem, loadImage)
                //异步方法要用 Task 和 try awiat，以下方法已合并到 loadImage 方法中
//              .onChange(of: selectedItem) {
//                  Task {
//                      processedImage = try await selectedItem?.loadTransferable(type: Image.self)
//                  }
//              }
                
                Spacer()
                
                //滤镜各参数的强度滑动条
                VStack {
                    
                    //如果存在 kCIInputIntensityKey，就显示 Intensity 滑动条
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: $filterIntensity)
                                //监控状态属性 filterIntensity
                                .onChange(of: filterIntensity) {
                                    //属性发生改变时，调用函数 applyProcessing
                                    applyProcessing()
                                }
                                //没有选择图片时先禁用
                                .disabled(processedImage == nil)
                            
                        }
                        .padding([.horizontal, .bottom])
                    }
                    
                    //如果存在 kCIInputRadiusKey，就显示 Radius 滑动条
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                            Slider(value: $filterRadius, in: 0...200)
                                .onChange(of: filterRadius) {
                                    applyProcessing()
                                }
                                .disabled(processedImage == nil)
                            
                        }
                        .padding([.horizontal, .bottom])
                    }
                    
                    //如果存在 kCIInputScaleKey，就显示 Scale 滑动条
                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            Text("Scale")
                            Slider(value: $filterScale, in: 0...10)
                                .onChange(of: filterScale) {
                                    applyProcessing()
                                }
                                .disabled(processedImage == nil)
                            
                        }
                        .padding([.horizontal, .bottom])
                    }
                    
                }
                
                //底部操作栏
                HStack {
                    Spacer()
                    //选择图片后再显示
                    if let processedImage{
                        //点击按钮执行 changeFilter 方法
                        Button("Change Filter", action: changeFilter)
                        Spacer()
                        //共享图片
                        ShareLink(
                            item: processedImage,
                            preview: SharePreview("处理图片", image: processedImage)
                        ){
                            Label("Share Image", systemImage: "square.and.arrow.up")
                        }
                    }
                    //如果没选择图片，就禁用
                    else{
                        Button("Change Filter", action: changeFilter)
                            .foregroundStyle(.gray)
                            .disabled(true)
                        Spacer()
                        Label("Share Image", systemImage: "square.and.arrow.up")
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            //选择滤镜的弹窗
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                // dialog here
                Button("BokehBlur") { setFilter(CIFilter.bokehBlur()) }
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("DotScreen") { setFilter(CIFilter.dotScreen()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Noir") { setFilter(CIFilter.photoEffectNoir()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Pointillize") { setFilter(CIFilter.pointillize()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
            
            
        }
        
        
    }
    
    
    //MARK: - 方法
    
    //方法：读取图像。每次 selectedItem 发生变化时，会调用该方法
    func loadImage() {
        
        Task {
            //1. 将 PhotosPickerItem 对象转成纯 Data 对象，然后将该 Data 对象转换为 UIImage
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            //2. 将 UIImage 转成 CIImage
            let beginImage = CIImage(image: inputImage)
            
            //3. 将图像发送到【当前过滤器】，如果使用过滤器的 inputImage 属性输入，容易崩溃；建议使用 setValue
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            //4. 调用方法处理图像
            applyProcessing()
            
        }
        
    }
    
    
    //方法：应用图像处理
    func applyProcessing() {
        
        //1. 因为CoreImage框架较老，所以过滤器的强度参数值是 Float 而不是 Double，这里转化了一下
        //currentFilter.intensity = Float(filterIntensity)
        //由于前面定义的的【当前过滤器】明确了遵循的是 CIFilter 协议，而不是 CISepiaTone，所以上面那行代码失效了，无法直接用 intensity 属性，需要用到 setValue 来设置。kCIInputIntensityKey 是另一个Core Image常量值，它与设置棕褐色调滤镜的 intensity 参数具有相同的效果。
        //但由于我们放弃了过滤器的 CISepiaTone 限制，被迫使用 setValue(_:forKey:) 方法去 发送值，这导致会有安全性问题。因为如果选的具体滤镜对象里，没有kCIInputIntensityKey强度值，应用程序就会崩溃。
        //所以我们添加 inputKeys 代码来储存 setValue(_:forKey:) 的所有有效键。然后判断仅在“当前过滤器支持它”情况下设置强度键。
        //使用这种方法，实际上可以查询任意数量的键，并设置所有支持的键。对于棕褐色调这将设置强度，但对于高斯模糊将设置模糊半径，依此类推。
        let inputKeys = currentFilter.inputKeys

        //这种条件方法适用于您选择应用的任何过滤器，这意味着您可以安全地与其他过滤器进行实验。您唯一需要注意的是确保将 filterIntensity 放大一个有意义的数字 - 例如，1 像素模糊几乎是不可见的，所以我将乘以它200 使其更加明显。
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
        }
        
        //currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        
        //2. 通过【当前过滤器】输出 CIImage
        guard let outputImage = currentFilter.outputImage else { return }
        
        //3. 将输出的 CIImage 数据，转化为 CGImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        //4. 将输出的 CGImage 数据，转化为 UIImage
        let uiImage = UIImage(cgImage: cgImage)
        
        //5. 将输出的 UIImage 图像，转化为 Image，赋予 processedImage
        processedImage = Image(uiImage: uiImage)
        
    }
    
    
    //方法：更换当前【滤镜过滤器】
    func changeFilter() {
        //弹出选择框
        showingFilters = true
    }
    
    
    //方法：设置新的【滤镜过滤器】
    //@MainActor 确保在测试中也能测试评分功能
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        print("Input Keys: \(currentFilter.inputKeys)")
        loadImage()
        
        //计数用户用了多少次滤镜
        filterCount += 1
        if filterCount >= 20 {
            requestReview()
        }
        
    }
    
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
