//
//  ContentView.swift
//  SnowSeeker
//
//  Created by coletree on 2024/3/2.
//

import SwiftUI

struct ContentView: View {
    
    
    //MARK: - 属性
    
    //常量：加载所有休闲度假胜地
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    //状态参数：检索词
    @State private var searchText = ""
    
    //需要一个计算属性来处理数据过滤。
    //如果我们的新 searchText 属性为空，那么我们可以发回我们加载的所有度假村
    //否则我们将使用 localizedCaseInsensitiveContains() 根据搜索条件过滤数组：
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        //分屏导航视图
        NavigationSplitView(
            
            //左侧：主视图。
            sidebar: {
                
                List(filteredResorts) {
                    resort in
                    NavigationLink{
                        //导航到 ResortView 的详情视图
                        ResortView(resort: resort)
                    } label: {
                        HStack(spacing: 30) {
                            Image(resort.country)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .scaledToFill()
                                .frame(width: 64, height: 40, alignment: .center)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 8)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.black, lineWidth: 1)
                                )
                            VStack(alignment: .leading) {
                                Text(resort.name)
                                    .font(.headline)
                                Text("\(resort.runs) runs")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    }
                    //该修饰符可强制控制 NavigationLink 的行为
                    .navigationSplitViewStyle(.prominentDetail)
                }
                .navigationTitle("Resorts")
                .searchable(text: $searchText, prompt: "Search for a resort")
                
            },
            
            //右侧：辅助视图。通过点击主视图中的 navigationLink 弹出
            detail: {
                WelcomeView()
            }
        )
        .phoneOnlyStackNavigationView()
        
    }

    
    
    //MARK: - 方法

    
    
}




//MARK: - 其他
struct User: Identifiable {
    var id = "Taylor Swift"
}


/*
UIKit 允许我们控制主视图是否在 iPad 上应显示纵向，但这在 SwiftUI 中尚不可能；
但是如果您想要的话，可以阻止 iPhone 上的主视图使用滑出方法。具体请将此扩展添加到项目中；
 
它使用 Apple 的 UIDevice 类来检测当前是在手机还是平板电脑上运行，
如果是手机则启用更简单的 StackNavigationViewStyle 方法
这里需要使用 @ViewBuilder 属性，因为返回的两个视图类型不同。

拥有该扩展后，只需将 .phoneOnlyStackNavigationView() 修饰符添加到 NavigationView 中，
以便 iPad 保留其默认行为，而 iPhone 始终使用堆栈导航。

提示：我不会在自己的项目中使用此修改器，因为我更喜欢尽可能使用 Apple 的默认行为
*/
extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}




//MARK: - 预览
#Preview {
    ContentView()
}
