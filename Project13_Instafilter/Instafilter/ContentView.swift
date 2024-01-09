//
//  ContentView.swift
//  Instafilter
//
//  Created by coletree on 2024/1/9.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI



struct ContentView: View {
    
    //MARK: - 属性
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    
    //我们创建 Image 视图作为可选的 @State 属性，让它调整大小与屏幕大小相同
    @State private var image: Image?
    
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        //添加 onAppear() 修饰符以实际加载图像
        //onAppear() 修饰符附加到 image 周围的 VStack 上，因为如果加到 image 上
        //当 image？（可选图像）是 nil 的时候，onAppear() 就不会触发
        .onAppear(
            perform: loadImage
        )
        
        
        Button("Hello, World!") {
            showingConfirmation = true
        }
        .frame(width: 300, height: 300)
        .background(backgroundColor)
        .confirmationDialog("Change background", isPresented: $showingConfirmation) {
            Button("Red") { backgroundColor = .red }
            Button("Green") { backgroundColor = .green }
            Button("Blue") { backgroundColor = .blue }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select a new color")
        }
        
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any saved snippets yet.")
        } actions: {
            Button("Create Snippet") {
                // create a snippet
            }
            .buttonStyle(.borderedProminent)
        }
        
        
    }
    
    
    //MARK: - 方法
    //更改该方法，以便从示例图像创建 UIImage ，然后使用 Core Image 对其进行操作，具体需要两步：
    func loadImage() {
        
        //1. 将示例图像加载到 UIImage 中，它有一个名为 UIImage(resource:) 的初始方法，用于从资产目录加载图像
        let inputImage = UIImage(resource: .example)
        
        //2. 将其转换为 CIImage ，这就是 Core Image 想要使用的
        let beginImage = CIImage(image: inputImage)
        
        //3. 创建【核心图像上下文】和【核心图像过滤器】。过滤器是以某种方式完成图像数据转换的实际工作，例如模糊图像、锐化图像、调整颜色等等，上下文负责将处理后的数据转换为我们可以工作的 CGImage。
        let context = CIContext()
        
        let currentFilter = CIFilter.pixellate()
        currentFilter.inputImage = beginImage
        
        let amount = 1
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 100, forKey: kCIInputScaleKey)
        }
        
        
        //接下来麻烦的是：我们需要将过滤器的输出转换为可以在视图中显示的 SwiftUI Image 。这是需要同时依赖所有四种图像类型的地方：
        //1. 从过滤器中读取输出图像，这将是 CIImage 。这可能会失败，因此它返回一个可选值。
        //2. 要求我们的【上下文】从该输出图像创建一个 CGImage 。这也可能会失败，因此它再次返回一个optional。
        //3. 将 CGImage 转换为 UIImage
        //4. 将 UIImage 转换为 SwiftUI Image
        //注意：虽然可以直接从 CGImage 转到 SwiftUI Image ，但它需要额外的参数，只会增加更多的复杂性！
        
        //1. get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        //2. attempt to get a CGImage from our CIImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        // convert that to a UIImage
        let uiImage = UIImage(cgImage: cgImage)
        
        // and convert that to a SwiftUI image
        image = Image(uiImage: uiImage)
        
    }
    
    
}



#Preview {
    ContentView()
}
