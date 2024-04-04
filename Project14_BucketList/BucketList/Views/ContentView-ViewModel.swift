//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by coletree on 2024/1/17.
//

import Foundation
import LocalAuthentication
import MapKit
import SwiftUI




// MARK: - 创建视图扩展
//首先创建 ContentView 视图的扩展，里面会包含 ViewModel
extension ContentView {
    
    
    // MARK: - ViewModel 视图模型
    // 创建一个使用 Observable 宏的新类： ViewModel，以便能够从任何监视的 SwiftUI 视图中报告更改
    // MVVM 的逻辑就是创建一个类的实例来管理数据，它会代表 ContentView 去操作数据，以便达到视图和数据逻辑分离的目的
    @Observable
    class ViewModel {
        
        
        // MARK: - 类的属性
        
        //常量属性：地图的初始位置（这属于swiftUI中的，需要额外导入 swiftUI 库，因此移进来不知道是否合理）
        let startPosition = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        )
        
        //变量属性：生物认证状态
        var isUnlocked = false
        var authenError = false
        
        //常量属性：添加一个新属性来记录数据要保存的位置
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        //状态属性：储存所有位置数据的数组
        private(set) var locations: [Location]
        
        //状态属性：检查用户选择的地点（Location遵循了Equatable协议使其成为可能）
        var selectedPlace: Location?
        
        
        
        
        // MARK: - 类的方法
        
        //方法：新的初始化函数。在类初始化时，自动读取 locations 数据
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
                print(locations)
            } catch {
                locations = []
            }
        }
        
        
        //方法：数据保存方法。
        //使用这种方法，可以在任意数量的文件中写入任意数量的数据
        //这比 UserDefaults 灵活得多，并且还允许我们根据需要加载和保存数据，而不是像 UserDefaults  那样在应用程序启动时立即加载和保存数据
        //在数据写入选项中添加 .completeFileProtection 即可确保文件以强加密方式存储
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        
        //方法：添加地点
        func addLocation(at point: CLLocationCoordinate2D) {
            //创建新的 Location 对象
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            //写入文件
            save()
        }
        
        
        //方法：更新地点
        func update(location: Location) {
            guard let selectedPlace else { return }
            //找到用户所选择地点，在整个数组中的位置索引
            if let index = locations.firstIndex(of: selectedPlace) {
                //再将该数组的索引位置的对象，替换成新对象
                locations[index] = location
            }
            //写入文件
            save()
        }
        
        
        //方法：生物认证
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { 
                    success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                        self.authenError = true
                    }
                }
            } else {
                // no biometrics
            }
        }
        
        
    }
    
    
}
