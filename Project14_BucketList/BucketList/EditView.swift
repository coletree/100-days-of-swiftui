//
//  EditView.swift
//  BucketList
//
//  Created by coletree on 2024/1/16.
//

import SwiftUI

struct EditView: View {
    
    //MARK: - 属性
    
    //环境变量：用于解除视图
    @Environment(\.dismiss) var dismiss
    
    //VM属性：引入了 ViewModel 的数据
    @State private var viewModel : ViewModel
    
    //参数：是一个函数。等待别的视图传进来一个闭包
    var onSave: (Location) -> Void

    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("附近…") {
                    switch viewModel.loadingState {
                        case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { 
                                page in
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                            }
                        case .loading:
                            Text("Loading…")
                        case .failed:
                            Text("Please try again later.")
                    }
                }
                
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
        
    }
    
    
    
    //方法：新的初始化函数。在初始化时，自动读取 locations 数据。
    init(location: Location, onSave: @escaping (Location) -> Void) {
        //传入闭包
        self.onSave = onSave
        //初始化 @State 状态参数
        _viewModel = State(wrappedValue: ViewModel(location: location))

    }
    
}



//MARK: - 预览
#Preview {
    //EditView(location: Location.example, onSave: (Location) -> Void)
    //由于第二个参数是一个函数，所以可以写成闭包；该闭包什么都不返回，只需要写个占位的参数
    EditView(location: Location.example){ _ in }
}
