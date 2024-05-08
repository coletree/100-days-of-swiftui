//
//  AwardsView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/8.
//

import SwiftUI

struct AwardsView: View {
    
    
    //MARK: - 属性
    
    
    //计算属性：定义将使用的列
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    //环境属性：从环境中读取 dataController 实例
    @EnvironmentObject var dataController: DataController
    
    //状态属性：控制徽章弹窗
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    
    var awardTitle: String {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
        }
    }
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            ScrollView(){
                
                //将以 LazyVGrid 一系列按钮的形式显示奖励选项
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) {
                        award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5))
                        }

                    }
                }
                
            }
            .navigationTitle("Awards")
            //徽章弹窗
            .alert(awardTitle, isPresented: $showingAwardDetails){
                Button("好的", role: .cancel) { }
            } message: {
                Text(selectedAward.description)
            }
            
        }
        
    }
    
    
    //MARK: - 方法
    
    
    
    
}




//MARK: - 预览
#Preview {
    AwardsView()
    //预览代码加上 .preview ，这个是之前在 DataController 就创建好的静态属性，用于测试
    .environmentObject(DataController.preview)
}
