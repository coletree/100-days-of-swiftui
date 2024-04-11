//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by coletree on 2024/2/28.
//

import SwiftUI


struct ContentView: View {
    
    
    //MARK: - 属性
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    
    //MARK: - 视图
    var body: some View {
        
        GeometryReader { 
            
            fullView in
            
            ScrollView(.vertical) {
                
                ForEach(0..<50) {
                    
                    index in
                    
                    GeometryReader {
                        
                        proxy in
                        
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                        
                            //设置颜色：用求余数的方式，从前面的颜色数组中取值
                            //.background(colors[index % 7])
                            //设置颜色：直接运算给 hue 赋值
                            .background(
                                Color(
                                    hue: min(
                                        proxy.frame(in: .global).minY/fullView.frame(in: .global).height,
                                        1),
                                    saturation: 1,
                                    brightness: 1
                                )
                            )
                            //设置透明度：
                            .opacity( proxy.frame(in: .global).minY / 500 )
                            //设置放大效果：
                            .scaleEffect(
                                min(
                                    1.2,
                                    proxy.frame(in: .global).minY / (fullView.frame(in: .global).height) * 2)
                            )
                            //设置3D旋转效果：
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                    }
                    //限制 GeometryReader 的高度为 40
                    .frame(height: 40)
                }
            }
        }
    }
}



struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(.green)
            Text("Bottom")
        }
        //.background(.brown)
    }
}


struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { proxy in
                Text("Center")
                    .background(.blue)
                    .onTapGesture {
                        print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
                        print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
                        print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
                    }
            }
            .background(.orange)
            Text("Right")
        }
    }
}


//自定义辅助线扩展
//extension VerticalAlignment {
//    struct MidAccountAndName: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            context[.leading]
//        }
//    }
//
//    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
//}


//MARK: - 预览
#Preview {
    ContentView()
}
