//
//  CoreDataDemoOneView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

import CoreData
import SwiftUI




struct CoreDataDemoOneView: View {
    
    
    //MARK: - 属性
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "name CONTAINS[c] %@", "d")
    ) var ships: FetchedResults<Ship>
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            Text("生成一些Ship，在查询的时候过滤")
                .font(.caption2)
            
            List(ships, id: \.self) {
                ship in
                Text(ship.name ?? "Unknown name")
            }
            
            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? moc.save()
            }
            
        }
        
    }
    
}


//MARK: - 预览
#Preview {
    CoreDataDemoOneView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
