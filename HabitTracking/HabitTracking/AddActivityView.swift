//
//  AddActivityView.swift
//  HabitTracking
//
//  Created by coletree on 2023/12/20.
//

import SwiftUI

struct AddActivityView: View {
    
    //MARK: - 数据属性
    
    //定义类 ActivitiesData 属性：等待接收传入的参数
    var myActivities : ActivitiesData
    
    //定义环境参数：用于解除视图
    @Environment(\.dismiss) var dismissIt
    
    //定义状态参数：用于编辑
    @State private var title = "标题"
    @State private var intro = "介绍"
    
    
    //MARK: - 视图主体
    var body: some View {
        
        ScrollView{
            
            VStack(alignment: .leading, spacing: 10){
                
                VStack(alignment: .leading, spacing: 10){
                    Text("标题：")
                        .fontWeight(.bold)
                    TextField("这里就是输入占位符", text: $title)
                        .font(Font.system(size: 18, design: Font.Design.serif))
                        .foregroundStyle(.secondary)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer(minLength: 20)
                    
                    Text("说明：")
                        .fontWeight(.bold)
                    TextField("介绍", text: $intro)
                        .font(Font.system(size: 18, design: Font.Design.serif))
                        .foregroundStyle(.secondary)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer(minLength: 20)
                
                Button(action: {
                    //方法：点击按钮保存数据，并且返回
                    let newActivity = Activity(name: title, intro: intro, count: 0)
                    myActivities.activities.insert(newActivity, at: 0)
                    dismissIt()
                }, label: {
                    Text("保存")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                        .padding(15)
                        .background(.blue)
                        .cornerRadius(10)
                })
                
            }
            
        }
        .padding(20)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") {
                    //方法：取消按钮，点击后返回上一级根视图
                    dismissIt()
                }
            }
        }
        
    }
    
}




//MARK: - 预览
#Preview {
    AddActivityView(myActivities: ActivitiesData())
}
