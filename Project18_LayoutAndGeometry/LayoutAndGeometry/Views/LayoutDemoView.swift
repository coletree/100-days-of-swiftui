//
//  LayoutDemoView.swift
//  LayoutAndGeometry
//
//  Created by coletree on 2024/4/10.
//

import SwiftUI



struct LayoutDemoView: View {
    
    var body: some View {
        
        GeometryReader { proxy in
            Image(.example)
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width * 0.8)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        
        
        HStack(alignment: .midAccountAndName){
            VStack {
                Text("@twostraws")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.top] - 4 }
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            VStack {
                Text("Full name:")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.bottom] }
                    .font(.largeTitle)
                Text("PAUL HUDSON")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.top] }
                    .font(.largeTitle)
            }
        }

        
//        VStack(alignment: .leading) {
//            Text("AAAA")
//                .alignmentGuide(.leading) {
//                    d in d[.trailing]
//                }
//            Text("BBBBBBBB")
//                .alignmentGuide(.leading) {
//                    d in -d[.trailing]
//                }
//            Text("CCCCCCCCCC")
//                .alignmentGuide(.trailing) { _ in 2000 }
//        }
//        .background(.red)
//        .frame(width: 400, height: 200)
//        .background(.blue)
        
        
//        VStack(alignment: .leading) {
//            Text("Hello, world!")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//            Text("This is a longer line of text")
//        }
//        .background(.red)
//        .frame(width: 400, height: 200)
//        .background(.blue)
        
        
        
//        VStack {
//            Text("Today's Weather")
//                .font(.title)
//                .border(.gray)
//            
//            HStack {
//                Text("🌧")
//                    .alignmentGuide(VerticalAlignment.center) { _ in -10 }
//                    .border(.gray)
//                Text("Rain & Thunderstorms")
//                    .border(.gray)
//                Text("⛈")
//                    .alignmentGuide(VerticalAlignment.center) { _ in 80 }
//                    .border(.gray)
//            }
//        }
//        .background(.red)
//        .frame(width: 400, height: 400)
//        .background(.blue)
        
    }
}


extension VerticalAlignment {
    //遵循 AlignmentID 协议
    struct MidAccountAndName: AlignmentID {
        //实作静态的 defaultValue(in:) 方法
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}



#Preview {
    LayoutDemoView()
}
