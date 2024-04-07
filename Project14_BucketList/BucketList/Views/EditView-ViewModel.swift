//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by coletree on 2024/1/20.
//

import Foundation
import LocalAuthentication
import MapKit
import SwiftUI




// MARK: - 创建视图扩展
extension EditView {
    
    
    @Observable
    class ViewModel{
        
        //MARK: - 属性
        
        //状态参数：地点名字
        var name: String
        
        //状态参数：地点描述
        var description: String
        
        //状态参数：表示数据加载状态
        var loadingState = LoadingState.loading
        
        //状态参数：获取完成后存储维基百科页面的数组
        var pages = [Page]()
        
        //参数：
        var location: Location
        
        //参数：定义数据读取状态
        enum LoadingState {
            case loading, loaded, failed
        }
        
        
        
        //MARK: - 方法
        
        //方法：初始化
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
        
        //方法：根据经纬度读取维基百科的数据
        func fetchNearbyPlaces() async {
            
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            print("\(urlString)")
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                //pages = items.query.pages.values.sorted { $0.title < $1.title }
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
                
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
        
        //方法：创建新地点
        func createNewLocation() -> Location{
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
        
        
    }
    
}

