//
//  ContentView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/24.
//

import CoreData
import SwiftUI

struct ContentView: View {
    
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    
    var body:some View {
        
        VStack {
            List(students) {
                student in
                Text(student.name ?? "Unknown")
            }
            
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!
                
                let student = Student(context: moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                
                //最后，需要要求托管对象上下文保存自身，这意味着它将其更改写入持久存储。
                //这是一个抛出函数（理论上它可能会失败）。但实际上没有失败的可能，因此可以使用 try? 来调用它，代表不关心捕获的具体错误。
                try? moc.save()
            }
        }
        
    }
    
}



#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
