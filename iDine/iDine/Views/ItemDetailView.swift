//
//  ItemDetailView.swift
//  iDine
//
//  Created by coletree on 2024/4/18.
//

import SwiftUI





struct ItemDetailView: View {
    
    
    //MARK: - 属性
    
    //常量属性：定义一个储存每种 restrictions 类型对应颜色的字典
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]
    
    //变量属性：等待传入一个 MenuItem 对象
    var item : MenuItem
    
    //环境属性：读取在 App.swift 文件中定义的 order 属性
    @Environment(Order.self) var order
    
    //环境属性：读取在 App.swift 文件中定义的 order 属性
    @Environment(Favor.self) var favor
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            //视图：封面图像 + 水印
            ZStack(alignment: .bottomTrailing)  {
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()
                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(.black)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .offset(x: -5, y: -5)
            }
            
            //视图：restrictions 标签
            HStack {
                ForEach(item.restrictions, id: \.self) {
                    restriction in
                    Text(restriction)
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(5)
                        .background(colors[restriction, default: .black])
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                }
            }
            .padding(.top, 15)
            
            //视图：详情介绍
            Text(item.description)
                .padding()
            
            
            HStack(spacing:20) {
                //视图：添加到购物车的按钮。入参是一个 MenuItem
                Button("Order This") {
                    order.add(item: item)
                }
                .buttonStyle(.borderedProminent)
                
                if favor.favorItems.contains(item){
                    
                    //视图：收藏按钮。入参是一个 MenuItem
                    Button("已收藏") {
                        //
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                    .disabled(true)
                    
                }else{
                    
                    //视图：收藏按钮。入参是一个 MenuItem
                    Button("Favor This") {
                        favor.add(item: item)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    
                }
                
                
            }
            
            Spacer()
            
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    //加上这个可以预览 ItemDetailView 在导航堆栈中的情况
    NavigationStack {
        ItemDetailView(item: MenuItem.example)
            //加上环境属性后，预览必须加上这行代码
            .environment(Order())
            .environment(Favor())
    }
}
