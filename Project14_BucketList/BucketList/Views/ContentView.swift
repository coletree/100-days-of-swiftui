//
//  ContentView.swift
//  BucketList
//
//  Created by coletree on 2024/1/15.
//
import LocalAuthentication
import MapKit
import SwiftUI




struct ContentView: View {
    
    
    //MARK: - 属性
    
    //VM属性：使用了 MVVM 模式后，大部份数据放入了 ViewModel 类中，这里只需要声明一个 ViewModel 实例
    //并且加上 @State 关键词，一旦里面的任何数据发生改变，就会影响视图
    @State private var viewModel = ViewModel()
    
    //状态属性：
    @State private var mapType = 0
    //@State private var mapType = MapStyle.standard
    
    //状态属性：测试看能不能传到 stateDemoView 视图
    @State private var value = 99
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        if viewModel.isUnlocked {
            //1. 已解锁的情况下：
            //MapReader 做地图坐标转换
            ZStack {
                
                //地图
                switch mapType {
                case 0:
                    MapReader {
                        proxy in
                        
                        //通过 viewModel 类的属性去获取数据
                        Map(initialPosition: viewModel.startPosition) {
                            //循环数组，读取所有标记
                            ForEach(viewModel.locations) {
                                location in
                                //Marker(location.name, coordinate: location.coordinate)
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            //当用户长按视图，会将该 location 赋值给 selectedPlace
                                            viewModel.selectedPlace = location
                                        }
                                }
                            }
                        }
                        .mapStyle(.standard)
                        .onTapGesture {
                            position in
                                if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        //可能有一个选定的位置，也可能没有，这就是 SwiftUI 为了呈现表格而需要知道的全部内容。
                        //一旦将一个值放入该选项中，就会告诉 SwiftUI 显示该工作表
                        //并且当该工作表被关闭时，该值将自动设置回 nil 。
                        //更好的是 SwiftUI 会自动解开可选内容，因此当创建工作表内容时，可以确保有真正的值可以使用。
                        .sheet(item: $viewModel.selectedPlace) {
                            place in
                            //目标视图：创建目标视图实例，包含两个参数
                            //1. 第一个参数是绑定的可选值 location
                            //2. 第二个参数是一个闭包函数，传入给目标视图
                            EditView(location: place) {
                                //这个闭包其实执行的是 update 函数，它会找到某位置的具体索引，更新为 selectedPlace
                                viewModel.update(location: $0)
                            }
                        }
                        .alert(isPresented: $viewModel.authenError) { () ->
                            Alert in
                            return Alert(
                                title: Text("认证失败"),
                                message: Text("Please authenticate yourself to unlock your places."),
                                dismissButton: .default(Text("Got It"))
                            )
                        }
                        .ignoresSafeArea(.all)
                    }
                default:
                    MapReader {
                        proxy in
                        Map(initialPosition: viewModel.startPosition) {
                            //循环数组，读取所有标记
                            ForEach(viewModel.locations) {
                                location in
                                //Marker(location.name, coordinate: location.coordinate)
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            //当用户长按视图，会将该 location 赋值给 selectedPlace
                                            viewModel.selectedPlace = location
                                        }
                                }
                            }
                        }
                        .mapStyle(.hybrid)
                        .onTapGesture {
                            position in
                                if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        //可能有一个选定的位置，也可能没有，这就是 SwiftUI 为了呈现表格而需要知道的全部内容。
                        //一旦将一个值放入该选项中，就会告诉 SwiftUI 显示该工作表
                        //并且当该工作表被关闭时，该值将自动设置回 nil 。
                        //更好的是 SwiftUI 会自动解开可选内容，因此当创建工作表内容时，可以确保有真正的值可以使用。
                        .sheet(item: $viewModel.selectedPlace) {
                            place in
                            //后半截是一个闭包，准备传入给子视图
                            EditView(location: place) {
                                //传入的是 update 函数，它会找到某位置的具体索引，更新为 selectedPlace
                                viewModel.update(location: $0)
                            }
                        }
                        .ignoresSafeArea(.all)
                    }
                }

                
                //切换地图模式的按钮
                VStack {
                    HStack {
                        Spacer()
                        Picker(selection: $mapType, label: Text("类型")){
                            Text("Standar").tag(0)
                            Text("Hybrid").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                    Spacer()
                }
                .padding()
                
            }
        } else {
            //2. 未解锁的情况下：
            NavigationStack{
                
                NavigationLink {
                    StateDemoView(number: value)
                } label: {
                    Text("\(value)")
                }

                //按钮：触发认证
                Button("Unlock Places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .alert(isPresented: $viewModel.authenError) { () ->
                        Alert in
                        return Alert(
                            title: Text("No,认证失败"),
                            message: Text("Please authenticate yourself to unlock your places."),
                            dismissButton: .default(Text("Got It"))
                        )
                    }
                
            }
            

        }
        
        
    }
    
    
    
}






//MARK: - 预览
#Preview {
    ContentView()
}
