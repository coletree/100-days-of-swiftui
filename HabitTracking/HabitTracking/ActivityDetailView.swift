//
//  ActivityDetailView.swift
//  HabitTracking
//
//  Created by coletree on 2023/12/20.
//

import SwiftUI

struct ActivityDetailView: View {
    
    //MARK: - 数据属性
    
    //定义类 ActivitiesData 属性：等待接收传入的参数
    var myActivities : ActivitiesData
    
    //定义结构体 Activity 属性：等待接收传入的参数
    var inActivity : Activity
    
    //定义整数属性：用于记录 inActivity 在 myActivities 类的 activities 数组中的索引值
    var indexNum : Int = 0
    
    //定义状态参数：用于做视图中的绑定编辑。在初始化时修改它的值为传入的 inActivity
    @State var newActivity : Activity = Activity(name: "", intro: "", count: 0)
    
    //自定义解除导航的环境属性
    //@Environment(\.presentationMode) var presentationMode
    

    
    //MARK: - 主要视图
    var body: some View {
        VStack(spacing: 8) {
            
            Spacer()
            
            VStack(spacing: 10) {
                Text(newActivity.name)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(.primary)
                Text(newActivity.intro)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 40)
            
            Button(action: {
                //方法：点击该按钮进行 +1 计数，并且保存更新至类 myActivities
                newActivity.count += 1
                saveActivity()
            }, label: {
                ZStack{
                    Circle()
                        .frame(width: 120, height: 120, alignment: .center)
                        .foregroundStyle(.blue)
                    Text("\(newActivity.count)")
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .backgroundStyle(.clear)
                }

            })
            
            Spacer()
        }
        //.navigationBarBackButtonHidden(true)
    }
   
    
    //MARK: - 初始化方法
    init(activities: ActivitiesData, activity: Activity) {
        
        //1.接收两个传入的参数
        self.myActivities = activities
        self.inActivity = activity
        
        //2.提取 activity 在 activities 数组中的索引值，方便后面使用
        if let index = myActivities.activities.firstIndex(of: activity) {
            indexNum = index
        }
        
        //3.初始化 State 状态参数
        _newActivity = State(initialValue: inActivity)
        
    }
    
    
    //MARK: - 其他方法
    
    //1.保存数据：更新 ActivitiesData 类（在类内部有属性观察，一旦值改变，那边会调用保存到 UserDefault 的方法）
    func saveActivity(){
        myActivities.activities[indexNum] = newActivity
        //print(myActivities.activities)
        print("完成保存.....")
    }
    
}



//MARK: - 预览
#Preview {
    ActivityDetailView(activities: ActivitiesData(), activity: Activity(name: "标题", intro: "介绍", count: 8))
}
