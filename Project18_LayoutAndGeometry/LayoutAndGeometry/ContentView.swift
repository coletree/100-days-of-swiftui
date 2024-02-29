//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by coletree on 2024/2/28.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { 
                        proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            //.background(colors[index % 7])
                            .background(
                                Color(
                                    hue: min(proxy.frame(in: .global).minY / 660, 1),
                                    saturation: min(proxy.frame(in: .global).minY / 460, 1),
                                    brightness: min(proxy.frame(in: .global).minY / 200, 1)
                                )
                            )
                            .opacity( 1 - Double(200 - proxy.frame(in: .global).minY)/120 )
                            .scaleEffect(
                                CGSize(
                                width:
                                    min( proxy.frame(in: .global).maxY/fullView.frame(in: .global).height + 0.1, 1),
                                height: 
                                    min( proxy.frame(in: .global).maxY/fullView.frame(in: .global).height + 0.5, 1)
                                ),
                                    anchor: .center
                                )
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                    }
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



extension VerticalAlignment {
    struct MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}


#Preview {
    ContentView()
}
