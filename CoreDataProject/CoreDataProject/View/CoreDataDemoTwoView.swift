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
    @State private var filterKey: String? = nil
    @State private var firstNameFilter = "T"
    @State private var filterType = FilterType.beginsWith
    @State private var sortDescriptors = [SortDescriptor<Singer>]()
    
    
    
    //环境属性：CoreData托管对象上下文
    @Environment(\.managedObjectContext) var moc
    
    


    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            Text("动态查询，从父视图传递状态参数进子视图去查询").font(.caption2)
            
            //1.使用动态数据的列表子视图
            //FilteredListView(filter: lastNameFilter)
            
            //2.使用【泛型】的动态数据列表子视图，传入两个参数以及一个视图闭包
//            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) {
//                (singer: Singer) in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }
            
//            FilteredList(type: filterType, filterKey: "firstName", filterValue: firstNameFilter) {
//                (singer: Singer) in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }
            
//            FilteredList(
//                    type: filterType,
//                    filterKey: "firstName",
//                    filterValue: firstNameFilter,
//                    sortDescriptors: sortDescriptors
//            ) {
//                (singer: Singer) in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }
            
            
            FilteredList(
                    type: filterType,
                    filterKey: filterKey,
                    filterValue: firstNameFilter,
                    sortDescriptors: sortDescriptors
            ) {
                (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }


            
            VStack {
                HStack {
                    //按钮：添加测试数据
                    Button("Add Examples") {
                        let taylor = Singer(context: moc)
                        taylor.firstName = "Taylor泰勒"
                        taylor.lastName = "Swift"
                        
                        let ed = Singer(context: moc)
                        ed.firstName = "EdT额"
                        ed.lastName = "Sheeran"
                        
                        let adele = Singer(context: moc)
                        adele.firstName = "AdeleT啊"
                        adele.lastName = "Adkins"
                        
                        try? moc.save()
                    }
                }
//                HStack {
//                    Button("Show A") {
//                        firstNameFilter = "A"
//                    }
//                    Button("Show S") {
//                        firstNameFilter = "S"
//                    }
//                }
                HStack {
                    Spacer()
                    Button("Begins with") {
                        filterKey = "firstName"
                        filterType = .beginsWith
                    }
                    Spacer()
                    Button("Contains") {
                        filterKey = "firstName"
                        filterType = .contains
                    }
                    Spacer()
                    Button("All") {
                        filterKey = nil
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button("Sort A-Z") { sortDescriptors = [SortDescriptor(\.firstName)] }
                    Spacer()
                    Button("Sort Z-A") { sortDescriptors = [SortDescriptor(\.firstName, order: .reverse)] }
                    Spacer()
                }
            }
            


            
        }
        
    }
    
    
}




//MARK: - 预览
#Preview {
    CoreDataDemoTwoView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
