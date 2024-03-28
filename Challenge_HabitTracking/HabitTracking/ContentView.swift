//
//  ContentView.swift
//  HabitTracking
//
//  Created by coletree on 2023/12/20.
//

import SwiftUI




struct ContentView: View {
    
    
    //MARK: - 属性
    
    //状态参数：生成一个 ActivitiesData 类的实例
    @State private var myActivities = ActivitiesData()
    
    //状态参数：控制新建 sheet 视图是否弹出
    //@State private var showAddSheet = false
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            //视图：习惯列表
            List(myActivities.activities) {
                item in
                //视图：单个习惯链接。添加导航附加值是 myActivities 类中 activities数组的单个元素，即 Activity
                NavigationLink(value: item) {
                    HStack(spacing: 8){
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundStyle(.primary)
                            Text(item.intro)
                                .font(.system(size: 13, weight: .regular, design: .default))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .center, spacing: 4){
                            Text(String(item.count))
                                .font(.system(size: 20, weight: .heavy, design: .default))
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }
            .navigationTitle("习惯记录")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink("新增+") {
                        AddActivityView(myActivities: myActivities)
                    }
                }
            }
            //方法：定义导航链接指向的子视图。传递的附加值是 Activity 结构体
            .navigationDestination(for: Activity.self) {
                item in
                //当导航的值是 Activity 时，去到以下子视图。并且这时传过去两个参数 activities 和 activity
                //因此，子视图那边需要定义这两个参数进行接收
                ActivityDetailView(activities: myActivities, activity: item)
            }
            //视图：新增习惯视图
//            .sheet(isPresented: $showAddSheet){
//                AddActivityView(myActivities: myActivities)
//            }
        }
        
    }
    
}




//MARK: - 预览
#Preview {
    ContentView()
}
