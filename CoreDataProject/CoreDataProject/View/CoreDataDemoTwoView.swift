//
//  CoreDataDemoTwoView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

import SwiftUI

struct CoreDataDemoTwoView: View {
    
    
    //MARK: - 属性
    
    //状态属性：用于传入到子视图去进行动态查询
    @State private var lastNameFilter = "A"
    
    //环境属性：CoreData托管对象上下文
    @Environment(\.managedObjectContext) var moc
    

    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            Text("动态查询，从父视图传递状态参数进子视图去查询").font(.caption2)
            
            //1.使用动态数据的列表子视图
            //FilteredListView(filter: lastNameFilter)
            
            //2.使用【泛型】的动态数据列表子视图，传入两个参数以及一个视图闭包
            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) {
                (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            //按钮：添加测试数据
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }
            
            //按钮：更新过滤条件显示数据
            Button("Show A") {
                lastNameFilter = "A"
            }
            
            //按钮：更新过滤条件显示数据
            Button("Show S") {
                lastNameFilter = "S"
            }
            
        }
        
    }
    
    
}




//MARK: - 预览
#Preview {
    CoreDataDemoTwoView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
