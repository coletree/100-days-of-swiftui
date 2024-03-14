//
//  ResortView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/5.
//


import SwiftUI


/*
ResortView 布局非常简单 – 只不过是一个滚动视图、一个 VStack 、一个 Image 和一些 Text 。
唯一有趣的部分是将使用 resort.facilities.joined(separator: ", ") 获取单个字符串，
将度假村的设施显示为单个文本视图。
*/


struct ResortView: View {
    
    
    //MARK: - 属性
    
    //常量属性：resort 数据，等待传入
    let resort: Resort
    
    //环境属性：
    @Environment(\.horizontalSizeClass) var sizeClass
    //@Environment(\.verticalSizeClass) var sizeClass
    
    //状态属性：希望将 Facility 图像制作成按钮，以便点击后显示 alert
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    //由于 favorites 类被附加到 contentView 导航视图，所以导航视图呈现的每个视图也将获得要使用的 Favorites 实例
    //因此，我们可以通过添加以下新属性从 ResortView 内部加载它：
    @EnvironmentObject var favorites: Favorites
    

    
    
    //MARK: - 视图
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0){
                
                //顶部图片
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
//                        .overlay {
//                            GeometryReader{ 
//                                geometry in
//                                Text(resort.imageCredit)
//                                    .foregroundStyle(Color.white)
//                                    .padding()
//                                    .background(.red)
//                                    .offset(x: geometry.frame(in: .local).minX, y: geometry.frame(in: .local).maxY - 54)
//                                    
//                            }
//                        }
                    Text(resort.imageCredit)
                        .font(.custom("", size: 14.0))
                        .padding(10)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.6))
                        .offset(x: -5, y: -5)
                }
                
                //两个子视图，在不同的 size class 下的两种布局
                HStack {
                        //如果横向空间 horizontalSizeClass == 紧凑，则
                    if sizeClass == .compact {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    }
                        //如果横向空间不等于紧凑，则
                        else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))

                //详细介绍
                Group{
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    //从字符串数组，创建一个字符串
                    Text(resort.facilities.joined(separator: ", "))
                        .padding(.vertical)
                    
                    Text(resort.facilities, format: .list(type: .and))
                        .padding(.vertical)
                    
                    Text(resort.facilities, format: .list(type: .or))
                        .padding(.vertical)
                    
                    //循环获取 facilityTypes 属性：
                    HStack(spacing: 20) {
                        //它循环遍历 facilities 数组中的每个项目，将其转换为图标，放入 HStack 中
                        ForEach(resort.facilityTypes) { 
                            facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                //返回的是一个个Image视图
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                }
                .padding()
                
                
                //收藏按钮
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                    //如果收藏集合里已经有该对象，则点击后去除
                    if favorites.contains(resort) {
                        favorites.remove(resort)
                    }
                    //如果收藏集合里没有该对象，则点击后加上
                    else {
                        favorites.add(resort)
                    }
                }
                //.buttonStyle(favorites.contains(resort) ? .borderedProminent : .)
                .padding()
                .foregroundStyle(Color.white)
                .background(favorites.contains(resort) ? Color.red : Color.green)
                .padding()
                
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        //点击设施图标，弹出的弹窗
        .alert(
            selectedFacility?.name ?? "More information",
            isPresented: $showingFacility,
            presenting: selectedFacility
        )
        {
            //第1个闭包：我们让系统提供默认的“确定”按钮,_ in代表不需要任何按钮
            _ in
        }
        message: {
            //第2个闭包：根据设施名字获取具体说明文案，因此需要 facility
            facility in
            Text(facility.description)
        }
        
    }
    
}





//MARK: - 预览
#Preview {
    //由于有环境变量，请确保修改预览，以将示例的 Favorites 对象注入到环境中，以便您的 SwiftUI 预览继续工作
    ResortView(resort: Resort.example)
        //加上修饰符 .environmentObject(Favorites())
        .environmentObject(Favorites())
}
