//
//  CoreDataDemoTwoView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

import SwiftUI

struct CoreDataDemoTwoView: View {
    
    //MARK: - 属性
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var lastNameFilter = "A"
    

    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            Text("动态查询，从父视图传递状态参数进子视图去查询")
                .font(.caption2)
            
            // list of matching singers
            FilteredListView(filter: lastNameFilter)

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

            Button("Show A") {
                lastNameFilter = "A"
            }

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
